funcs <- list(
  #----------#
  purple = list(
    #----------#
    qc = function(dat) {
      get_fill_colour <- function(field, value) {
        green <- "#90EE90"
        orange <- "#FFA500"
        red <- "#FF6B6B"

        # Convert to numeric where needed
        num_val <- suppressWarnings(as.numeric(value))

        colour <- dplyr::case_when(
          field == "qc_status" & value == "PASS" ~ green,
          field == "qc_status" & grepl("WARN", value) ~ orange,
          field == "qc_status" & grepl("FAIL", value) ~ red,
          field == "qc_status" ~ red,

          field == "method" & value == "NORMAL" ~ green,
          field == "method" & value %in% c("HIGHLY_DIPLOID", "SOMATIC") ~ orange,
          field == "method" & value == "NO_TUMOR" ~ red,
          field == "method" ~ red,

          field == "unsupported_cn_segments" & num_val == 0 ~ green,
          field == "unsupported_cn_segments" & num_val > 0 & num_val <= 10 ~ orange,
          field == "unsupported_cn_segments" & num_val > 10 ~ red,
          field == "unsupported_cn_segments" ~ red,

          field == "purity" & num_val >= 0.8 & num_val <= 1 ~ green,
          field == "purity" & num_val >= 0.25 & num_val < 0.8 ~ orange,
          field == "purity" & num_val >= 0 & num_val < 0.25 ~ red,
          field == "purity" ~ red,

          # consolidated gender field
          field == "gender" & !grepl("/", value) ~ green,
          field == "gender" & grepl("/", value) ~ red,

          field == "deleted_genes" & num_val >= 0 & num_val < 100 ~ green,
          field == "deleted_genes" & num_val >= 100 & num_val < 200 ~ orange,
          field == "deleted_genes" & num_val >= 200 ~ red,
          field == "deleted_genes" ~ red,

          field == "contamination" & num_val == 0 ~ green,
          field == "contamination" & num_val > 0 ~ red,
          field == "contamination" ~ red,

          field == "germline_aberrations" & value == "NONE" ~ green,
          field == "germline_aberrations" & value != "NONE" ~ red,

          field == "mean_depth_amber" & num_val > 0 & num_val < 25 ~ red,
          field == "mean_depth_amber" & num_val >= 25 & num_val <= 150 ~ green,
          field == "mean_depth_amber" & num_val > 150 ~ orange,
          field == "mean_depth_amber" ~ red,

          field == "loh_percent" & num_val > 0 & num_val < 0.5 ~ green,
          field == "loh_percent" & num_val >= 0.5 & num_val <= 0.8 ~ orange,
          field == "loh_percent" & num_val > 0.8 ~ red,
          field == "loh_percent" ~ red,

          field == "tinc_level" & num_val == 0 ~ green,
          field == "tinc_level" & num_val > 0 ~ red,

          field == "chimerism_percent" & num_val == 0 ~ green,
          field == "chimerism_percent" & num_val > 0 ~ red,
          field == "chimerism_percent" ~ red,

          field == "cn_segments" & num_val > 0 ~ green,
          field == "cn_segments" ~ red,

          .default = "white"
        )
        return(colour)
      }
      stopifnot(all(c("data", "schemas") %in% names(dat)))
      d <- dat$data |>
        funcs$unnest_data("purple_qc", schemas_all = dat$schemas)
      d1 <- d$res |>
        dplyr::mutate(
          gender = dplyr::if_else(
            .data$gender_amber == .data$gender_cobalt,
            .data$gender_amber,
            paste(.data$gender_amber, .data$gender_cobalt, sep = "/")
          )
        ) |>
        dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) |>
        dplyr::select(-c("gender_amber", "gender_cobalt")) |>
        tidyr::pivot_longer(dplyr::everything(), names_to = "field") |>
        dplyr::mutate(fill_colour = purrr::map2_chr(field, value, get_fill_colour))
      d2 <- d$schema$schema |>
        dplyr::bind_rows(
          tibble::tibble(
            field = "gender",
            type = "c",
            description = "gender according to AMBER/COBALT"
          )
        )
      d3 <- dplyr::left_join(d1, d2, by = "field") |>
        dplyr::select("field", "value", "fill_colour", "description")
      down <- funcs$down_button(d3, "purple_qc")
      tab <- d3 |>
        gt::gt(rowname_col = "field") |>
        gt::cols_label(value = "Value", description = "Description") |>
        gt::cols_hide(columns = c("fill_colour", "description")) |>
        gt::tab_style(
          style = gt::cell_fill(color = gt::from_column("fill_colour")),
          locations = gt::cells_body(columns = value)
        ) |>
        gt::fmt(
          columns = field,
          fns = function(x) {
            desc <- d3$description[match(x, d3$field)]
            sprintf(
              '<span title="%s" style="cursor: help; border-bottom: 1px dotted #999;">%s</span>',
              desc,
              x
            )
          }
        ) |>
        gt::tab_style(
          style = list(gt::cell_text(align = "left")),
          locations = gt::cells_stub(rows = TRUE)
        ) |>
        gt::tab_style(
          style = list(gt::cell_text(weight = "bold")),
          locations = list(gt::cells_stub(rows = TRUE), gt::cells_body(columns = value))
        ) |>
        gt::cols_align("left") |>
        gt::tab_options(
          table.width = gt::px(700),
          table.align = "left",
          column_labels.font.weight = "bold"
        ) |>
        gt::tab_source_note(down)
      return(tab)
    }
  ),
  #----------#
  get_data = function() {
    readRDS(here("inst/website/nogit/seqc100/data.rds"))
  },
  #----------#
  cat_plot = function(p, x, group = "gallery1") {
    dat <- p |>
      dplyr::filter(.data$alias == x) |>
      dplyr::mutate(
        md = glue::glue(
          "![<<.data$title>>](<<.data$path>>)",
          "{group='<<group>>' ",
          "description='<<.data$description>>' ",
          # "height=<<height>>",
          "}\n\n\n",
          .open = "<<",
          .close = ">>"
        )
      )
    stopifnot(nrow(dat) == 1)
    cat(dat$md)
  },
  #----------#
  unnest_data = function(d, x, schemas_all) {
    tp <- list(
      tp = x,
      t = strsplit(x, "_")[[1]][1],
      p = strsplit(x, "_")[[1]][2]
    )
    res <- d |>
      dplyr::filter(tool_parser == tp$tp) |>
      dplyr::select("tidy") |>
      tidyr::unnest("tidy") |>
      dplyr::select("data") |>
      _$data[[1]]
    version <- nemo::get_tbl_version_attr(res)
    schema <- funcs$get_schema(x = schemas_all, tl = tp$t, nm = tp$p, v = version)
    list(res = res, schema = schema)
  },
  #----------#
  get_schema = function(x, tl, nm, v) {
    dat <- x |>
      dplyr::filter(.data$tool == tl, .data$name == nm, version == v, tbl == "tbl1") |>
      dplyr::select("tbl_description", "schema")
    descr <- dat$tbl_description
    list(schema = dat$schema[[1]], description = descr)
  },
  #----------#
  down_button = function(d, nm) {
    downloadthis::download_this(
      .data = d,
      output_name = nm,
      output_extension = ".csv",
      button_label = "CSV Download",
      button_type = "primary"
    )
  }
)

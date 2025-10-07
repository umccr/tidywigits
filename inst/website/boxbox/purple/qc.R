box::use(wigits/utils, wigits/table)

#' @export
gt_tab <- function(d, schemas_all) {
  cols_sel <- c(
    "qc_status",
    "gender",
    "purity",
    "contamination",
    "tinc_level",
    "loh_percent",
    "chimerism_percent",
    "method",
    "germline_aberrations",
    "deleted_genes",
    "cn_segments",
    "cn_segments_unsupported",
    "foobar"
  )
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
    dplyr::select(
      dplyr::any_of(cols_sel),
      dplyr::everything()
    ) |>
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
  thresh <- tibble::tribble(
        ~field, ~threshold,
        "qc_status", "Green: PASS; Orange: WARN; Red: FAIL",
        "method", "Green: NORMAL; Orange: HIGHLY_DIPLOID or SOMATIC; Red: NO_TUMOR",
        "cn_segments", "No colour thresholds",
        "cn_segments_unsupported", "Green: 0; Orange: 1-10; Red: >10",
        "purity", "Green: 0.8-1.0; Orange: 0.25-0.80; Red: 0-0.25",
        "gender", "Green: matching values; Red: mismatched values",
        "deleted_genes", "Green: 0-99; Orange: 100-199; Red: >=200",
        "contamination", "Green: 0; Red: >0",
        "germline_aberrations", "Green: NONE; Red: any aberration detected",
        "mean_depth_amber", "Green: 25-150; Orange: >150; Red: 0-25",
        "loh_percent", "Green: 0-0.5; Orange: 0.5-0.8; Red: >0.8",
        "tinc_level", "Green: 0; Red: >0",
        "chimerism_percent", "Green: 0; Red: >0"
      )
  d3 <- dplyr::left_join(d1, d2, by = "field") |>
    dplyr::select("field", "value", "fill_colour", "description") |>
    dplyr::left_join(thresh, by = "field") |>
    tidyr::unite("description", c("description", "threshold"), sep = "\n")
  down <- table$down_button(d3, "purple_qc")
  tab <- d3 |>
    gt::gt() |>
    gt::cols_label(value = "Value", description = "Description") |>
    # not needed
    gt::cols_hide(columns = c("fill_colour", "description")) |>
    # value colour fill
    gt::tab_style(
      style = gt::cell_fill(color = gt::from_column("fill_colour")),
      locations = gt::cells_body(columns = value)
    ) |>
    # field name with hover description
    gt::fmt(
      columns = field,
      fns = function(x) {
        desc <- d3$description[match(x, d3$field)]
        sprintf(
          '<span title="%s" style="cursor: help;">%s</span>',
          desc,
          x
        )
      }
    ) |>
    # bold field and value text
    gt::tab_style(
      style = list(gt::cell_text(weight = "bold")),
      locations = list(gt::cells_body(columns = c("field", "value")))
    ) |>
    gt::cols_align("left") |>
    gt::tab_options(
      table.width = gt::px(700),
      table.align = "left",
      column_labels.hidden = TRUE
    ) |>
    gt::tab_source_note(down)
  return(tab)
}


#' @export
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

    field == "cn_segments" & num_val > 0 ~ green,
    field == "cn_segments" ~ red,

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

    .default = "white"
  )
  return(colour)
}

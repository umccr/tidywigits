funcs <- list(
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
  }
)

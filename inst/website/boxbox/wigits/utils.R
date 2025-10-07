#' @export
unnest_data <- function(d, tool_parser, schemas_all) {
  tp <- list(
    tp = tool_parser,
    t = strsplit(tool_parser, "_")[[1]][1],
    p = strsplit(tool_parser, "_")[[1]][2]
  )
  res <- d |>
    dplyr::filter(tool_parser == tp$tp) |>
    dplyr::select("tidy") |>
    tidyr::unnest("tidy") |>
    dplyr::select("data") |>
    _$data[[1]]
  version <- nemo::get_tbl_version_attr(res)
  schema <- get_schema(x = schemas_all, tl = tp$t, nm = tp$p, v = version)
  list(res = res, schema = schema)
}

#' @export
get_schema <- function(x, tl, nm, v) {
  dat <- x |>
    dplyr::filter(.data$tool == tl, .data$name == nm, version == v, tbl == "tbl1") |>
    dplyr::select("tbl_description", "schema")
  descr <- dat$tbl_description
  list(schema = dat$schema[[1]], description = descr)
}

#' @export
get_data = function() {
  # TODO: replace with actual data loading code
  readRDS(here::here("inst/website/nogit/seqc100/data.rds"))
}

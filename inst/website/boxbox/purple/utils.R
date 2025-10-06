#' @export
unnest_data_drivercatalog <- function(d, schemas_all, get_germline = FALSE) {
  box::use(wigits/utils[get_schema])
  x <- "purple_drivercatalog"
  tp <- list(
    tp = x,
    t = strsplit(x, "_")[[1]][1],
    p = strsplit(x, "_")[[1]][2]
  )
  res <- d |>
    dplyr::filter(tool_parser == tp$tp) |>
    dplyr::select("tidy", "bname") |>
    dplyr::mutate(germline_file = ifelse(grepl("germline\\.tsv", bname), TRUE, FALSE)) |>
    tidyr::unnest("tidy") |>
    dplyr::select("data", "germline_file")
  version <- nemo::get_tbl_version_attr(res[["data"]][[1]])
  schema <- get_schema(x = schemas_all, tl = tp$t, nm = tp$p, v = version)
  res <- res |>
    dplyr::filter(.data$germline_file == get_germline) |>
    dplyr::select(-"germline_file") |>
    tidyr::unnest("data")

  list(res = res, schema = schema)
}

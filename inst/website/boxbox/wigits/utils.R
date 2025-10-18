#' @export
unnest_data_multi <- function(d, tool_parser, schemas_all, subnest = NULL, tbl = "tbl1") {
  box::use(./utils[get_schema])
  tp <- list(
    tp = tool_parser,
    t = strsplit(tool_parser, "_")[[1]][1],
    p = strsplit(tool_parser, "_")[[1]][2]
  )
  res <- d |>
    dplyr::filter(tool_parser == tp$tp) |>
    dplyr::select("prefix", "tidy") |>
    tidyr::unnest("tidy", names_sep = "_")
  if (!is.null(subnest)) {
    stopifnot(subnest %in% res$tidy_name)
    res <- res |>
      dplyr::filter(.data$tidy_name == subnest) |>
      dplyr::select("prefix", "tidy_data")
  }
  version <- nemo::get_tbl_version_attr(res[["tidy_data"]][[1]])
  res <- res |> tidyr::unnest("tidy_data")
  schema <- get_schema(x = schemas_all, tl = tp$t, nm = tp$p, v = version, tb = tbl)
  list(res = res, schema = schema)
}

#' @export
unnest_data <- function(d, tool_parser, schemas_all, tbl = "tbl1") {
  box::use(./utils[get_schema])
  tp <- list(
    tp = tool_parser,
    t = strsplit(tool_parser, "_")[[1]][1],
    p = strsplit(tool_parser, "_")[[1]][2]
  )
  res <- d |>
    dplyr::filter(tool_parser == tp$tp) |>
    dplyr::select("tidy") |>
    tidyr::unnest("tidy") |>
    dplyr::select("data")
  version <- nemo::get_tbl_version_attr(res[["data"]][[1]])
  res <- res |> tidyr::unnest("data")
  schema <- get_schema(x = schemas_all, tl = tp$t, nm = tp$p, v = version, tb = tbl)
  list(res = res, schema = schema)
}

#' @export
get_schema <- function(x, tl, nm, v, tb = "tbl1") {
  dat <- x |>
    dplyr::filter(.data$tool == tl, .data$name == nm, .data$version == v, .data$tbl == tb) |>
    dplyr::select("tbl_description", "schema")
  descr <- dat$tbl_description
  list(schema = dat$schema[[1]], description = descr)
}

#' @export
get_data = function() {
  # TODO: replace with actual data loading code
  readRDS(here::here("inst/website/nogit/seqc100/data.rds"))
}

#' Parse file
#'
#' @description
#' Parses files.
#'
#' @param fname (`character(1)`)\cr
#' File name.
#' @param schema (`tibble()`)\cr
#' Tibble with field and type.
#' @param type (`character(1)`)\cr
#' File type (tsv, csv, vcf, tsv-nohead).
#'
#' @examples
#' \dontrun{
#' name <- "amber"
#' outdir <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/amber"
#' )
#' prefix <- NULL
#' x <- Tool$new(name, outdir, prefix)
#' schemas_all <- x$config$schemas_all
#' files_all <- x$files
#' ftype <- "baftsv"
#' fname <-
#'   files_all |>
#'   dplyr::filter(.data$parser == ftype) |>
#'   dplyr::pull("path")
#' schema <-
#'   schemas_all |>
#'   dplyr::filter(.data$file == ftype) |>
#'   dplyr::select("schema") |>
#'   tidyr::unnest("schema")
#' type <- "tsv"
#' type <- "tsv-nohead"
#'
#' }
parse_file <- function(fname, schema, type) {
  assertthat::assert_that(file.exists(fname))
  assertthat::assert_that(
    tibble::is_tibble(schema),
    all(colnames(schema) == c("field", "type"))
  )
  assertthat::assert_that(type %in% c("tsv", "csv", "vcf", "tsv-nohead"))
  # remap schema
  schema2 <- schema |>
    dplyr::mutate(
      type = dplyr::case_match(
        .data$type,
        "char" ~ "c",
        "int" ~ "i",
        "float" ~ "d"
      )
    ) |>
    tibble::deframe()
  delim <- "\t"
  col_names <- TRUE
  col_types <- rlang::exec(readr::cols, !!!schema2)
  if (type == "csv") {
    delim <- ","
  }
  if (type == "tsv-nohead") {
    col_names_new <- names(schema2)
    col_types <- unname(schema2)
    d <- readr::read_tsv(
      file = fname,
      col_names = FALSE,
      col_types = col_types
    ) |>
      purrr::set_names(col_names_new)
    return(d[])
  }
  d <- readr::read_delim(
    file = fname,
    delim = delim,
    col_names = col_names,
    col_types = col_types
  )
  return(d[])
}

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
#' @param cnames Column names (see `readr::read_delim`).
#' @param ... Passed on to `readr::read_delim`.
#'
#' @examples
#' \dontrun{
#' name <- "amber"
#' outdir <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/amber"
#' )
#' prefix <- NULL
#' x <- Tool$new(name, outdir, prefix)
#' schemas_all <- x$config$raw_schemas_all
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
parse_file <- function(fname, schema, type, cnames = TRUE, ...) {
  assertthat::assert_that(file.exists(fname))
  assertthat::assert_that(
    tibble::is_tibble(schema),
    all(colnames(schema) == c("field", "type"))
  )
  assertthat::assert_that(
    type %in% c("tsv", "csv", "vcf", "txt-nohead", "txt", "tsv-onlycols")
  )
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
  col_names <- cnames
  col_types <- rlang::exec(readr::cols, !!!schema2)
  if (type == "csv") {
    delim <- ","
  }
  if (type == "txt-nohead") {
    col_names_new <- names(schema2)
    col_types <- unname(schema2)
    d <- readr::read_delim(
      file = fname,
      col_names = FALSE,
      col_types = col_types,
      ...
    ) |>
      purrr::set_names(col_names_new)
    return(d[])
  }
  if (type == "tsv-onlycols") {
    ctypes <- rlang::exec(readr::cols_only, !!!schema2)
    d <- readr::read_tsv(
      file = fname,
      col_names = TRUE,
      col_types = ctypes
    )
    return(d[])
  }
  d <- readr::read_delim(
    file = fname,
    delim = delim,
    col_names = col_names,
    col_types = col_types,
    ...
  )
  return(d[])
}

file_hdr <- function(x, delim = "\t") {
  readr::read_delim(
    x,
    delim = delim,
    col_types = readr::cols(.default = "c"),
    n_max = 0
  ) |>
    colnames()
}

schema_guess <- function(cnames, schemas_all) {
  assertthat::assert_that(rlang::is_bare_character(cnames))
  assertthat::assert_that(tibble::is_tibble(schemas_all))
  assertthat::assert_that(all(
    c("schema", "version") %in% colnames(schemas_all)
  ))
  schema1 <- schemas_all |>
    dplyr::select("version", "schema") |>
    dplyr::rowwise() |>
    dplyr::mutate(
      length_match = length(cnames) == nrow(.data$schema),
      all_match = if (.data$length_match) {
        all(cnames == .data$schema[["field"]])
      } else {
        FALSE
      }
    ) |>
    dplyr::filter(.data$all_match) |>
    dplyr::ungroup()
  assertthat::assert_that(nrow(schema1) == 1)
  version <- schema1$version
  schema2 <- schema1 |>
    dplyr::select("schema") |>
    tidyr::unnest("schema")
  list(schema = schema2, version = version)
}

#' List Files
#'
#' Lists files in a given directory.
#'
#' @param d Path to directory.
#' @param max_files Max files returned.
#'
#' @return A tibble with file basename, size, last modification timestamp
#' and full path.
#' @examples
#' d <- system.file("R", package = "tidywigits")
#' x <- list_files_dir(d)
#' @testexamples
#' expect_equal(names(x), c("bname", "size", "lastmodified", "path"))
#' @export
list_files_dir <- function(d, max_files = NULL) {
  d <- fs::dir_info(path = d, recurse = TRUE, type = "file") |>
    dplyr::mutate(
      bname = basename(.data$path),
      lastmodified = .data$modification_time
    ) |>
    dplyr::select("bname", "size", "lastmodified", "path")
  if (!is.null(max_files)) {
    d <- d |>
      dplyr::slice_head(n = max_files)
  }
  d
}

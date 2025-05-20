#' Parse file
#'
#' @description
#' Parses files.
#'
#' @param fpath (`character(1)`)\cr
#' File path.
#' @param pname (`character(1)`)\cr
#' Parser name (e.g. "breakends" - see docs).
#' @param schemas_all (`tibble()`)\cr
#' Tibble with name, version and schema list-col.
#' @param delim (`character(1)`)\cr
#' File delimiter.
#' @param ... Passed on to `readr::read_delim`.
#'
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/bamtools"
#' )
#' x <- Tool$new("bamtools", path)
#' schemas_all <- x$raw_schemas_all
#' pname <- "wgsmetrics"
#' fpath <- file.path(path, "L2500331.wgsmetrics")
#' parse_file(fpath, pname, schemas_all)
#' }
parse_file <- function(
  fpath,
  pname,
  schemas_all,
  delim = "\t",
  ...
) {
  assertthat::assert_that(
    file.exists(fpath),
    msg = glue("The file {fpath} does not exist.")
  )
  cnames <- file_hdr(fpath, delim = delim, ...)
  schema <- schema_guess(
    pname = pname,
    cnames = cnames,
    schemas_all = schemas_all
  )
  # remap schema
  schema[["schema"]] <- schema[["schema"]] |>
    dplyr::mutate(
      type = dplyr::case_match(
        .data$type,
        "char" ~ "c",
        "int" ~ "i",
        "float" ~ "d"
      )
    ) |>
    tibble::deframe()
  ctypes <- rlang::exec(readr::cols, !!!schema[["schema"]])
  d <- readr::read_delim(
    file = fpath,
    delim = delim,
    col_types = ctypes,
    ...
  )
  attr(d, "file_version") <- schema[["version"]]
  d[]
}

parse_file_nohead <- function(fpath, ctypes, cnames_new, ...) {
  d <- readr::read_delim(
    file = fpath,
    col_names = FALSE,
    col_types = ctypes,
    ...
  )
  assertthat::assert_that(length(cnames_new) == ncol(d))
  colnames(d) <- cnames_new
  d[]
}

file_hdr <- function(x, delim = "\t", n_max = 0, ...) {
  readr::read_delim(
    x,
    delim = delim,
    col_types = readr::cols(.default = "c"),
    n_max = n_max,
    ...
  ) |>
    colnames()
}

#' Guess Schema
#'
#' @description
#' Given a tibble of available schemas, filters to the one
#' matching the given column names. Errors out if unsuccessful.
#'
#' @param pname (`character(1)`)\cr
#' Parser name.
#' @param cnames (`character(n)`)\cr
#' Column names.
#' @param schemas_all (`tibble()`)\cr
#' Tibble with name, version and schema list-col.
#'
#' @examples
#' \dontrun{
#' x <- here::here(
#'   "nogit/oa_v1/linx/somatic_annotations/L2500331.linx.vis_copy_number.tsv"
#' )
#' pname <- "viscn"
#' cnames <- file_hdr(x)
#' conf <- Config$new("linx")
#' schemas_all <- conf$.raw_schemas_all()
#' schema_guess(pname, cnames, schemas_all)
#' }
schema_guess <- function(pname, cnames, schemas_all) {
  assertthat::assert_that(
    rlang::is_bare_character(cnames),
    tibble::is_tibble(schemas_all),
    all(c("name", "version", "schema") %in% colnames(schemas_all)),
    pname %in% schemas_all[["name"]]
  )
  s <- schemas_all |>
    dplyr::filter(.data$name == pname) |>
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
  msg <- glue("There were {nrow(s)} matching schemas.")
  assertthat::assert_that(nrow(s) == 1, msg = msg)
  version <- s$version
  schema <- s |>
    dplyr::select("schema") |>
    tidyr::unnest("schema")
  list(schema = schema, version = version)
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

get_tbl_version_attr <- function(tbl, x = "file_version") {
  attr(tbl, x)
}

parse_wigits_version_file <- function(x) {
  parse_file_nohead(
    x,
    ctypes = "cc",
    cnames_new = c("name", "value"),
    delim = "="
  )
}

tidy_wigits_version_file <- function(x) {
  d <- parse_wigits_version_file(x) |>
    tidyr::pivot_wider(names_from = "name", values_from = "value") |>
    purrr::set_names(c("version", "build_date"))
  list(version = d) |>
    tibble::enframe(value = "data")
}

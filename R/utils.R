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
#'   "nogit/oa_v1/bamtools"
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
  cnames <- file_hdr(fpath, delim = delim, ...)
  schema <- schema_guess(
    pname = pname,
    cnames = cnames,
    schemas_all = schemas_all
  )
  schema[["schema"]] <- schema[["schema"]] |>
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

parse_file_nohead <- function(fpath, schema, delim = "\t", ...) {
  assertthat::assert_that(
    nrow(schema) == 1,
    identical(sapply(schema, class), c(version = "character", schema = "list"))
  )
  version <- schema[["version"]]
  schema <- schema[["schema"]][[1]] |>
    tibble::deframe()
  # check if number of cols is as expected
  ncols <- file_hdr(fpath, delim = delim, ...) |> length()
  assertthat::assert_that(length(schema) == ncols)
  ctypes <- paste0(schema, collapse = "")
  d <- readr::read_delim(
    file = fpath,
    col_names = FALSE,
    col_types = ctypes,
    delim = delim,
    ...
  )
  colnames(d) <- names(schema)
  attr(d, "file_version") <- version
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
        identical(cnames, .data$schema[["field"]])
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
#' Lists files inside a given directory.
#'
#' @param d Directory path.
#' @param max_files Max files returned.
#' @param type File type(s) to return (e.g. any, file, directory, symlink). See
#' `fs::dir_info`.
#'
#' @return A tibble with file basename, size, last modification timestamp
#' and full path.
#' @examples
#' d <- system.file("R", package = "tidywigits")
#' x <- list_files_dir(d)
#' @testexamples
#' expect_equal(names(x), c("bname", "size", "lastmodified", "path"))
#' @export
list_files_dir <- function(d, max_files = NULL, type = "file") {
  d <- fs::dir_info(path = d, recurse = TRUE, type = type) |>
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
  assertthat::assert_that(
    assertthat::has_attr(tbl, x),
    msg = paste("The table does not have the required attribute:", x)
  )
  attr(tbl, x)
}

set_tbl_version_attr <- function(tbl, v, x = "file_version") {
  attr(tbl, x) <- v
  tbl
}

#' Create Empty Tibble
#'
#' From https://stackoverflow.com/a/62535671/2169986. Useful for handling
#' edge cases with empty data. e.g. virusbreakend.vcf.summary.tsv
#'
#' @param ctypes Character vector of column types corresponding to `cnames`.
#' @param cnames Character vector of column names to use.
#'
#' @return A tibble with 0 rows and the given column names.
#' @export
empty_tbl <- function(cnames, ctypes = readr::cols(.default = "c")) {
  d <- readr::read_csv("\n", col_names = cnames, col_types = ctypes)
  d[]
}

is_files_tbl <- function(x) {
  assertthat::assert_that(
    tibble::is_tibble(x),
    identical(colnames(x), c("bname", "size", "lastmodified", "path"))
  )
}

schema_type_remap <- function(x) {
  type_map <- c(char = "c", float = "d", int = "i")
  assertthat::assert_that(x %in% names(type_map))
  unname(type_map[x])
}

enframe_data <- function(x) {
  tibble::enframe(x, value = "data")
}

#' Write tibble
#'
#' @description
#' Writes tibbles in the given format(s).
#'
#' @param d (`tibble()`)\cr
#' A tibble (or data.frame) with tidy data.
#' @param pref (`character(1)`)\cr
#' File prefix. The file extension gets generated automatically via the `fmt`
#' argument.
#' @param fmt (`character(1)`)\cr
#' Output format. One of tsv, csv, parquet, rds, or db.
#' @param id  (`character(1)`)\cr
#' ID to use in the first `nemo_id` column for this table.
#' @param dbconn (`DBIConnection(1)`)\cr
#' Database connection object (see `DBI::dbConnect`).
#' @examples
#' d <- tibble::tibble(name = "foo", data = 123)
#' pref <- file.path(tempdir(), "data_test1")
#' fmt <- "csv"
#' id <- "run1"
#' nemo_write(d = d, pref = pref, fmt = "csv", id = id)
#' @export
nemo_write <- function(d, pref = NULL, fmt = "tsv", id = NULL, dbconn = NULL) {
  assertthat::assert_that(!is.null(id), !is.null(pref))
  assertthat::assert_that(is.data.frame(d))
  valid_out_fmt(fmt)
  pref <- as.character(pref)
  d <- d |>
    tibble::add_column(nemo_id = as.character(id), .before = 1)
  if (fmt == "db") {
    assertthat::assert_that(!is.null(dbconn), msg = "Valid db conn needed")
    assertthat::assert_that(!grepl("/", pref)) # dir path wasn't used accidentally
    DBI::dbWriteTable(
      conn = dbconn,
      name = pref,
      value = d,
      append = TRUE,
      overwrite = FALSE
    )
  } else {
    sfx <- c(tsv = "tsv.gz", csv = "csv.gz", parquet = "parquet", rds = "rds")
    osfx <- function(s) glue("{pref}.{sfx[s]}")
    fs::dir_create(dirname(pref))
    if (fmt == "tsv") {
      readr::write_tsv(d, osfx("tsv"))
    } else if (fmt == "csv") {
      readr::write_csv(d, osfx("csv"))
    } else if (fmt == "parquet") {
      arrow::write_parquet(d, osfx("parquet"))
    } else if (fmt == "rds") {
      readr::write_rds(d, osfx("rds"))
    } else {
      stop("No where else to go, check your output format!")
    }
  }
  # also gets returned in case of NULL fmt
  return(invisible(d))
}

#' Output Format is Valid
#'
#' Checks that the specified output format is valid.
#' @param x Output format.
#' @examples
#' valid_out_fmt("tsv")
#' @testexamples
#' expect_true(valid_out_fmt("tsv"))
#' expect_error(valid_out_fmt("foo"))
#' expect_error(valid_out_fmt(c("tsv", "csv")))
#' @export
valid_out_fmt <- function(x) {
  format_choices <- c("tsv", "csv", "parquet", "rds", "db")
  y <- glue::glue_collapse(format_choices, sep = ", ", last = " or ")
  assertthat::assert_that(
    is.null(x) | (length(x) == 1 && x %in% format_choices),
    msg = glue("Output format should be one of {y}, _or_ NULL.")
  )
}

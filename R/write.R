#' Write data
#'
#' @description
#' Writes tabular data in the given format.
#'
#' @param d (`data.frame()`)\cr
#' A data.frame (or tibble) with tidy data.
#' @param fpfix (`character(1)`)\cr
#' File prefix. The file extension is generated automatically via the `format`
#' argument. For a format of db, this is inserted into the `nemo_pfix` column.
#' @param format (`character(1)`)\cr
#' Output format. One of tsv, csv, parquet, rds, or db.
#' @param id (`character(1)`)\cr
#' ID to use in the first `nemo_id` column for this table.
#' @param dbconn (`DBIConnection(1)`)\cr
#' Database connection object (see `DBI::dbConnect`). Used only when format is db.
#' @param dbtab (`character(1)`)\cr
#' Database table name (see `DBI::dbWriteTable`). Used only when format is db.
#'
#' @examples
#' d <- tibble::tibble(name = "foo", data = 123)
#' fpfix <- file.path(tempdir(), "data_test1")
#' format <- "csv"
#' id <- "run1"
#' nemo_write(d = d, fpfix = fpfix, format = format, id = id)
#' readr::read_csv(glue::glue("{fpfix}.csv.gz"))
#' @examplesIf RPostgres::postgresHasDefault()
#' # for database writing
#' con <- DBI::dbConnect(RPostgres::Postgres())
#' tbl_nm <- "awesome_tbl"
#' nemo_write(d = d, fpfix = basename(fpfix), format = "db", id = "123", dbconn = con, dbtab = tbl_nm)
#' DBI::dbListTables(con)
#' DBI::dbReadTable(con, tbl_nm)
#' DBI::dbDisconnect(con)
#' @export
nemo_write <- function(d, fpfix = NULL, format = "tsv", id = NULL, dbconn = NULL, dbtab = NULL) {
  assertthat::assert_that(!is.null(id), !is.null(fpfix))
  assertthat::assert_that(is.data.frame(d))
  valid_out_fmt(format)
  fpfix <- as.character(fpfix)
  d <- d |>
    tibble::add_column(nemo_id = as.character(id), .before = 1)
  if (format == "db") {
    assertthat::assert_that(!is.null(dbconn), msg = "Valid db conn needed")
    assertthat::assert_that(!is.null(dbtab), msg = "Valid db tab name needed")
    assertthat::assert_that(!grepl("/", fpfix)) # avoid accidental dir path
    d <- d |>
      tibble::add_column(nemo_pfix = as.character(fpfix), .after = 1)
    DBI::dbWriteTable(
      conn = dbconn,
      name = dbtab,
      value = d,
      append = TRUE,
      overwrite = FALSE
    )
  } else {
    sfx <- c(tsv = "tsv.gz", csv = "csv.gz", parquet = "parquet", rds = "rds")
    osfx <- function(s) glue("{fpfix}.{sfx[s]}")
    fs::dir_create(dirname(fpfix))
    if (format == "tsv") {
      readr::write_tsv(d, osfx("tsv"))
    } else if (format == "csv") {
      readr::write_csv(d, osfx("csv"))
    } else if (format == "parquet") {
      arrow::write_parquet(d, osfx("parquet"))
    } else if (format == "rds") {
      readr::write_rds(d, osfx("rds"))
    } else {
      stop("No where else to go, check your output format!")
    }
  }
  # also gets returned in case of NULLformat
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

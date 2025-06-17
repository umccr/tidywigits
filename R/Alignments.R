#' @title Alignments Object
#'
#' @description
#' Alignments file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oa_v2"
#' )
#' a <- Alignments$new(path)
#' a$nemofy(
#'     odir = "nogit/test_data",
#'     format = "parquet",
#'     id = "run1",
#'     include = NULL,
#'     exclude = NULL
#' )
#' }
#' @export
Alignments <- R6::R6Class(
  "Alignments",
  inherit = Tool,
  public = list(
    #' @description Create a new Alignments object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "alignments", path = path, files_tbl = files_tbl)
    },
    #' @description Read `duplicate_freq.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_dupfreq = function(x) {
      self$.parse_file(x, "dupfreq")
    },
    #' @description Tidy `duplicate_freq.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_dupfreq = function(x) {
      self$.tidy_file(x, "dupfreq")
    },
    #' @description Read `md.metrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_markdup = function(x) {
      # handle two different sections
      schema <- self$get_raw_schema("markdup")
      # first make sure colnames are as expected
      hdr1 <- file_hdr(x, comment = "#")
      hdr2 <- file_hdr(x, comment = "#", skip = 10)
      schema_splitter <- which(schema$field == "SPLIT_HERE")
      assertthat::assert_that(schema_splitter == 11)
      s1 <- dplyr::slice(schema, 1:(schema_splitter - 1))
      s2 <- dplyr::slice(schema, (schema_splitter + 1):nrow(schema))
      assertthat::assert_that(identical(hdr1, s1[["field"]]))
      assertthat::assert_that(identical(hdr2, s2[["field"]]))
      # just hard-code the classes in this case, pretty straightforward
      d1 <- readr::read_tsv(
        x,
        comment = "#",
        n_max = 1,
        col_types = readr::cols(.default = "d", LIBRARY = "c")
      ) |>
        set_tbl_version_attr("latest")
      d2 <- readr::read_tsv(
        x,
        col_types = readr::cols(.default = "d"),
        comment = "#",
        skip = 10
      ) |>
        set_tbl_version_attr("latest")
      list(metrics = d1[], histo = d2[]) |>
        enframe_data()
    },
    #' @description Tidy `md.metrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_markdup = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_markdup(x)
      }
      d <- x |> tibble::deframe()
      schema <- self$get_tidy_schema("markdup")
      schema_splitter <- which(schema$field == "SPLIT_HERE")
      s1 <- dplyr::slice(schema, 1:(schema_splitter - 1))
      s2 <- dplyr::slice(schema, (schema_splitter + 1):nrow(schema))
      colnames(d[["metrics"]]) <- s1[["field"]]
      colnames(d[["histo"]]) <- s2[["field"]]
      enframe_data(d)
    }
  )
)

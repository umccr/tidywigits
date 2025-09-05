#' @title Sigs Object
#'
#' @description
#' Sigs file parsing and manipulation.
#' @examples
#' cls <- Sigs
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "sigs_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "sigs.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' @export
Sigs <- R6::R6Class(
  "Sigs",
  inherit = Tool,
  public = list(
    #' @description Create a new Sigs object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "sigs", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `allocation.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_allocation = function(x) {
      self$.parse_file(x, "allocation")
    },
    #' @description Tidy `allocation.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_allocation = function(x) {
      self$.tidy_file(x, "allocation")
    },
    #' @description Read `snv_counts.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_snvcounts = function(x) {
      self$.parse_file_nohead(x, "snvcounts", delim = ",", skip = 1)
    },
    #' @description Tidy `snv_counts.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_snvcounts = function(x) {
      self$.tidy_file(x, "snvcounts")
    }
  )
)

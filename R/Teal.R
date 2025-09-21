#' @title Teal Object
#'
#' @description
#' Teal file parsing and manipulation.
#' @examples
#' cls <- Teal
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "teal_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "teal.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' @export
Teal <- R6::R6Class(
  "Teal",
  inherit = Tool,
  public = list(
    #' @description Create a new Teal object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "teal", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_breakend = function(x) {
      self$.parse_file(x, "breakend")
    },
    #' @description Tidy `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_breakend = function(x) {
      self$.tidy_file(x, "breakend")
    },
    #' @description Read `tellength.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_tellength = function(x) {
      self$.parse_file(x, "tellength")
    },
    #' @description Tidy `tellength.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_tellength = function(x) {
      self$.tidy_file(x, "tellength")
    }
  )
)

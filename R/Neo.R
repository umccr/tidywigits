#' @title Neo Object
#'
#' @description
#' Neo file parsing and manipulation.
#' @examples
#' cls <- Neo
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "neo_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "neo.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' @export
Neo <- R6::R6Class(
  "Neo",
  inherit = Tool,
  public = list(
    #' @description Create a new Neo object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "neo", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `neo_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_candidates = function(x) {
      self$.parse_file(x, "candidates")
    },
    #' @description Tidy `neo_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_candidates = function(x) {
      self$.tidy_file(x, "candidates")
    },
    #' @description Read `neoepitope.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_predictions = function(x) {
      self$.parse_file(x, "predictions")
    },
    #' @description Tidy `neoepitope.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_predictions = function(x) {
      self$.tidy_file(x, "predictions")
    }
  )
)

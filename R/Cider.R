#' @title Cider Object
#'
#' @description
#' Cider file parsing and manipulation.
#' @examples
#' cls <- Cider
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "cider_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "cider.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 3)
#' @export
Cider <- R6::R6Class(
  "Cider",
  inherit = Tool,
  public = list(
    #' @description Create a new Cider object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cider", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `blastn_match.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_blastn = function(x) {
      self$.parse_file(x, "blastn")
    },
    #' @description Tidy `blastn_match.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_blastn = function(x) {
      self$.tidy_file(x, "blastn")
    },
    #' @description Read `locus_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_locstats = function(x) {
      self$.parse_file(x, "locstats")
    },
    #' @description Tidy `locus_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_locstats = function(x) {
      self$.tidy_file(x, "locstats")
    },
    #' @description Read `vdj.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_vdj = function(x) {
      self$.parse_file(x, "vdj")
    },
    #' @description Tidy `vdj.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_vdj = function(x) {
      self$.tidy_file(x, "vdj")
    }
  )
)

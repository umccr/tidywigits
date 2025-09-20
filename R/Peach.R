#' @title Peach Object
#'
#' @description
#' Peach file parsing and manipulation.
#' @examples
#' cls <- Peach
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "peach_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "peach.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 5)
#' @export
Peach <- R6::R6Class(
  "Peach",
  inherit = Tool,
  public = list(
    #' @description Create a new Peach object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "peach", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `events.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_events = function(x) {
      self$.parse_file(x, "events")
    },
    #' @description Tidy `events.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_events = function(x) {
      self$.tidy_file(x, "events")
    },
    #' @description Read `gene.events.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_eventsg = function(x) {
      self$.parse_file(x, "eventsg")
    },
    #' @description Tidy `gene.events.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_eventsg = function(x) {
      self$.tidy_file(x, "eventsg")
    },
    #' @description Read `haplotypes.all.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_hapall = function(x) {
      self$.parse_file(x, "hapall")
    },
    #' @description Tidy `haplotypes.all.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_hapall = function(x) {
      self$.tidy_file(x, "hapall")
    },
    #' @description Read `haplotypes.best.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_hapbest = function(x) {
      self$.parse_file(x, "hapbest")
    },
    #' @description Tidy `haplotypes.best.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_hapbest = function(x) {
      self$.tidy_file(x, "hapbest")
    },
    #' @description Read `qc.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      self$.parse_file(x, "qc")
    },
    #' @description Tidy `qc.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      self$.tidy_file(x, "qc")
    }
  )
)

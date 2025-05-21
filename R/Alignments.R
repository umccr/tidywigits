#' @title Alignments Object
#'
#' @description
#' Alignments file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oa_v1/alignments"
#' )
#' a <- Alignments$new(path)
#' }
#' @export
Alignments <- R6::R6Class(
  "Alignments",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Alignments object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "alignments", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self)
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
    }
  )
)

#' @title Lilac Object
#'
#' @description
#' Lilac file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' l <- Lilac$new(path)
#' }
#' @export
Lilac <- R6::R6Class(
  "Lilac",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Lilac object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "lilac", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `lilac.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      self$.parse_file(x, "summary")
    },
    #' @description Tidy `lilac.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      self$.tidy_file(x, "summary")
    },
    #' @description Read `lilac.qc.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      self$.parse_file(x, "qc")
    },
    #' @description Tidy `lilac.qc.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      self$.tidy_file(x, "qc")
    }
  )
)

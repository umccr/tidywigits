#' @title Sage Object
#'
#' @description
#' Sage file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oa_v1"
#' )
#' s <- Sage$new(path)
#' s$tidy
#' s$tidy$tidy |>
#'   purrr::set_names(s$tidy$parser) |>
#'   purrr::map(\(x) x[["data"]][[1]])
#'
#' }
#' @export
Sage <- R6::R6Class(
  "Sage",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Sage object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "sage", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `bqr.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_bqrtsv = function(x) {
      self$.parse_file(x, "bqrtsv")
    },
    #' @description Tidy `bqr.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_bqrtsv = function(x) {
      self$.tidy_file(x, "bqrtsv")
    },
    #' @description Read `gene.coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_genecvg = function(x) {
      self$.parse_file(x, "genecvg")
    },
    #' @description Tidy `gene.coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecvg = function(x) {
      self$.tidy_file(x, "genecvg")
    },
    #' @description Read `exon.medians.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_exoncvg = function(x) {
      self$.parse_file(x, "exoncvg")
    },
    #' @description Tidy `exon.medians.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_exoncvg = function(x) {
      self$.tidy_file(x, "exoncvg")
    }
  )
)

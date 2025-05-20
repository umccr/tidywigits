#' @title Virusinterpreter Object
#'
#' @description
#' Virusinterpreter file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here("nogit")
#' v <- Virusinterpreter$new(path)
#' }
#' @export
Virusinterpreter <- R6::R6Class(
  "Virusinterpreter",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Virusinterpreter object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "virusinterpreter", path = path)
      self$tidy = super$.tidy(envir = self)
    },

    #' @description Read `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_annotated = function(x) {
      self$.parse_file(x, "annotated")
    },
    #' @description Tidy `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_annotated = function(x) {
      self$.tidy_file(x, "annotated")
    }
  ) # end public
)

#' @title Virusinterpreter Object
#'
#' @description
#' Virusinterpreter file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/virusinterpreter"
#' )
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
      schema <- self$config$.raw_schema("annotated")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_annotated = function(x) {
      raw <- self$parse_annotated(x)
      schema <- self$config$.tidy_schema("annotated")
      colnames(raw) <- schema[["field"]]
      list(annotated = raw) |>
        tibble::enframe(value = "data")
    }
  ) # end public
)

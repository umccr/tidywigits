#' @title Virusbreakend Object
#'
#' @description
#' Virusbreakend file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/virusbreakend"
#' )
#' v <- Virusbreakend$new(path)
#' }
#' @export
Virusbreakend <- R6::R6Class(
  "Virusbreakend",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Virusbreakend object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "virusbreakend", path = path)
      self$tidy = super$.tidy(envir = self)
    },

    #' @description Read `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      schema <- self$config$.raw_schema("summary")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      raw <- self$parse_summary(x)
      schema <- self$config$.tidy_schema("summary")
      colnames(raw) <- schema[["field"]]
      list(summary = raw) |>
        tibble::enframe(name = "name", value = "data")
    }
  ) # end public
)

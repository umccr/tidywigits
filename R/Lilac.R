#' @title Lilac Object
#'
#' @description
#' Lilac file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/lilac"
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
      schema <- self$config$.raw_schema("summary")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `lilac.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      raw <- self$parse_summary(x)
      schema <- self$config$.tidy_schema("summary")
      colnames(raw) <- schema[["field"]]
      raw
    },
    #' @description Read `lilac.qc.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      schema <- self$config$.raw_schema("qc")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `lilac.qc.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      raw <- self$parse_qc(x)
      schema <- self$config$.tidy_schema("qc")
      colnames(raw) <- schema[["field"]]
      raw
    }
  )
)

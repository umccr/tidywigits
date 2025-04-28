#' @title Alignments Object
#'
#' @description
#' Alignments file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/alignments"
#' )
#' a <- Alignments$new(path)
#' }
#' @export
Alignments <- R6::R6Class(
  "Alignments",
  inherit = Tool,
  public = list(
    #' @field tidy (`function(1)`)\cr
    #' Tidy function
    tidy = NULL,
    #' @description Create a new Alignments object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "alignments", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `duplicate_freq.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_dupfreq = function(x) {
      schema <- self$config$.raw_schema("dupfreq")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `duplicate_freq.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_dupfreq = function(x) {
      raw <- self$parse_dupfreq(x)
      schema <- self$config$.tidy_schema("dupfreq")
      colnames(raw) <- schema[["field"]]
      raw
    }
  )
)

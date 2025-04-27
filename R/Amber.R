#' @title Amber Object
#'
#' @description
#' Amber file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/amber"
#' )
#' a <- Amber$new(path)
#' d <- a$files |>
#'   dplyr::mutate(parser = glue("parse_{parser}")) |>
#'   dplyr::rowwise() |>
#'   dplyr::mutate(d = list(a$eval_func(.data$parser)(.data$path)))
#' }
#' @export
Amber <- R6::R6Class(
  "Amber",
  inherit = Tool,
  public = list(
    #' @description Create a new Amber object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "amber", path = path)
    },
    #' @description Read `baf.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_bafpcf = function(x) {
      schema <- self$config$raw_schema("bafpcf")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Read `baf.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_baftsv = function(x) {
      schema <- self$config$raw_schema("baftsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Read `contamination.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_contaminationtsv = function(x) {
      schema <- self$config$raw_schema("contaminationtsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Read `homozygousregion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_homozygousregion = function(x) {
      schema <- self$config$raw_schema("homozygousregion")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Read `homozygousregion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      schema <- self$config$raw_schema("qc")
      d <- parse_file(x, schema, type = "tsv-nohead")
      d
    }
  )
)

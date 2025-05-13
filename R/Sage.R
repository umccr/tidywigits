#' @title Sage Object
#'
#' @description
#' Sage file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/sage"
#' )
#' s <- Sage$new(path)
#' s$tidy
#' s$tidy$tidy |>
#'   purrr::set_names(s$tidy$parser) |>
#'   purrr::map(\(x) str(x[["data"]][[1]]))
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
      schema <- self$config$.raw_schema("bqrtsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `bqr.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_bqrtsv = function(x) {
      raw <- self$parse_bqrtsv(x)
      schema <- self$config$.tidy_schema("bqrtsv")
      colnames(raw) <- schema[["field"]]
      list(bqrtsv = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `gene.coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_genecvg = function(x) {
      schema <- self$config$.raw_schema("genecvg")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `gene.coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecvg = function(x) {
      raw <- self$parse_genecvg(x)
      schema <- self$config$.tidy_schema("genecvg")
      colnames(raw) <- schema[["field"]]
      list(genecvg = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `exon.medians.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_exoncvg = function(x) {
      schema <- self$config$.raw_schema("exoncvg")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `exon.medians.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_exoncvg = function(x) {
      raw <- self$parse_exoncvg(x)
      schema <- self$config$.tidy_schema("exoncvg")
      colnames(raw) <- schema[["field"]]
      list(exoncvg = raw) |>
        tibble::enframe(value = "data")
    }
  )
)

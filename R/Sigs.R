#' @title Sigs Object
#'
#' @description
#' Sigs file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/sigs"
#' )
#' s <- Sigs$new(path)
#' }
#' @export
Sigs <- R6::R6Class(
  "Sigs",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Sigs object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "sigs", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `allocation.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_allocation = function(x) {
      schema <- self$config$.raw_schema("allocation")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `allocation.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_allocation = function(x) {
      raw <- self$parse_allocation(x)
      schema <- self$config$.tidy_schema("allocation")
      assertthat::assert_that(all(colnames(raw) == schema[["field"]]))
      list(allocation = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `snv_counts.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_snvcounts = function(x) {
      schema <- self$config$.raw_schema("snvcounts")
      d <- parse_file(
        x,
        schema,
        type = "csv",
        skip = 1,
        cnames = schema[["field"]]
      )
      d
    },
    #' @description Tidy `snv_counts.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_snvcounts = function(x) {
      raw <- self$parse_snvcounts(x)
      schema <- self$config$.tidy_schema("snvcounts")
      colnames(raw) <- schema[["field"]]
      list(snvcounts = raw) |>
        tibble::enframe(value = "data")
    }
  )
)

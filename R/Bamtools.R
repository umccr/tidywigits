#' @title Bamtools Object
#'
#' @description
#' Bamtools file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/bamtools"
#' )
#' b <- Bamtools$new(path)
#' }
#' @export
Bamtools <- R6::R6Class(
  "Bamtools",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Bamtools object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "bamtools", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_wgsmetrics = function(x) {
      # handle two different sections
      schema <- self$config$.raw_schema("wgsmetrics")
      # first make sure colnames are as expected
      hdr1 <- readr::read_tsv(
        file = x,
        col_types = readr::cols(.default = "c"),
        comment = "#",
        n_max = 0
      )
      assertthat::assert_that(all(colnames(hdr1) == schema[["field"]]))
      hdr2 <- readr::read_tsv(
        file = x,
        col_types = readr::cols(.default = "c"),
        comment = "#",
        skip = 3,
        n_max = 0
      )
      assertthat::assert_that(all(
        colnames(hdr2) == c("coverage", "high_quality_coverage_count")
      ))
      # now parse with proper classes
      d1 <- parse_file(
        x,
        schema = schema,
        type = "tsv",
        comment = "#",
        n_max = 1
      )
      d2 <- readr::read_tsv(x, col_types = "ci", comment = "#", skip = 3)
      list(metrics = d1[], histo = d2[])
    },
    #' @description Tidy `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_wgsmetrics = function(x) {
      raw <- self$parse_wgsmetrics(x)
      schema <- self$config$.tidy_schema("wgsmetrics")
      d <- list(
        bamtools_wgsmetrics_metrics = raw[["metrics"]],
        bamtools_wgsmetrics_histo = raw[["histo"]]
      )
      colnames(d[["bamtools_wgsmetrics_metrics"]]) <- schema[["field"]]
      tibble::enframe(d, name = "name", value = "data")
    }
  )
)

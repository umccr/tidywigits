#' @title Cobalt Object
#'
#' @description
#' Cobalt file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/cobalt"
#' )
#' cob <- Cobalt$new(path)
#' }
#' @export
Cobalt <- R6::R6Class(
  "cobalt",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Cobalt object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "cobalt", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_gcmed = function(x) {
      d1 <- readr::read_tsv(x, col_names = TRUE, col_types = "dd", n_max = 1)[]
      schema <- self$config$.raw_schema("gcmed")
      d2 <- parse_file(x, schema, type = "tsv", skip = 2)
      list(sample_stats = d1, bucket_stats = d2)
    },
    #' @description Tidy `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_gcmed = function(x) {
      raw <- self$parse_gcmed(x)
      assertthat::assert_that(all(
        names(raw) == c("sample_stats", "bucket_stats")
      ))
      schema <- self$config$.tidy_schema("gcmed")
      colnames(raw[["bucket_stats"]]) <- schema[["field"]]
      colnames(raw[["sample_stats"]]) <- c("mean", "median")
      raw[["sample_stats"]] <- raw[["sample_stats"]]
      tibble::enframe(raw, name = "name", value = "data")
    }
  )
)

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
      # self$tidy = super$.tidy(envir = self)
    },

    #' @description Read `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_annotated = function(x) {
      # TODO: refactor into separate func
      hdr <- readr::read_tsv(
        x,
        col_types = readr::cols(.default = "c"),
        n_max = 0
      ) |>
        colnames()
      schemas_all <- self$config$.raw_schemas_all() |>
        dplyr::filter(name == "annotated")
      schema <- schemas_all |>
        dplyr::select(version, schema) |>
        dplyr::rowwise() |>
        dplyr::mutate(
          length_match = length(hdr) == nrow(.data$schema),
          all_match = if (length_match) {
            all(hdr == .data$schema[["field"]])
          } else {
            FALSE
          }
        ) |>
        dplyr::filter(.data$all_match) |>
        dplyr::ungroup()
      assertthat::assert_that(nrow(schema) == 1)
      version <- schema$version
      schema <- schema |>
        dplyr::select("schema") |>
        tidyr::unnest("schema")
      d <- parse_file(x, schema, type = "tsv")
      attr(d, "file_version") <- version
      d
    },
    #' @description Tidy `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_annotated = function(x) {
      raw <- self$parse_annotated(x)
      version <- attr(raw, "file_version")
      schema <- self$config$.tidy_schema("annotated", v = version)
      colnames(raw) <- schema[["field"]]
      list(annotated = raw) |>
        tibble::enframe(value = "data")
    }
  ) # end public
)

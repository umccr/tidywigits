#' @title Virusinterpreter Object
#'
#' @description
#' Virusinterpreter file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here("nogit")
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
      # TODO: refactor into separate func
      cnames <- file_hdr(x, delim = "\t")
      schemas_all <- self$config$.raw_schemas_all() |>
        dplyr::filter(.data$name == "annotated")
      schema1 <- schema_guess(cnames = cnames, schemas_all = schemas_all)
      d <- parse_file(x, schema1$schema, type = "tsv")
      attr(d, "file_version") <- schema1$version
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

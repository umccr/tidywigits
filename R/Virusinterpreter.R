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
    #' @description Create a new Virusinterpreter object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    initialize = function(path = NULL, files_tbl = NULL, tidy = TRUE, keep_raw = FALSE) {
      super$initialize(name = "virusinterpreter", path = path, files_tbl = files_tbl)
    },

    #' @description Read `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_annotated = function(x) {
      self$.parse_file(x, "annotated")
    },
    #' @description Tidy `virus.annotated.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_annotated = function(x) {
      self$.tidy_file(x, "annotated")
    }
  ) # end public
)

#' @title Sigs Object
#'
#' @description
#' Sigs file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
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
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    initialize = function(
      path = NULL,
      files_tbl = NULL,
      tidy = TRUE,
      keep_raw = FALSE
    ) {
      super$initialize(name = "sigs", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self, tidy = tidy, keep_raw = keep_raw)
    },
    #' @description Read `allocation.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_allocation = function(x) {
      self$.parse_file(x, "allocation")
    },
    #' @description Tidy `allocation.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_allocation = function(x) {
      self$.tidy_file(x, "allocation")
    },
    #' @description Read `snv_counts.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_snvcounts = function(x) {
      self$.parse_file_nohead(x, "snvcounts", delim = ",", skip = 1)
    },
    #' @description Tidy `snv_counts.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_snvcounts = function(x) {
      self$.tidy_file(x, "snvcounts")
    }
  )
)

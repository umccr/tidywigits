#' @title Chord Object
#'
#' @description
#' Chord file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' ch <- Chord$new(path)
#' }
#' @export
Chord <- R6::R6Class(
  "Chord",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Chord object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "chord", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `prediction.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_prediction = function(x) {
      self$.parse_file(x, "prediction")
    },
    #' @description Tidy `prediction.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_prediction = function(x) {
      self$.tidy_file(x, "prediction")
    },
    #' @description Read `signatures.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_signatures = function(x) {
      n_max <- 0
      hdr <- readr::read_tsv(
        x,
        col_names = TRUE,
        col_types = readr::cols(.default = "c"),
        n_max = n_max
      )
      schema <- self$.raw_schema("signatures") |>
        tibble::deframe()

      # header contains sample column in latest version
      if (colnames(hdr)[1] != "sample_id") {
        assertthat::assert_that(all(colnames(hdr) == names(schema)[-1]))
        cnames <- c("sample_id", colnames(hdr))
      } else {
        assertthat::assert_that(all(colnames(hdr) == names(schema)))
        cnames <- colnames(hdr)
      }
      d <- readr::read_tsv(x, col_names = cnames, col_types = schema, skip = 1)
      d[]
    },
    #' @description Tidy `signatures.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_signatures = function(x) {
      raw <- self$parse_signatures(x)
      d <- raw |>
        tidyr::pivot_longer(
          cols = -c("sample_id"),
          names_to = "signature",
          values_to = "count"
        ) |>
        dplyr::select("signature", "count")
      schema <- self$.tidy_schema("signatures")
      assertthat::assert_that(all(colnames(d) == schema[["field"]]))
      list(signatures = d) |>
        tibble::enframe(value = "data")
    }
  )
)

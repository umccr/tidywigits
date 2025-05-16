#' @title Chord Object
#'
#' @description
#' Chord file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oa_v2/chord"
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
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "chord", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `prediction.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_prediction = function(x) {
      schema <- self$config$.raw_schema("prediction")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `prediction.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_prediction = function(x) {
      schema <- self$config$.tidy_schema("prediction")
      raw <- self$parse_prediction(x)
      d <- raw |>
        dplyr::select(-c("sample"))
      colnames(d) <- schema[["field"]]
      list(prediction = d) |>
        tibble::enframe(value = "data")
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
      schema <- self$config$.raw_schema("signatures") |>
        dplyr::mutate(
          type = dplyr::case_match(
            .data$type,
            "char" ~ "c",
            "int" ~ "i",
            "float" ~ "d"
          )
        ) |>
        tibble::deframe()

      # header contains sample column in latest version
      if (!"sample_id" == colnames(hdr)[1]) {
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
      schema <- self$config$.tidy_schema("signatures")
      assertthat::assert_that(all(colnames(d) == schema[["field"]]))
      list(signatures = d) |>
        tibble::enframe(value = "data")
    }
  )
)

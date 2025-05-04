#' @title Purple Object
#'
#' @description
#' Purple file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/purple"
#' )
#' p <- Purple$new(path)
#' }
#' @export
Purple <- R6::R6Class(
  "Purple",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Purple object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "purple", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      schema <- self$config$.raw_schema("version")
      d <- parse_file(x, schema, type = "txt-nohead", delim = "=")
      d
    },
    #' @description Tidy `purple.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      raw <- self$parse_version(x)
      col_types <- self$config$.tidy_schema("version") |>
        dplyr::mutate(
          type = dplyr::case_match(
            .data$type,
            "char" ~ "c",
            "int" ~ "i",
            "float" ~ "d"
          )
        ) |>
        dplyr::select("field", "type") |>
        tibble::deframe()

      d <- raw |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        purrr::set_names(names(col_types)) |>
        readr::type_convert(col_types = rlang::exec(readr::cols, !!!col_types))
      list(version = d) |>
        tibble::enframe(name = "name", value = "data")
    }
  ) # end public
)

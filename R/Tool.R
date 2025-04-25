#' @title Tool Object
#'
#' @description
#' Base class for all wigits tools.
#' @examples
#' \dontrun{
#' name <- "amber"
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/amber"
#' )
#' x <- Tool$new(name, path)
#' }
#'
#' @export
Tool <- R6::R6Class(
  "Tool",
  public = list(
    #' @field name (`character(1)`)\cr
    #' Name of tool.
    name = NULL,
    #' @field path  (`character(1)`)\cr
    #' Output directory of tool
    path = NULL,
    #' @field config (`Config()`)\cr
    #' Config of tool.
    config = NULL,
    #' @field files (`tibble()`)\cr
    #' Tibble of files matching available Tool patterns.
    files = NULL,

    #' @description Create a new Tool object.
    #' @param name (`character(1)`)\cr
    #' Name of tool.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(name, path) {
      self$name <- name
      self$path <- path
      self$config <- Config$new(self$name)
      self$files <- self$list_files()
    },
    #' @description Print details about the Tool.
    #' @param ... (ignored).
    print = function(...) {
      # fmt: skip
      res <- tibble::tribble(
        ~var, ~value,
        "name", self$name,
        "path", self$path
      ) |>
        tidyr::unnest("value")
      cat("#--- Tool ---#\n")
      print(res)
      invisible(self)
    },
    #' @description List files in given tool directory.
    list_files = function() {
      patterns <- self$config$raw_patterns()
      files <- list_files_dir(self$path)
      res <- files |>
        dplyr::rowwise() |>
        dplyr::mutate(
          matched_name = list(
            patterns |>
              dplyr::filter(stringr::str_detect(bname, .data$value)) |>
              dplyr::select(parser = "name", pattern = "value")
          )
        ) |>
        tidyr::unnest("matched_name") |>
        dplyr::select(
          "parser",
          "bname",
          "size",
          "lastmodified",
          "path",
          "pattern"
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
          FileObj = list(
            File$new(
              path = .data$path,
              suffix_pattern = .data$pattern
            )
          ),
          prefix = FileObj$prefix,
          schema = list(self$config$raw_schema(.data$parser))
        )
      res
    }
  )
)

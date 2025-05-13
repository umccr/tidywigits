#' @title Oncoanalyser Object
#'
#' @description
#' Oncoanalyser file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332"
#' )
#' oa <- Oncoanalyser$new(path)
#' oa$tbl |>
#'   dplyr::select(tool, tidy) |>
#'   tidyr::unnest(tidy)
#' }
#' @export
Oncoanalyser <- R6::R6Class(
  "Oncoanalyser",
  public = list(
    #' @field path (`character(1)`)\cr
    #' Absolute path to oncoanalyser results.
    path = NULL,
    #' @field tbl (`tibble()`)\cr
    #' Tidy tibble with oncoanalyser results.
    tbl = NULL,
    #' @description Create a new Oncoanalyser object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path = NULL) {
      self$path <- normalizePath(path)
      res <- list(
        alignments = Alignments$new(file.path(path, "alignments")),
        amber = Amber$new(file.path(path, "amber")),
        bamtools = Bamtools$new(file.path(path, "bamtools")),
        chord = Chord$new(file.path(path, "chord")),
        cobalt = Cobalt$new(file.path(path, "cobalt")),
        cuppa = Cuppa$new(file.path(path, "cuppa")),
        flagstats = Flagstats$new(file.path(path, "flagstats")),
        lilac = Lilac$new(file.path(path, "lilac")),
        linx = Linx$new(file.path(path, "linx")),
        purple = Purple$new(file.path(path, "purple")),
        sage = Sage$new(file.path(path, "sage")),
        sigs = Sigs$new(file.path(path, "sigs")),
        virusbreakend = Virusbreakend$new(file.path(path, "virusbreakend")),
        virusinterpreter = Virusinterpreter$new(file.path(
          path,
          "virusinterpreter"
        ))
      )
      d <- res |>
        purrr::map(\(x) x[["tidy"]]) |>
        dplyr::bind_rows(.id = "tool")
      self$tbl <- d
    },
    #' @description Print details about the File.
    #' @param ... (ignored).
    print = function(...) {
      # fmt: skip
      res <- tibble::tribble(
        ~var, ~value,
        "path", self$path
      )
      cat("#--- Oncoanalyser ---#\n")
      print(res)
      invisible(self)
    }
  )
)

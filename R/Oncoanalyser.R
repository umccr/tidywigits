#' @title Oncoanalyser Object
#'
#' @description
#' Oncoanalyser file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here("nogit")
#' oa <- Oncoanalyser$new(path)
#' oa$tbl |>
#'   dplyr::select(tool, prefix, prefix2, tidy) |>
#'   tidyr::unnest(tidy) |>
#'   print(n = 100)
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
      ft <- list_files_dir(self$path)
      res <- list(
        alignments = Alignments$new(files_tbl = ft),
        amber = Amber$new(files_tbl = ft),
        bamtools = Bamtools$new(files_tbl = ft),
        chord = Chord$new(files_tbl = ft),
        cobalt = Cobalt$new(files_tbl = ft),
        cuppa = Cuppa$new(files_tbl = ft),
        flagstats = Flagstats$new(files_tbl = ft),
        lilac = Lilac$new(files_tbl = ft),
        linx = Linx$new(files_tbl = ft),
        purple = Purple$new(files_tbl = ft),
        sage = Sage$new(files_tbl = ft),
        sigs = Sigs$new(files_tbl = ft),
        virusbreakend = Virusbreakend$new(files_tbl = ft),
        virusinterpreter = Virusinterpreter$new(files_tbl = ft)
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
        "path", self$path,
        "ntools", as.character(dplyr::distinct(self$tbl, .data$tool) |> nrow()),
        "nraw", as.character(nrow(self$tbl)),
        "ntidy", as.character(tidyr::unnest(self$tbl, "tidy") |> nrow())
      )
      cat("#--- Oncoanalyser ---#\n")
      print(res)
      invisible(self)
    }
  )
)

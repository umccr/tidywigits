#' @title Oncoanalyser Object
#'
#' @description
#' Oncoanalyser file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here("nogit/oa_v1")
#' oa <- Oncoanalyser$new(path)
#' oa$magic(
#'     odir = "nogit/test_data2",
#'     pref = "sampleA",
#'     fmt = "parquet",
#'     id = "run1"
#' )
#' }
#' @export
Oncoanalyser <- R6::R6Class(
  "Oncoanalyser",
  inherit = Workflow,
  public = list(
    #' @description Create a new Oncoanalyser object.
    #' @param path (`character(n)`)\cr
    #' Path(s) to Oncoanalyser results.
    initialize = function(path = NULL) {
      tools <- list(
        alignments = Alignments,
        amber = Amber,
        bamtools = Bamtools,
        chord = Chord,
        cobalt = Cobalt,
        cuppa = Cuppa,
        flagstats = Flagstats,
        isofox = Isofox,
        lilac = Lilac,
        linx = Linx,
        purple = Purple,
        sage = Sage,
        sigs = Sigs,
        virusbreakend = Virusbreakend,
        virusinterpreter = Virusinterpreter
      )
      super$initialize(name = "Oncoanalyser", path = path, tools = tools)
    }
  ) # public end
)

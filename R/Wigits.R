#' @title Wigits Object
#'
#' @description
#' WiGiTS file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here("nogit/oa_v2")
#' w <- Wigits$new(path)
#' x <-
#'   w$nemofy(
#'     odir = "nogit/test_data",
#'     format = "parquet",
#'     id = "run1"
#' )
#' dbconn <- DBI::dbConnect(
#'   drv = RPostgres::Postgres(),
#'   dbname = "nemo",
#'   user = "orcabus"
#' )
#' x <-
#'   w$nemofy(
#'     format = "db",
#'     id = "runABC456",
#'     dbconn = dbconn
#' )
#' }
#' @export
Wigits <- R6::R6Class(
  "Wigits",
  inherit = Workflow,
  public = list(
    #' @description Create a new Wigits object.
    #' @param path (`character(n)`)\cr
    #' Path(s) to Wigits results.
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
        neo = Neo,
        purple = Purple,
        sage = Sage,
        sigs = Sigs,
        virusbreakend = Virusbreakend,
        virusinterpreter = Virusinterpreter
      )
      super$initialize(name = "Wigits", path = path, tools = tools)
    }
  ) # public end
)

#' WiGiTS Tool Names
#'
#' Vector of all supported WiGiTS tool names.
#'
#' @export
WIGITS_TOOLS <- c(
  "alignments",
  "amber",
  "bamtools",
  "chord",
  "cobalt",
  "cuppa",
  "esvee",
  "flagstats",
  "isofox",
  "lilac",
  "linx",
  "neo",
  "purple",
  "sage",
  "sigs",
  "virusbreakend",
  "virusinterpreter"
)

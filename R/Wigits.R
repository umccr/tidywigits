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
#'     diro = "nogit/test_data",
#'     format = "parquet",
#'     input_id = "run1"
#' )
#' dbconn <- DBI::dbConnect(
#'   drv = RPostgres::Postgres(),
#'   dbname = "nemo",
#'   user = "orcabus"
#' )
#' x <-
#'   w$nemofy(
#'     format = "db",
#'     input_id = "runABC456",
#'     dbconn = dbconn
#' )
#' DBI::dbDisconnect(dbconn)
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
        cider = Cider,
        cobalt = Cobalt,
        cuppa = Cuppa,
        flagstats = Flagstats,
        isofox = Isofox,
        lilac = Lilac,
        linx = Linx,
        neo = Neo,
        peach = Peach,
        purple = Purple,
        sage = Sage,
        sigs = Sigs,
        teal = Teal,
        virusbreakend = Virusbreakend,
        virusinterpreter = Virusinterpreter
      )
      super$initialize(name = "Wigits", path = path, tools = tools)
    },
    #' @description Get metadata. Overwrites parent class to handle
    #' tidywigits not being a dependency of nemo (see tidywigits issue 167)
    #' @param input_id (`character(1)`)\cr
    #' Input ID to use for the dataset (e.g. `run123`).
    #' @param output_id (`character(1)`)\cr
    #' Output ID to use for the dataset (e.g. `run123`).
    #' @param output_dir (`character(1)`)\cr
    #' Output directory.
    #' @param pkgs (`character(n)`)\cr
    #' Which R packages to extract versions for.
    #' @return List with metadata
    get_metadata = function(input_id, output_id, output_dir, pkgs = c("nemo", "tidywigits")) {
      super$get_metadata(
        input_id = input_id,
        output_id = output_id,
        output_dir = output_dir,
        pkgs = pkgs
      )
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
  "cider",
  "cobalt",
  "cuppa",
  "esvee",
  "flagstats",
  "isofox",
  "lilac",
  "linx",
  "neo",
  "peach",
  "purple",
  "sage",
  "sigs",
  "teal",
  "virusbreakend",
  "virusinterpreter"
)

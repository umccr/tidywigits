#' @title Esvee Object
#'
#' @description
#' Esvee file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' sv <- Esvee$new(path)
#' sv$tidy()
#' sv$tbls$tidy |>
#'   purrr::set_names(sv$tbls$parser) |>
#'   purrr::map(\(x) x[["data"]][[1]])
#' }
#' @export
Esvee <- R6::R6Class(
  "Esvee",
  inherit = Tool,
  public = list(
    #' @description Create a new Esvee object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "esvee", path = path, files_tbl = files_tbl)
    },
    #' @description Read `prep.fragment_length.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_prepfraglen = function(x) {
      self$.parse_file(x, "prepfraglen")
    },
    #' @description Tidy `prep.fragment_length.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_prepfraglen = function(x) {
      self$.tidy_file(x, "prepfraglen")
    },
    #' @description Read `prep.disc_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_prepdiscstats = function(x) {
      self$.parse_file(x, "prepdiscstats")
    },
    #' @description Tidy `prep.disc_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_prepdiscstats = function(x) {
      self$.tidy_file(x, "prepdiscstats")
    },
    #' @description Read `prep.junction.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_prepjunction = function(x) {
      self$.parse_file(x, "prepjunction")
    },
    #' @description Tidy `prep.junction.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_prepjunction = function(x) {
      self$.tidy_file(x, "prepjunction")
    },
    #' @description Read `esvee.phased_assembly.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_assemblephased = function(x) {
      self$.parse_file(x, "assemblephased")
    },
    #' @description Tidy `esvee.phased_assembly.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_assemblephased = function(x) {
      self$.tidy_file(x, "assemblephased")
    },
    #' @description Read `esvee.assembly.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_assembleassembly = function(x) {
      self$.parse_file(x, "assembleassembly")
    },
    #' @description Tidy `esvee.assembly.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_assembleassembly = function(x) {
      self$.tidy_file(x, "assembleassembly")
    },
    #' @description Read `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_assemblebreakend = function(x) {
      self$.parse_file(x, "assemblebreakend")
    },
    #' @description Tidy `breakend.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_assemblebreakend = function(x) {
      self$.tidy_file(x, "assemblebreakend")
    },
    #' @description Read `alignment.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_assemblealignment = function(x) {
      self$.parse_file(x, "assemblealignment")
    },
    #' @description Tidy `alignment.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_assemblealignment = function(x) {
      self$.tidy_file(x, "assemblealignment")
    }
  ) # end public
)

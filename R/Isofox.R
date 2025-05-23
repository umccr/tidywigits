#' @title Isofox Object
#'
#' @description
#' Isofox file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' i <- Isofox$new(path)
#' i$tidy$tidy |>
#'   purrr::set_names(i$tidy$parser) |>
#'   purrr::map(\(x) x[["data"]][[1]])
#' }
#' @export
Isofox <- R6::R6Class(
  "Isofox",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Isofox object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "isofox", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `summary.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      self$.parse_file(x, "summary", delim = ",")
    },
    #' @description Tidy `summary.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      self$.tidy_file(x, "summary")
    },
    #' @description Read `gene_data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_genedata = function(x) {
      self$.parse_file(x, "genedata", delim = ",")
    },
    #' @description Tidy `gene_data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genedata = function(x) {
      self$.tidy_file(x, "genedata")
    },
    #' @description Read `transcipt_data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_transdata = function(x) {
      self$.parse_file(x, "transdata", delim = ",")
    },
    #' @description Tidy `transcipt_data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_transdata = function(x) {
      self$.tidy_file(x, "transdata")
    },
    #' @description Read `alt_splice_junc.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_altsj = function(x) {
      self$.parse_file(x, "altsj", delim = ",")
    },
    #' @description Tidy `alt_splice_junc.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_altsj = function(x) {
      self$.tidy_file(x, "altsj")
    },
    #' @description Read `retained_intron.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_retintron = function(x) {
      self$.parse_file(x, "retintron", delim = ",")
    },
    #' @description Tidy `retained_intron.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_retintron = function(x) {
      self$.tidy_file(x, "retintron")
    },
    #' @description Read `fusions.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_fusionsall = function(x) {
      self$.parse_file(x, "fusionsall", delim = ",")
    },
    #' @description Tidy `fusions.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_fusionsall = function(x) {
      self$.tidy_file(x, "fusionsall")
    },
    #' @description Read `pass_fusions.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_fusionspass = function(x) {
      self$.parse_file(x, "fusionspass", delim = ",")
    },
    #' @description Tidy `pass_fusions.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_fusionspass = function(x) {
      self$.tidy_file(x, "fusionspass")
    },
    #' @description Read `gene_collection.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_genecollection = function(x) {
      self$.parse_file(x, "genecollection", delim = ",")
    },
    #' @description Tidy `gene_collection.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecollection = function(x) {
      self$.tidy_file(x, "genecollection")
    }
  )
)

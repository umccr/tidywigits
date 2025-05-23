#' @title Amber Object
#'
#' @description
#' Amber file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/amber"
#' )
#' a <- Amber$new(path)
#' a$tidy
#' }
#' @export
Amber <- R6::R6Class(
  "Amber",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Amber object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "amber", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `baf.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_bafpcf = function(x) {
      self$.parse_file(x, "bafpcf")
    },
    #' @description Tidy `baf.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_bafpcf = function(x) {
      self$.tidy_file(x, "bafpcf")
    },
    #' @description Read `baf.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_baftsv = function(x) {
      self$.parse_file(x, "baftsv")
    },
    #' @description Tidy `baf.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_baftsv = function(x) {
      self$.tidy_file(x, "baftsv")
    },
    #' @description Read `contamination.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_contaminationtsv = function(x) {
      self$.parse_file(x, "contaminationtsv")
    },
    #' @description Tidy `contamination.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_contaminationtsv = function(x) {
      self$.tidy_file(x, "contaminationtsv")
    },
    #' @description Read `homozygousregion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_homozygousregion = function(x) {
      self$.parse_file(x, "homozygousregion")
    },
    #' @description Tidy `homozygousregion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_homozygousregion = function(x) {
      self$.tidy_file(x, "homozygousregion")
    },
    #' @description Read `qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      d0 <- self$.parse_file_nohead(x, "qc")
      d0 |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        set_tbl_version_attr(get_tbl_version_attr(d0))
    },
    #' @description Tidy `qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      self$.tidy_file(x, "qc", convert_types = TRUE)
    }
  )
)

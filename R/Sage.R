#' @title Sage Object
#'
#' @description
#' Sage file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' s <- Sage$new(path)
#' s$tidy
#' s$tidy$tidy |>
#'   purrr::set_names(s$tidy$parser) |>
#'   purrr::map(\(x) x[["data"]][[1]])
#' }
#' @export
Sage <- R6::R6Class(
  "Sage",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Sage object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "sage", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `bqr.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_bqrtsv = function(x) {
      self$.parse_file(x, "bqrtsv")
    },
    #' @description Tidy `bqr.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_bqrtsv = function(x) {
      self$.tidy_file(x, "bqrtsv")
    },
    #' @description Read `gene.coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_genecvg = function(x) {
      self$.parse_file(x, "genecvg")
    },
    #' @description Tidy `gene.coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_genecvg = function(x) {
      d <- self$.tidy_file(x, "genecvg") |>
        dplyr::select("data") |>
        tidyr::unnest("data")
      # make sure genes are unique
      assertthat::assert_that(nrow(d) == nrow(dplyr::distinct(d, .data$gene)))
      genes <- d |>
        dplyr::select(!dplyr::starts_with("dr_"))
      cvg <- d |>
        tidyr::pivot_longer(
          dplyr::starts_with("dr_"),
          names_to = "dr",
          values_to = "value"
        ) |>
        dplyr::select("gene", "dr", "value")
      list(genes = genes, cvg = cvg) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `exon.medians.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_exoncvg = function(x) {
      self$.parse_file(x, "exoncvg")
    },
    #' @description Tidy `exon.medians.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_exoncvg = function(x) {
      self$.tidy_file(x, "exoncvg")
    }
  )
)

#' @title Cobalt Object
#'
#' @description
#' Cobalt file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' cob <- Cobalt$new(path)
#' cob$.tidy()
#' cob$tbls$tidy |>
#'   purrr::set_names(cob$tbls$parser) |>
#'   purrr::map(\(x) x[["data"]][[1]])
#' }
#' @export
Cobalt <- R6::R6Class(
  "Cobalt",
  inherit = Tool,
  public = list(
    #' @description Create a new Cobalt object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cobalt", path = path, files_tbl = files_tbl)
    },
    #' @description Read `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_gcmed = function(x) {
      # first two rows are mean/median + their values
      d1 <- readr::read_tsv(x, col_names = TRUE, col_types = "dd", n_max = 1)
      # next rows are median per bucket
      d2 <- self$.parse_file(x, "gcmed", skip = 2)
      list(sample_stats = d1[], bucket_stats = d2) |>
        enframe_data()
    },
    #' @description Tidy `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_gcmed = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_gcmed(x)
      }
      d <- x |> tibble::deframe()
      assertthat::assert_that(
        identical(names(d), c("sample_stats", "bucket_stats"))
      )
      schema <- self$.tidy_schema("gcmed")
      colnames(d[["bucket_stats"]]) <- schema[["field"]]
      colnames(d[["sample_stats"]]) <- c("mean", "median")
      enframe_data(d)
    },
    #' @description Read `ratio.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_ratiomed = function(x) {
      self$.parse_file(x, "ratiomed")
    },
    #' @description Tidy `ratio.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_ratiomed = function(x) {
      self$.tidy_file(x, "ratiomed")
    },
    #' @description Read `ratio.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_ratiotsv = function(x) {
      self$.parse_file(x, "ratiotsv")
    },
    #' @description Tidy `ratio.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_ratiotsv = function(x) {
      self$.tidy_file(x, "ratiotsv")
    },
    #' @description Read `ratio.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_ratiopcf = function(x) {
      self$.parse_file(x, "ratiopcf")
    },
    #' @description Tidy `ratio.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_ratiopcf = function(x) {
      self$.tidy_file(x, "ratiopcf")
    },
    #' @description Read `cobalt.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      d0 <- self$.parse_file_nohead(x, "version", delim = "=")
      d0 |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        set_tbl_version_attr(get_tbl_version_attr(d0))
    },
    #' @description Tidy `cobalt.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      self$.tidy_file(x, "version")
    }
  ) # end public
)

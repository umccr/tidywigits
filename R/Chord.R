#' @title Chord Object
#'
#' @description
#' Chord file parsing and manipulation.
#' @examples
#' cls <- Chord
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "chord_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "chord.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' @export
Chord <- R6::R6Class(
  "Chord",
  inherit = Tool,
  public = list(
    #' @description Create a new Chord object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "chord", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `prediction.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_prediction = function(x) {
      self$.parse_file(x, "prediction")
    },
    #' @description Tidy `prediction.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_prediction = function(x) {
      self$.tidy_file(x, "prediction")
    },
    #' @description Read `signatures.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_signatures = function(x) {
      hdr <- nemo::file_hdr(x)
      version <- "latest" # only one version currently supported
      schema <- self$get_raw_schema("signatures", v = version) |>
        dplyr::select("field", "type") |>
        tibble::deframe()

      # header contains sample column in latest version
      if (hdr[1] != "sample_id") {
        stopifnot(identical(hdr, names(schema)[-1]))
        cnames <- c("sample_id", hdr)
      } else {
        stopifnot(identical(hdr, names(schema)))
        cnames <- hdr
      }
      d <- readr::read_tsv(x, col_names = cnames, col_types = schema, skip = 1) |>
        nemo::set_tbl_version_attr(version)
      d[]
    },
    #' @description Tidy `signatures.txt` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_signatures = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_signatures(x)
      }
      version <- nemo::get_tbl_version_attr(x)
      d <- x |>
        tidyr::pivot_longer(
          cols = -c("sample_id"),
          names_to = "signature",
          values_to = "count"
        ) |>
        dplyr::select("signature", "count") |>
        nemo::set_tbl_version_attr(version)
      schema <- self$get_tidy_schema("signatures")
      stopifnot(identical(colnames(d), schema[["field"]]))
      list(signatures = d) |>
        nemo::enframe_data()
    }
  )
)

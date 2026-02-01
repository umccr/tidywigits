#' @title Virusbreakend Object
#'
#' @description
#' Virusbreakend file parsing and manipulation.
#' @examples
#' cls <- Virusbreakend
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "virusbreakend_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", input_id = id)
#' (lf <- list.files(odir, pattern = "virusbreakend.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 1)
#' @export
Virusbreakend <- R6::R6Class(
  "Virusbreakend",
  inherit = Tool,
  public = list(
    #' @description Create a new Virusbreakend object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "virusbreakend", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },

    #' @description Read `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      schema <- self$get_raw_schema("summary", v = "latest") |>
        dplyr::select("field", "type")
      # file is either completely empty, or with colnames + data
      hdr <- nemo::file_hdr(x)
      if (length(hdr) == 0) {
        ctypes <- paste(schema[["type"]], collapse = "")
        etbl <- nemo::empty_tbl(cnames = schema[["field"]], ctypes = ctypes) |>
          nemo::set_tbl_version_attr("latest")
        return(etbl)
      }
      self$.parse_file(x, "summary") |>
        nemo::set_tbl_version_attr("latest")
    },
    #' @description Tidy `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      self$.tidy_file(x, "summary")
    }
  ) # end public
)

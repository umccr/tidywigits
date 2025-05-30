#' @title Virusbreakend Object
#'
#' @description
#' Virusbreakend file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' v <- Virusbreakend$new(path)
#' }
#' @export
Virusbreakend <- R6::R6Class(
  "Virusbreakend",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Virusbreakend object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    initialize = function(
      path = NULL,
      files_tbl = NULL,
      tidy = TRUE,
      keep_raw = FALSE
    ) {
      name <- "virusbreakend"
      super$initialize(name = name, path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self, tidy = tidy, keep_raw = keep_raw)
    },

    #' @description Read `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      schema <- self$.raw_schema("summary")
      # file is either completely empty, or with colnames + data
      hdr <- file_hdr(x)
      if (length(hdr) == 0) {
        ctypes <- paste(schema[["type"]], collapse = "")
        etbl <- empty_tbl(cnames = schema[["field"]], ctypes = ctypes) |>
          set_tbl_version_attr("latest")
        return(etbl)
      }
      self$.parse_file(x, "summary") |>
        set_tbl_version_attr("latest")
    },
    #' @description Tidy `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      self$.tidy_file(x, "summary")
    }
  ) # end public
)

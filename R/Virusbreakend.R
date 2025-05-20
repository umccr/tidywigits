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
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "virusbreakend", path = path)
      self$tidy = super$.tidy(envir = self)
    },

    #' @description Read `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      schema <- self$.raw_schema("summary") |>
        dplyr::mutate(
          type = dplyr::case_match(
            .data$type,
            "char" ~ "c",
            "int" ~ "i",
            "float" ~ "d"
          )
        )
      # file is either completely empty, or with colnames + data
      hdr <- file_hdr(x)
      if (length(hdr) == 0) {
        ctypes <- paste(schema[["type"]], collapse = "")
        etbl <- empty_tbl(cnames = schema[["field"]], ctypes = ctypes)
        attr(etbl, "file_version") <- "latest"
        return(etbl)
      }
      d <- self$.parse_file(x, "summary")
      attr(d, "file_version") <- "latest"
      d
    },
    #' @description Tidy `vcf.summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      self$.tidy_file(x, "summary")
    }
  ) # end public
)

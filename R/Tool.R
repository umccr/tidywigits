#' Tool Class
#'
#' @description
#' Base class for all wigits tools.
#'
#' @param odir Output directory for the tool.
#' @param prefix Prefix for the tool.
Tool <- R6::R6Class(
  "Tool",
  public = list(
    #' @field odir Output directory for the tool.
    #' @field prefix Prefix for the tool.
    odir = NULL,
    prefix = NULL,

    #' @description Create a new Tool object.
    #' @param odir Output directory for the tool.
    #' @param prefix Prefix for the tool.
    initialize = function(odir, prefix) {
      self$odir <- odir
      self$prefix <- prefix
    },
    #' @description Print details about the Tool.
    #' @param ... (ignored).
    print = function(...) {
      # fmt: skip
      res <- tibble::tribble(
        ~var, ~value,
        "odir", self$odir,
        "prefix", self$prefix
      )
      print(res)
      invisible(self)
    }
  )
)

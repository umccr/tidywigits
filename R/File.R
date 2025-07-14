#' @title File Object
#'
#' @description
#' Represents a file output from a workflow.
#' A File has an absolute path and a basename. Given a suffix pattern,
#' it can also have a prefix (e.g. for file `foo.txt` and a `\\.txt` suffix
#' pattern, the prefix will be `foo`).
#'
#' @examples
#' f1 <- File$new(readr::readr_example("mtcars.csv"), "\\.csv")
#' (b <- f1$bname)
#' (sp <- f1$suffix_pattern)
#' (p <- f1$prefix)
#'
#' @testexamples
#' expect_true(inherits(f1, c("File", "R6")))
#' expect_equal(b, "mtcars.csv")
#' expect_equal(p, "mtcars")
#' expect_equal(sp, "\\.csv")
#'
#' @export
File <- R6::R6Class(
  "File",
  public = list(
    #' @field path (`character(1)`)\cr
    #' Absolute path of file.
    path = NULL,
    #' @field bname (`character(1)`)\cr
    #' Basename of file.
    bname = NULL,
    #' @field suffix_pattern (`character(1)`)\cr
    #' Suffix pattern.
    suffix_pattern = NULL,
    #' @field size (`character(1)`)\cr
    #' Size of file.
    size = NULL,
    #' @field prefix (`character(1)`)\cr
    #' Prefix of file.
    prefix = NULL,

    #' @description Create a new File object.
    #' @param path (`character(1)`)\cr
    #' Absolute path of file.
    #' @param suffix_pattern (`character(1)`)\cr
    #' Suffix pattern.
    initialize = function(path = NULL, suffix_pattern = NULL) {
      stopifnot(rlang::is_scalar_atomic(path))
      self$path <- normalizePath(path)
      self$bname <- basename(self$path)
      self$suffix_pattern <- suffix_pattern
      self$size <- fs::file_size(self$path)
      if (!rlang::is_null(suffix_pattern)) {
        self$prefix = sub(glue("(.*){suffix_pattern}"), "\\1", self$bname)
      }
    },

    #' @description Print details about the File.
    #' @param ... (ignored).
    print = function(...) {
      # fmt: skip
      res <- tibble::tribble(
        ~var, ~value,
        "path", self$path,
        "bname", self$bname,
        "suffix_pattern", self$suffix_pattern,
        "prefix", self$prefix,
        "size", as.character(self$size)
      )
      cat(glue("#--- File {self$bname} ---#"))
      print(knitr::kable(res))
      invisible(self)
    }
  )
)

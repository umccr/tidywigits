#' @title Workflow Object
#'
#' @description
#' A Workflow is composed of multiple Tools.
#' @examples
#' \dontrun{
#' path <- here::here("nogit/oa_v1")
#' tools <- list(alignments = Alignments, sigs = Sigs)
#' wf1 <- Workflow$new(name = "foo", path = path, tools = tools)
#' wf1$.list_files()
#' wf1$magic(
#'     odir = "nogit/test_data",
#'     pref = "sampleA",
#'     fmt = "parquet",
#'     id = "run1"
#' )
#' }
#' @export
Workflow <- R6::R6Class(
  "Workflow",
  public = list(
    #' @field name (`character(1)`)\cr
    #' Name of workflow.
    name = NULL,
    #' @field tools (`list(n)`)\cr
    #' List of Tools that compose a Workflow.
    tools = NULL,
    #' @field path (`character(n)`)\cr
    #' Path(s) to workflow results.
    path = NULL,
    #' @field objs (`list(n)`)\cr
    #' List of instantiated Tool objects.
    objs = NULL,
    #' @field tbls (`tibble()`)\cr
    #' Tibble of tidy tibbles.
    tbls = NULL,

    #' @description Create a new Workflow object.
    #' @param name (`character(1)`)\cr
    #' Name of workflow.
    #' @param path (`character(n)`)\cr
    #' Path(s) to workflow results.
    #' @param tools (`list(n)`)\cr
    #' List of Tools that compose a Workflow.
    initialize = function(name, path = NULL, tools = NULL) {
      private$validate_tools(tools)
      self$tools <- tools
      self$path <- normalizePath(path)
      ft <- list_files_dir(self$path)
      # handle everything in a list of Tools
      objs <- tools |>
        purrr::map(\(x) x$new(files_tbl = ft))
      self$objs <- objs
    },
    #' @description Print details about the File.
    #' @param ... (ignored).
    print = function(...) {
      # fmt: skip
      res <- tibble::tribble(
        ~var, ~value,
        "ntools", as.character(length(self$tools))
      )
      cat("#--- Workflow ---#\n")
      print(res)
      invisible(self)
    },
    #' @description Filter files in given workflow directory.
    #' @param include (`character(n)`)\cr
    #' Files to include.
    #' @param exclude (`character(n)`)\cr
    #' Files to exclude.
    .filter_files = function(include = NULL, exclude = NULL) {
      self$objs <- self$objs |>
        purrr::map(\(x) x$.filter_files(include = include, exclude = exclude))
      invisible(self)
    },
    #' @description List files in given workflow directory.
    #' @param type (`character(1)`)\cr
    #' File types(s) to return (e.g. any, file, directory, symlink).
    #' See `fs::dir_info`.
    #' @return A tibble with all files found for each Tool.
    .list_files = function(type = "file") {
      self$objs |>
        purrr::map(\(x) x$.list_files(type = type)) |>
        dplyr::bind_rows()
    },
    #' @description Tidy Workflow files.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    #' @return self invisibly.
    .tidy = function(tidy = TRUE, keep_raw = FALSE) {
      self$objs <- self$objs |>
        purrr::map(\(x) x$.tidy())
      invisible(self)
    },
    #' @description Write tidy tibbles.
    #' @param odir (`character(1)`)\cr
    #' Directory path to output tidy files.
    #' @param pref (`character(1)`)\cr
    #' Prefix of output files.
    #' @param fmt (`character(1)`)\cr
    #' Format of output files.
    #' @param id (`character(1)`)\cr
    #' ID to use for the dataset (e.g. `wfrid.123`, `prid.456`).
    #' @param dbconn (`DBIConnection(1)`)\cr
    #' Database connection object (see `DBI::dbConnect`).
    #' @return A tibble with all tibbles written.
    .write = function(odir = NULL, pref = NULL, fmt = "tsv", id = NULL, dbconn = NULL) {
      self$objs |>
        purrr::map(\(x) x$.write(odir = odir, pref = pref, fmt = fmt, id = id, dbconn = dbconn)) |>
        dplyr::bind_rows()
    },
    #' @description Magic.
    #' @param odir (`character(n)`)\cr
    #' Directory path to output tidy files.
    #' @param pref (`character(n)`)\cr
    #' Prefix of output files.
    #' @param fmt (`character(n)`)\cr
    #' Format of output files.
    #' @param id (`character(n)`)\cr
    #' ID to use for the dataset (e.g. `wfrid.123`, `prid.456`).
    #' @param dbconn (`DBIConnection`)\cr
    #' Database connection object (see `DBI::dbConnect`).
    #' @param include (`character(n)`)\cr
    #' Files to include.
    #' @param exclude (`character(n)`)\cr
    #' Files to exclude.
    magic = function(
      odir = NULL,
      pref = NULL,
      fmt = "tsv",
      id = NULL,
      dbconn = NULL,
      include = NULL,
      exclude = NULL
    ) {
      # fmt: skip
      self$
        .filter_files(include = include, exclude = exclude)$
        .tidy()$
        .write(odir = odir, pref = pref, fmt = fmt, id = id, dbconn = dbconn)
    }
  ), # public end
  private = list(
    validate_tools = function(x) {
      assertthat::assert_that(rlang::is_bare_list(x))
      assertthat::assert_that(all(purrr::map_lgl(x, R6::is.R6Class)))
      tool_nms <- purrr::map_chr(x, "classname") |> tolower()
      assertthat::assert_that(!is.null(tool_nms) && all(tool_nms %in% NEMO_TOOLS))
      assertthat::assert_that(all(purrr::map(x, "inherit") == as.symbol("Tool")))
    }
  ) # private end
)

#' @title Tool Object
#'
#' @description
#' Base class for all wigits tools.
#' @examples
#' \dontrun{
#' name <- "alignments"
#' path <- here::here(
#'   "nogit/oa_v1"
#' )
#' tool <- Tool$new(name = name, path = path)
#' files_tbl <- list_files_dir("nogit/oa_v1")
#' Tool$new(name = "amber", path = "foo", files_tbl = files_tbl)
#' }
#'
#' @export
Tool <- R6::R6Class(
  "Tool",
  public = list(
    #' @field name (`character(1)`)\cr
    #' Name of tool.
    name = NULL,
    #' @field path  (`character(1)`)\cr
    #' Output directory of tool.
    path = NULL,
    #' @field config (`Config()`)\cr
    #' Config of tool.
    config = NULL,
    #' @field files (`tibble()`)\cr
    #' Tibble of files matching available Tool patterns.
    files = NULL,
    #' @field raw_schemas_all (`tibble()`)\cr
    #' All raw schemas for tool.
    raw_schemas_all = NULL,
    #' @field tidy_schemas_all (`tibble()`)\cr
    #' All tidy schemas for tool.
    tidy_schemas_all = NULL,
    #' @field .tidy_schema (`function()`)\cr
    #' Get specific tidy schema.
    .tidy_schema = NULL,
    #' @field .raw_schema (`function()`)\cr
    #' Get specific raw schema.
    .raw_schema = NULL,
    #' @field .files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    .files_tbl = NULL,

    #' @description Create a new Tool object.
    #' @param name (`character(1)`)\cr
    #' Name of tool.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    initialize = function(name, path = NULL, files_tbl = NULL) {
      assertthat::assert_that(!is.null(path) || !is.null(files_tbl))
      if (!is.null(files_tbl)) {
        assertthat::assert_that(is_files_tbl(files_tbl))
        if (!is.null(path)) {
          # gets ignored if files_tbl is specified
          path <- NULL
        }
      }
      self$name <- name
      self$path <- path
      self$config <- Config$new(self$name)
      self$raw_schemas_all <- self$config$raw_schemas_all
      self$tidy_schemas_all <- self$config$tidy_schemas_all
      self$.tidy_schema <- self$config$.tidy_schema
      self$.raw_schema <- self$config$.raw_schema
      self$.files_tbl <- files_tbl
      self$files <- self$list_files()
    },
    #' @description Print details about the Tool.
    #' @param ... (ignored).
    print = function(...) {
      # fmt: skip
      res <- tibble::tribble(
        ~var, ~value,
        "name", self$name,
        "path", self$path %||% "<ignored>",
        "files", as.character(nrow(self$files))
      ) |>
        tidyr::unnest("value")
      cat("#--- Tool ---#\n")
      print(knitr::kable(res))
      invisible(self)
    },
    #' @description List files in given tool directory.
    #' @param type (`character(1)`)\cr
    #' File types(s) to return (e.g. any, file, directory, symlink).
    #' See `fs::dir_info`.
    list_files = function(type = "file") {
      files_tbl <- self$.files_tbl
      assertthat::assert_that(!is.null(self$path) || !is.null(files_tbl))
      if (!is.null(files_tbl)) {
        assertthat::assert_that(is_files_tbl(files_tbl))
      }
      patterns <- self$config$.raw_patterns()
      files <- files_tbl %||% list_files_dir(self$path, type = type)
      res <- files |>
        dplyr::rowwise() |>
        dplyr::mutate(
          matched_name = list(
            patterns |>
              dplyr::filter(stringr::str_detect(bname, .data$value)) |>
              dplyr::select(parser = "name", pattern = "value")
          )
        ) |>
        dplyr::ungroup() |>
        tidyr::unnest("matched_name") |>
        dplyr::select(
          "parser",
          "bname",
          "size",
          "lastmodified",
          "path",
          "pattern"
        )
      if (nrow(res) == 0) {
        return(res)
      }
      res |>
        dplyr::rowwise() |>
        dplyr::mutate(
          FileObj = list(
            File$new(
              path = .data$path,
              suffix_pattern = .data$pattern
            )
          ),
          prefix = FileObj$prefix,
          schema = list(self$config$.raw_schema(.data$parser))
        ) |>
        dplyr::ungroup()
    },
    #' @description Parse file.
    #' @param x (`character(1)`)\cr
    #' File path.
    #' @param name (`character(1)`)\cr
    #' Parser name (e.g. "breakends" - see docs).
    #' @param delim (`character(1)`)\cr
    #' File delimiter.
    #' @param ... Passed on to `readr::read_delim`.
    .parse_file = function(x, name, delim = "\t", ...) {
      parse_file(
        fpath = x,
        pname = name,
        schemas_all = self$raw_schemas_all,
        delim = delim,
        ...
      )
    },
    #' @description Tidy file.
    #' @param x (`character(1)` or `tibble()`)\cr
    #' File path or already parsed raw tibble.
    #' @param name (`character(1)`)\cr
    #' Parser name (e.g. "breakends" - see docs).
    #' @param convert_types (`logical(1)`)\cr
    #' Convert field types based on schema.
    .tidy_file = function(x, name, convert_types = FALSE) {
      if (!tibble::is_tibble(x)) {
        .parser <- self$.eval_func(glue("parse_{name}"))
        x <- .parser(x)
      }
      version <- get_tbl_version_attr(x)
      assertthat::assert_that(!is.null(version), msg = "version can't be NULL.")
      schema <- self$.tidy_schema(name, v = version)
      colnames(x) <- schema[["field"]]
      if (convert_types) {
        ctypes <- schema |>
          dplyr::select("field", "type") |>
          tibble::deframe()
        x <- readr::type_convert(
          x,
          col_types = rlang::exec(readr::cols, !!!ctypes)
        )
      }
      list(x) |>
        setNames(name) |>
        enframe_data()
    },
    #' @description Parse headless file.
    #' @param x (`character(1)`)\cr
    #' File path.
    #' @param pname (`character(1)`)\cr
    #' Parser name (e.g. "breakends" - see docs).
    #' @param delim (`character(1)`)\cr
    #' File delimiter.
    #' @param ... Passed on to `readr::read_delim`.
    .parse_file_nohead = function(x, pname, delim = "\t", ...) {
      schema <- self$raw_schemas_all |>
        dplyr::filter(.data$name == pname) |>
        dplyr::select("version", "schema")
      parse_file_nohead(
        fpath = x,
        schema = schema,
        delim = delim,
        ...
      )
    },
    #' @description Evaluate function in the context of the Tool's
    #' environment.
    #' @param fun (`character(1)`)\cr
    #' Function from Tool to evaluate.
    #' @param envir (`environment()`)\cr
    #' Environment to evaluate the function within.
    .eval_func = function(fun, envir = self) {
      assertthat::assert_that(rlang::is_scalar_character(fun))
      get(fun, envir)
    },
    #' @description Tidy a list of files.
    #' @param envir (`environment()`)\cr
    #' Environment to evaluate the function within.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    .tidy = function(envir = NULL, tidy = TRUE, keep_raw = FALSE) {
      # TODO: see if we can utilise self$.tidy_file
      assertthat::assert_that(!is.null(envir))
      if (nrow(self$files) == 0) {
        return(NULL)
      }
      # if tidy = FALSE and keep_raw = FALSE, just return the file list
      if (!tidy && !keep_raw) {
        return(self$files)
      }
      d <- self$files |>
        dplyr::mutate(
          parse_fun = glue("parse_{parser}"),
          tidy_fun = glue("tidy_{parser}")
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
          raw = list(self$.eval_func(.data$parse_fun, envir)(.data$path)),
          tidy = dplyr::if_else(
            tidy,
            list(self$.eval_func(.data$tidy_fun, envir)(.data$raw)),
            list(NULL)
          )
        ) |>
        dplyr::ungroup() |>
        dplyr::select(-c("parse_fun", "tidy_fun", "FileObj", "schema"))
      if (!keep_raw) {
        d <- d |>
          dplyr::select(-"raw")
      }
      if (!tidy) {
        d <- d |>
          dplyr::select(-"tidy")
      }
      d
    }
  )
)

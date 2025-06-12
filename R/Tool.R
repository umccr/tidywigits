#' @title Tool Object
#'
#' @description
#' Base class for all WiGiTS tools.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit"
#' )
#' a <- Alignments$new(path = path)$
#'   .filter_files(exclude = "alignments_dupfreq")$
#'   .tidy(keep_raw = TRUE)
#' a <- Alignments$new(path)
#' b <- Bamtools$new(path)
#' lx <- Linx$new(path)
#' lx$magic(
#'     odir = "nogit/test_data",
#'     pref = "",
#'     fmt = "parquet",
#'     id = "run2",
#'     include = NULL,
#'     exclude = NULL
#' )
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
    #' @field tbls (`tibble()`)\cr
    #' Tibble of tidy tibbles.
    tbls = NULL,
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
    initialize = function(name = NULL, path = NULL, files_tbl = NULL) {
      assertthat::assert_that(!is.null(path) || !is.null(files_tbl), !is.null(name))
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
      # upon init, files starts off as the raw list of files
      self$files <- self$.list_files(type = "file")
    },
    #' @description Print details about the Tool.
    #' @param ... (ignored).
    #' @return self invisibly.
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
    #' @description Filter files in given tool directory.
    #' @param include (`character(n)`)\cr
    #' Files to include.
    #' @param exclude (`character(n)`)\cr
    #' Files to exclude.
    #' @return The tibble of files with potentially removed rows.
    .filter_files = function(include = NULL, exclude = NULL) {
      f1 <- function(d, include = NULL, exclude = NULL) {
        assertthat::assert_that(
          is.null(include) || is.null(exclude),
          msg = "You cannot define both include and exclude!"
        )
        if (!is.null(include)) {
          assertthat::assert_that(rlang::is_character(include))
          d <- d |>
            dplyr::filter(.data$tool_parser %in% include)
        }
        if (!is.null(exclude)) {
          assertthat::assert_that(rlang::is_character(exclude))
          d <- d |>
            dplyr::filter(!.data$tool_parser %in% exclude)
        }
        d
      }
      self$files <- self$files |>
        f1(include = include, exclude = exclude)
      invisible(self)
    },
    #' @description List files in given tool directory.
    #' @param type (`character(1)`)\cr
    #' File type(s) to return (e.g. any, file, directory, symlink).
    #' See `fs::dir_info`.
    #' @return A tibble of file paths.
    .list_files = function(type = "file") {
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
          # handle wigits version files
          prefix = dplyr::if_else(
            .data$parser == "version" && .data$prefix == "",
            "version",
            .data$prefix
          ),
          schema = list(self$config$.raw_schema(.data$parser)),
          tool_parser = glue("{self$name}_{.data$parser}")
        ) |>
        dplyr::ungroup() |>
        dplyr::mutate(group = dplyr::row_number(), .by = "bname") |>
        dplyr::mutate(
          group = dplyr::if_else(.data$group == 1, glue(""), glue("_{.data$group}")),
          prefix = glue("{.data$prefix}{.data$group}")
        ) |>
        dplyr::relocate("tool_parser", .before = 1)
    },
    #' @description Parse file.
    #' @param x (`character(1)`)\cr
    #' File path.
    #' @param name (`character(1)`)\cr
    #' Parser name (e.g. "breakends" - see docs).
    #' @param delim (`character(1)`)\cr
    #' File delimiter.
    #' @param ... Passed on to `readr::read_delim`.
    #' @return A tibble with the parsed data.
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
    #' @return A tibble with the tidy data enframed.
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
    #' @return A tibble with the parsed data.
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
    #' @return The evaluated function.
    .eval_func = function(fun, envir = self) {
      assertthat::assert_that(rlang::is_scalar_character(fun))
      get(fun, envir)
    },
    #' @description Tidy a list of files.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    #' @return self invisibly.
    .tidy = function(tidy = TRUE, keep_raw = FALSE) {
      if (nrow(self$files) == 0) {
        self$tbls <- NULL
        invisible(self)
      }
      # if both FALSE, just return the file list
      if (!tidy && !keep_raw) {
        self$tbls <- self$files
        invisible(self)
      }
      d <- self$files |>
        dplyr::mutate(
          parse_fun = glue("parse_{parser}"),
          tidy_fun = glue("tidy_{parser}")
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
          raw = list(self$.eval_func(.data$parse_fun)(.data$path)),
          tidy = dplyr::if_else(
            tidy,
            list(self$.eval_func(.data$tidy_fun)(.data$raw)),
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
      self$tbls <- d
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
    #' @param dbconn (`DBIConnection`)\cr
    #' Database connection object (see `DBI::dbConnect`).
    #' @return A tibble with the tidy data and their output location prefix.
    .write = function(odir = NULL, pref = NULL, fmt = "tsv", id = NULL, dbconn = NULL) {
      assertthat::assert_that(!is.null(id), !is.null(pref))
      assertthat::assert_that(
        !is.null(self$tbls),
        nrow(self$tbls) > 0,
        msg = "No tidy tbls found! Did you forget to tidy?"
      )
      if (!is.null(odir)) {
        pref <- file.path(odir, pref)
      }
      d_write <- self$tbls |>
        dplyr::select(
          "tool_parser",
          "parser",
          dplyr::contains("prefix"),
          "tidy"
        ) |>
        tidyr::unite(col = "tbl_prefix", dplyr::contains("prefix"), sep = "_") |>
        tidyr::unnest("tidy", names_sep = "_") |>
        dplyr::mutate(
          tbl_name = ifelse(
            .data$parser == .data$tidy_name,
            as.character(glue("{tbl_prefix}_{.data$tool_parser}")),
            as.character(glue("{tbl_prefix}_{.data$tool_parser}_{.data$tidy_name}"))
          )
        ) |>
        dplyr::rowwise() |>
        dplyr::mutate(
          p = ifelse(
            fmt == "db",
            as.character(.data$tbl_name),
            as.character(glue("{pref}{.data$tbl_name}"))
          ),
          out = list(
            nemo_write(
              d = .data$tidy_data,
              pref = .data$p,
              fmt = fmt,
              id = id,
              dbconn = dbconn
            )
          )
        ) |>
        dplyr::ungroup() |>
        dplyr::rename(prefix = "p")
      invisible(d_write)
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
    #' @return A tibble with the tidy data and their output location prefix.
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
  ) # public end
)

NEMO_TOOLS <- c(
  "alignments",
  "amber",
  "bamtools",
  "chord",
  "cobalt",
  "cuppa",
  "esvee",
  "flagstats",
  "gridss",
  "isofox",
  "lilac",
  "linx",
  "purple",
  "sage",
  "sigs",
  "virusbreakend",
  "virusinterpreter"
)

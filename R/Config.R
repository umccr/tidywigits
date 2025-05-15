#' @title Config Object
#'
#' @description
#' Config YAML file parsing.
#' @examples
#' \dontrun{
#' tool <- "amber"
#' conf <- Config$new(tool)
#' conf$.raw_schemas_valid()
#' conf$.raw_schemas_all()
#' conf$.tidy_descriptions()
#' }
#' @export
Config <- R6::R6Class(
  "Config",
  public = list(
    #' @field tool (`character(1)`)\cr
    #' Tool name.
    tool = NULL,
    #' @field config (`list()`)\cr
    #' Config list.
    config = NULL,
    #' @field raw_schemas_all (`tibble()`)\cr
    #' All raw schemas for tool.
    raw_schemas_all = NULL,
    #' @field tidy_schemas_all (`tibble()`)\cr
    #' All tidy schemas for tool.
    tidy_schemas_all = NULL,

    #' @description Create a new Config object.
    #' @param tool (`character(1)`)\cr
    #' Tool name.
    initialize = function(tool) {
      tool <- tolower(tool)
      valid_tools <- c(
        "alignments",
        "amber",
        "bamtools",
        "chord",
        "cobalt",
        "cuppa",
        "flagstats",
        "gridss",
        "lilac",
        "linx",
        "purple",
        "sage",
        "sigs",
        "virusbreakend",
        "virusinterpreter"
      )
      msg1 <- glue::glue_collapse(valid_tools, sep = ", ", last = " and ")
      msg2 <- glue("'{tool}' is not a valid tool.\nCurrently supported: {msg1}")
      assertthat::assert_that(tool %in% valid_tools, msg = msg2)
      self$tool <- tool
      self$config <- self$.read()
      self$raw_schemas_all <- self$.raw_schemas_all()
      self$tidy_schemas_all <- self$.tidy_schemas_all()
    },
    #' @description Print details about the Tool.
    #' @param ... (ignored).
    print = function(...) {
      cat("#--- Config ---#\n")
      print(self$tool)
      invisible(self)
    },
    #' @description Read YAML configs.
    #' @return A `list()` with the parsed data.
    .read = function() {
      pkg_config_path <- system.file(
        glue("config/tools/{self$tool}"),
        package = "tidywigits"
      )
      raw <- yaml::read_yaml(file.path(pkg_config_path, "raw.yaml"))
      tidy <- yaml::read_yaml(file.path(pkg_config_path, "tidy.yaml"))
      list(raw = raw, tidy = tidy)
    },
    #' @description Return all output file patterns.
    .raw_patterns = function() {
      self$config[["raw"]][["raw"]] |>
        purrr::map("pattern") |>
        tibble::enframe() |>
        tidyr::unnest("value")
    },
    #' @description Return all output file schema versions.
    .raw_versions = function() {
      self$config[["raw"]][["raw"]] |>
        purrr::map(\(file) file[["schema"]] |> names()) |>
        tibble::enframe() |>
        tidyr::unnest("value")
    },
    #' @description Return all output file descriptions.
    .raw_descriptions = function() {
      self$config[["raw"]][["raw"]] |>
        purrr::map("description") |>
        tibble::enframe() |>
        tidyr::unnest("value")
    },
    #' @description Return all output file schemas.
    .raw_schemas_all = function() {
      self$config[["raw"]][["raw"]] |>
        purrr::map(\(rawfile) {
          rawfile[["schema"]] |>
            purrr::map(
              \(s)
                {
                  s |> purrr::map(\(v) tibble::as_tibble_row(v))
                } |>
                  dplyr::bind_rows()
            ) |>
            tibble::enframe(name = "version", value = "schema")
        }) |>
        dplyr::bind_rows(.id = "name")
    },
    #' @description Get raw file schema.
    #' @param x (`character(1)`)\cr
    #' Raw file name.
    #' @param v (`character(1)`)\cr
    #' Version (def: latest).
    .raw_schema = function(x, v = "latest") {
      s <- self$raw_schemas_all
      assertthat::assert_that(
        x %in% s[["name"]],
        msg = glue("{x} not found in schemas for {self$tool}.")
      )
      s |>
        dplyr::filter(.data$name == x, .data$version == v) |>
        dplyr::select("schema") |>
        tidyr::unnest("schema")
    },
    #' @description Validate schema.
    .raw_schemas_valid = function() {
      valid_types <- c("char", "int", "float")
      valid_types_print <- glue::glue_collapse(
        valid_types,
        sep = ", ",
        last = " or "
      )
      s <- self$raw_schemas_all
      invalid <- s |>
        tidyr::unnest("schema") |>
        dplyr::mutate(invalid_type = !.data$type %in% valid_types) |>
        dplyr::filter(invalid_type) |>
        dplyr::mutate(
          warn = glue::glue(
            "{.data$name} -> {.data$version} -> {.data$field} -> {.data$type}"
          )
        )
      if (nrow(invalid) > 0) {
        msg1 <- invalid |>
          dplyr::pull("warn") |>
          glue::glue_collapse(sep = "; ")
        msg2 <- glue(
          "Raw field types need to be one of: {valid_types_print}\n",
          "Check the following in the {self$tool} config:\n{msg1}"
        )
        warning(msg2)
        return(FALSE)
      }
      return(TRUE)
    },
    #' @description Return all tidy tibble descriptions.
    .tidy_descriptions = function() {
      self$config[["tidy"]][["tidy"]] |>
        purrr::map(\(tt) {
          tt[["description"]]
        }) |>
        tibble::enframe() |>
        tidyr::unnest("value")
    },
    #' @description Return all tidy tibble schemas.
    .tidy_schemas_all = function() {
      l1 <- self$config[["tidy"]][["tidy"]]
      l1 |>
        purrr::map(\(tt) {
          tt[["schema"]] |>
            purrr::map(\(v) {
              v |>
                purrr::map(
                  \(y)
                    y |> purrr::map(tibble::as_tibble_row) |> dplyr::bind_rows()
                ) |>
                tibble::enframe(name = "tbl", value = "schema")
            }) |>
            tibble::enframe(name = "version", value = "value2")
        }) |>
        tibble::enframe(name = "name", value = "value1") |>
        tidyr::unnest("value1") |>
        tidyr::unnest("value2")
    },
    #' @description Get tidy tbl schema.
    #' @param x (`character(1)`)\cr
    #' Tidy tbl name.
    .tidy_schema = function(x, v = "latest", tbl = "tbl1") {
      s <- self$tidy_schemas_all
      assertthat::assert_that(
        x %in% s[["name"]],
        msg = glue("{x} not found in schemas for {self$tool}.")
      )
      s |>
        dplyr::filter(.data$name == x, .data$version == v, .data$tbl == tbl) |>
        dplyr::select("schema") |>
        tidyr::unnest("schema")
    }
  ) # end public
)

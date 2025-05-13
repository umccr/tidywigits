#' @title Amber Object
#'
#' @description
#' Amber file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/amber"
#' )
#' a <- Amber$new(path)
#' a$tidy
#' }
#' @export
Amber <- R6::R6Class(
  "Amber",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Amber object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "amber", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `baf.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_bafpcf = function(x) {
      schema <- self$config$.raw_schema("bafpcf")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `baf.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_bafpcf = function(x) {
      raw <- self$parse_bafpcf(x)
      schema <- self$config$.tidy_schema("bafpcf")
      colnames(raw) <- schema[["field"]]
      list(bafpcf = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `baf.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_baftsv = function(x) {
      schema <- self$config$.raw_schema("baftsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `baf.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_baftsv = function(x) {
      raw <- self$parse_baftsv(x)
      schema <- self$config$.tidy_schema("baftsv")
      colnames(raw) <- schema[["field"]]
      list(baftsv = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `contamination.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_contaminationtsv = function(x) {
      schema <- self$config$.raw_schema("contaminationtsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `contamination.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_contaminationtsv = function(x) {
      raw <- self$parse_contaminationtsv(x)
      schema <- self$config$.tidy_schema("contaminationtsv")
      colnames(raw) <- schema[["field"]]
      list(contaminationtsv = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `homozygousregion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_homozygousregion = function(x) {
      schema <- self$config$.raw_schema("homozygousregion")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `homozygousregion.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_homozygousregion = function(x) {
      raw <- self$parse_homozygousregion(x)
      schema <- self$config$.tidy_schema("homozygousregion")
      colnames(raw) <- schema[["field"]]
      list(homozygousregion = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_qc = function(x) {
      schema <- self$config$.raw_schema("qc")
      d <- parse_file(x, schema, type = "txt-nohead", delim = "\t")
      d
    },
    #' @description Tidy `qc` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_qc = function(x) {
      raw <- self$parse_qc(x)
      col_types <- self$config$.tidy_schema("qc") |>
        dplyr::mutate(
          type = dplyr::case_match(
            .data$type,
            "char" ~ "c",
            "int" ~ "i",
            "float" ~ "d"
          )
        ) |>
        dplyr::select("field", "type") |>
        tibble::deframe()

      d <- raw |>
        tidyr::pivot_wider(names_from = "variable", values_from = "value") |>
        purrr::set_names(names(col_types)) |>
        readr::type_convert(col_types = rlang::exec(readr::cols, !!!col_types))
      list(qc = d) |>
        tibble::enframe(value = "data")
    }
  )
)

#' @title Cobalt Object
#'
#' @description
#' Cobalt file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/cobalt"
#' )
#' cob <- Cobalt$new(path)
#' cob$tidy$tidy |>
#'   purrr::set_names(cob$tidy$parser) |>
#'   purrr::map(\(x) str(x[["data"]]))
#' }
#' @export
Cobalt <- R6::R6Class(
  "cobalt",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Cobalt object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "cobalt", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_gcmed = function(x) {
      d1 <- readr::read_tsv(x, col_names = TRUE, col_types = "dd", n_max = 1)
      schema <- self$config$.raw_schema("gcmed")
      d2 <- parse_file(x, schema, type = "tsv", skip = 2)
      list(sample_stats = d1[], bucket_stats = d2)
    },
    #' @description Tidy `gc.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_gcmed = function(x) {
      raw <- self$parse_gcmed(x)
      assertthat::assert_that(all(
        names(raw) == c("sample_stats", "bucket_stats")
      ))
      schema <- self$config$.tidy_schema("gcmed")
      colnames(raw[["bucket_stats"]]) <- schema[["field"]]
      colnames(raw[["sample_stats"]]) <- c("mean", "median")
      # TODO: what on earth is going on here?
      raw[["sample_stats"]] <- raw[["sample_stats"]]
      tibble::enframe(raw, value = "data")
    },
    #' @description Read `ratio.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_ratiomed = function(x) {
      schema <- self$config$.raw_schema("ratiomed")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `ratio.median.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_ratiomed = function(x) {
      raw <- self$parse_ratiomed(x)
      schema <- self$config$.tidy_schema("ratiomed")
      colnames(raw) <- schema[["field"]]
      list(ratiomed = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `ratio.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_ratiotsv = function(x) {
      schema <- self$config$.raw_schema("ratiotsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `ratio.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_ratiotsv = function(x) {
      raw <- self$parse_ratiotsv(x)
      schema <- self$config$.tidy_schema("ratiotsv")
      colnames(raw) <- schema[["field"]]
      list(ratiotsv = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `ratio.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_ratiopcf = function(x) {
      schema <- self$config$.raw_schema("ratiopcf")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `ratio.pcf` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_ratiopcf = function(x) {
      raw <- self$parse_ratiopcf(x)
      schema <- self$config$.tidy_schema("ratiopcf")
      colnames(raw) <- schema[["field"]]
      list(ratiopcf = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `cobalt.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_version = function(x) {
      schema <- self$config$.raw_schema("version")
      d <- parse_file(x, schema, type = "txt-nohead", delim = "=")
      d
    },
    #' @description Tidy `cobalt.version` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_version = function(x) {
      raw <- self$parse_version(x)
      col_types <- self$config$.tidy_schema("version") |>
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
      list(version = d) |>
        tibble::enframe(value = "data")
    }
  ) # end public
)

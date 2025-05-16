#' @title Bamtools Object
#'
#' @description
#' Bamtools file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/bamtools"
#' )
#' path <- here::here("nogit/oa_2.0.0_colo829_20250507/bamtools")
#' b <- Bamtools$new(path)
#' b$tidy$tidy
#' }
#' @export
Bamtools <- R6::R6Class(
  "Bamtools",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Bamtools object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "bamtools", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      schema <- self$config$.raw_schema("summary")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      d <- self$parse_summary(x)
      schema1 <- self$config$.tidy_schema("summary", subtbl = "tbl1")
      schema2 <- self$config$.tidy_schema("summary", subtbl = "tbl2")
      d1 <- d |>
        dplyr::select(!dplyr::contains("DepthCoverage_"))
      assertthat::assert_that(ncol(d1) == nrow(schema1))
      colnames(d1) <- schema1[["field"]]
      d2 <- d |>
        dplyr::select(dplyr::contains("DepthCoverage_")) |>
        tidyr::pivot_longer(
          dplyr::everything(),
          names_to = "covdp",
          values_to = "value"
        ) |>
        tidyr::separate_wider_delim(
          "covdp",
          delim = "_",
          names = c("dummy", "covx")
        ) |>
        dplyr::mutate(covx = as.numeric(.data$covx)) |>
        dplyr::select(covx, value)
      assertthat::assert_that(all(colnames(d2) == schema2[["field"]]))
      list(summary = d1, covx = d2) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_wgsmetrics = function(x) {
      # handle two different sections
      schema <- self$config$.raw_schema("wgsmetrics")
      # first make sure colnames are as expected
      hdr1 <- readr::read_tsv(
        file = x,
        col_types = readr::cols(.default = "c"),
        comment = "#",
        n_max = 0
      )
      assertthat::assert_that(all(colnames(hdr1) == schema[["field"]]))
      hdr2 <- readr::read_tsv(
        file = x,
        col_types = readr::cols(.default = "c"),
        comment = "#",
        skip = 3,
        n_max = 0
      )
      assertthat::assert_that(all(
        colnames(hdr2) == c("coverage", "high_quality_coverage_count")
      ))
      # now parse with proper classes
      d1 <- parse_file(
        x,
        schema = schema,
        type = "tsv",
        comment = "#",
        n_max = 1
      )
      d2 <- readr::read_tsv(x, col_types = "ci", comment = "#", skip = 3)
      list(metrics = d1[], histo = d2[])
    },
    #' @description Tidy `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_wgsmetrics = function(x) {
      raw <- self$parse_wgsmetrics(x)
      schema <- self$config$.tidy_schema("wgsmetrics")
      d <- list(
        wgsmetrics_metrics = raw[["metrics"]],
        wgsmetrics_histo = raw[["histo"]]
      )
      colnames(d[["wgsmetrics_metrics"]]) <- schema[["field"]]
      tibble::enframe(d, value = "data")
    },

    #' @description Read `flag_counts.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_flagstats = function(x) {
      # this is a tricky one, need to grab the pct from within the parens
      pct_cols <- c("mapped", "primary mapped", "properly paired", "singletons")
      d0 <- readr::read_lines(x) |>
        tibble::as_tibble_col(column_name = "value") |>
        tidyr::separate_wider_delim(
          cols = "value",
          delim = " + ",
          names = c("passed", "failed"),
          too_many = "merge"
        ) |>
        dplyr::mutate(
          failed_value = sub("(\\d+) (.*)", "\\1", .data$failed),
          metric = sub("(\\d+) (.*)", "\\2", .data$failed),
          metric2 = sub("(.*) (\\(.* : .*\\))", "\\1", .data$metric),
          is_pct = metric2 %in% pct_cols,
          pct = ifelse(
            is_pct,
            sub("(.*) (\\(.* : .*\\))", "\\2", .data$metric),
            ""
          ),
          pct_passed = sub("\\((.*) : (.*)\\)", "\\1", .data$pct),
          pct_failed = sub("\\((.*) : (.*)\\)", "\\2", .data$pct)
        )
      # name cleanup
      d <- d0 |>
        dplyr::mutate(
          metric_clean = dplyr::case_match(
            .data$metric2,
            "in total (QC-passed reads + QC-failed reads)" ~ "total",
            "supplementary" ~ "suppl",
            "duplicates" ~ "dup",
            "primary duplicates" ~ "primary_dup",
            "properly paired" ~ "proper_pair",
            "primary mapped" ~ "primary_map",
            "paired in sequencing" ~ "paired_in_seq",
            "with itself and mate mapped" ~ "both_map",
            "with mate mapped to a different chr" ~ "matemap_diff",
            "with mate mapped to a different chr (mapQ>=5)" ~
              "matemap_diff_mapq5",
            .default = .data$metric2
          )
        )
      # deal with counts first
      d1 <- d |>
        dplyr::select("passed", "failed_value", "metric_clean") |>
        dplyr::mutate(
          passed = as.numeric(.data$passed),
          failed_value = as.numeric(.data$failed_value)
        ) |>
        dplyr::rename(
          failed = "failed_value",
          metric = "metric_clean"
        ) |>
        tidyr::pivot_longer(
          c("passed", "failed"),
          names_to = "passed_or_failed"
        )
      # now deal with pct
      d2 <- d |>
        dplyr::filter(metric2 %in% pct_cols) |>
        dplyr::select("metric_clean", "pct_passed", "pct_failed") |>
        dplyr::rename(
          passed = "pct_passed",
          failed = "pct_failed",
          metric = "metric_clean"
        ) |>
        tidyr::pivot_longer(
          c("passed", "failed"),
          names_to = "passed_or_failed",
          values_to = "value"
        ) |>
        dplyr::mutate(
          value = sub("%", "", .data$value),
          value = sub("N/A", NA, .data$value),
          value = as.numeric(.data$value),
          metric = paste0(.data$metric, "_pct")
        )
      # all together now, chuck pct at the end
      d_all <- dplyr::bind_rows(d1, d2) |>
        tidyr::pivot_wider(names_from = "metric", values_from = "value")
      return(d_all[])
    },
    #' @description Tidy `flag_counts.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_flagstats = function(x) {
      raw <- self$parse_flagstats(x)
      schema <- self$config$.tidy_schema("flagstats")
      assertthat::assert_that(all(colnames(raw) == schema[["field"]]))
      list(flagstats = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_coverage = function(x) {
      schema <- self$config$.raw_schema("coverage")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_coverage = function(x) {
      raw <- self$parse_coverage(x)
      schema <- self$config$.tidy_schema("coverage")
      colnames(raw) <- schema[["field"]]
      list(coverage = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `frag_length.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_fraglength = function(x) {
      schema <- self$config$.raw_schema("fraglength")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `frag_length.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_fraglength = function(x) {
      raw <- self$parse_fraglength(x)
      schema <- self$config$.tidy_schema("fraglength")
      colnames(raw) <- schema[["field"]]
      list(fraglength = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `partition_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_partitionstats = function(x) {
      schema <- self$config$.raw_schema("partitionstats")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `partition_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_partitionstats = function(x) {
      raw <- self$parse_partitionstats(x)
      schema <- self$config$.tidy_schema("partitionstats")
      colnames(raw) <- schema[["field"]]
      list(partitionstats = raw) |>
        tibble::enframe(value = "data")
    }
  )
)

#' @title Bamtools Object
#'
#' @description
#' Bamtools file parsing and manipulation.
#' @examples
#' cls <- Bamtools
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "bamtools_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "bamtools.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 2)
#' @export
Bamtools <- R6::R6Class(
  "Bamtools",
  inherit = Tool,
  public = list(
    #' @description Create a new Bamtools object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "bamtools", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_summary = function(x) {
      self$.parse_file(x, "summary")
    },
    #' @description Tidy `summary.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_summary = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_summary(x)
      }
      d <- x
      schema1 <- self$get_tidy_schema("summary", subtbl = "tbl1")
      schema2 <- self$get_tidy_schema("summary", subtbl = "tbl2")
      d1 <- d |>
        dplyr::select(!dplyr::contains("DepthCoverage_"))
      assertthat::assert_that(ncol(d1) == nrow(schema1))
      colnames(d1) <- schema1[["field"]]
      d2 <- d |>
        dplyr::select(dplyr::contains("DepthCoverage_")) |>
        tidyr::pivot_longer(
          dplyr::everything(),
          names_to = "covdp",
          values_to = "value",
          names_prefix = "DepthCoverage_"
        ) |>
        dplyr::mutate(covx = as.numeric(.data$covdp)) |>
        dplyr::select("covx", "value")
      assertthat::assert_that(identical(colnames(d2), schema2[["field"]]))
      list(summary = d1, covx = d2) |>
        nemo::enframe_data()
    },
    #' @description Read `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_wgsmetrics = function(x) {
      # handle two different sections
      schema <- self$get_raw_schema("wgsmetrics")
      # first make sure colnames are as expected
      hdr1 <- nemo::file_hdr(x, comment = "#")
      assertthat::assert_that(identical(hdr1, schema[["field"]]))
      hdr2 <- nemo::file_hdr(x, comment = "#", skip = 3)
      assertthat::assert_that(
        identical(hdr2, c("coverage", "high_quality_coverage_count"))
      )
      # now parse with proper classes
      d1 <- self$.parse_file(
        x = x,
        name = "wgsmetrics",
        n_max = 1,
        comment = "#"
      )
      d2 <- readr::read_tsv(x, col_types = "ci", comment = "#", skip = 3) |>
        nemo::set_tbl_version_attr(nemo::get_tbl_version_attr(d1))
      list(metrics = d1[], histo = d2[]) |>
        nemo::enframe_data()
    },
    #' @description Tidy `wgsmetrics` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_wgsmetrics = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_wgsmetrics(x)
      }
      d <- x |> tibble::deframe()
      schema <- self$get_tidy_schema("wgsmetrics")
      colnames(d[["metrics"]]) <- schema[["field"]]
      nemo::enframe_data(d)
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
            "with mate mapped to a different chr (mapQ>=5)" ~ "matemap_diff_mapq5",
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
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_flagstats(x)
      }
      d <- x
      schema <- self$get_tidy_schema("flagstats")
      assertthat::assert_that(identical(colnames(d), schema[["field"]]))
      list(flagstats = d) |>
        nemo::enframe_data()
    },
    #' @description Read `coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_coverage = function(x) {
      self$.parse_file(x, "coverage")
    },
    #' @description Tidy `coverage.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_coverage = function(x) {
      self$.tidy_file(x, "coverage")
    },
    #' @description Read `frag_length.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_fraglength = function(x) {
      self$.parse_file(x, "fraglength")
    },
    #' @description Tidy `frag_length.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_fraglength = function(x) {
      self$.tidy_file(x, "fraglength")
    },
    #' @description Read `partition_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_partitionstats = function(x) {
      self$.parse_file(x, "partitionstats")
    },
    #' @description Tidy `partition_stats.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_partitionstats = function(x) {
      self$.tidy_file(x, "partitionstats")
    }
  )
)

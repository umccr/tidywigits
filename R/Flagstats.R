#' @title Flagstats Object
#'
#' @description
#' Flagstats file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oa_v1/flagstats"
#' )
#' f <- Flagstats$new(path)
#' }
#' @export
Flagstats <- R6::R6Class(
  "Flagstats",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Flagstats object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from `list_files_dir`.
    #' @param tidy (`logical(1)`)\cr
    #' Should the raw parsed tibbles get tidied?
    #' @param keep_raw (`logical(1)`)\cr
    #' Should the raw parsed tibbles be kept in the final output?
    initialize = function(
      path = NULL,
      files_tbl = NULL,
      tidy = TRUE,
      keep_raw = FALSE
    ) {
      super$initialize(name = "flagstats", path = path, files_tbl = files_tbl)
      self$tidy = super$.tidy(envir = self, tidy = tidy, keep_raw = keep_raw)
    },
    #' @description Read `flagstat` file.
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
    #' @description Tidy `flagstat` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_flagstats = function(x) {
      # tidying already done, just check colnames
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_flagstats(x)
      }
      d <- x
      schema <- self$.tidy_schema("flagstats")
      assertthat::assert_that(identical(colnames(d), schema[["field"]]))
      list(flagstats = d) |>
        enframe_data()
    }
  )
)

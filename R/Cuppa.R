#' @title Cuppa Object
#'
#' @description
#' Cuppa file parsing and manipulation.
#' @examples
#' cls <- Cuppa
#' indir <- system.file("extdata/oa", package = "tidywigits")
#' odir <- tempdir()
#' id <- "cuppa_run1"
#' obj <- cls$new(indir)
#' obj$nemofy(odir = odir, format = "parquet", id = id)
#' (lf <- list.files(odir, pattern = "cuppa.*parquet", full.names = FALSE))
#' @testexamples
#' expect_equal(length(lf), 3)
#' @export
Cuppa <- R6::R6Class(
  "Cuppa",
  inherit = Tool,
  public = list(
    #' @description Create a new Cuppa object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool. If `files_tbl` is supplied, this basically gets
    #' ignored.
    #' @param files_tbl (`tibble(n)`)\cr
    #' Tibble of files from [nemo::list_files_dir()].
    initialize = function(path = NULL, files_tbl = NULL) {
      super$initialize(name = "cuppa", pkg = pkg_name, path = path, files_tbl = files_tbl)
    },
    #' @description Read `cup.data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_datacsv = function(x) {
      self$.parse_file(x, "datacsv", delim = ",")
    },
    #' @description Tidy `cup.data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_datacsv = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_predsum(x)
      }
      # add a 'plot_section' column for potential easier grouping
      d <- x |>
        dplyr::mutate(
          plot_section = dplyr::case_when(
            (.data$ResultType == "CLASSIFIER" & .data$DataType != "GENDER") |
              (.data$ResultType == "PREVALENCE" & .data$DataType == "GENDER") ~
              "classifier",
            (.data$ResultType == "PERCENTILE" & .data$Category == "SNV") ~ "sigs",
            (.data$ResultType == "PERCENTILE" & .data$Category != "SNV") ~ "percentiles",
            (.data$Category == "FEATURE" & .data$ResultType == "PREVALENCE") ~ "features",
            .default = "other"
          )
        )
      schema <- self$get_tidy_schema("datacsv")
      colnames(d) <- schema[["field"]]
      list(datacsv = d) |>
        nemo::enframe_data()
    },
    #' @description Read `cuppa_data.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_feat = function(x) {
      self$.parse_file(x, "feat")
    },
    #' @description Tidy `cuppa_data.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_feat = function(x) {
      self$.tidy_file(x, "feat")
    },
    #' @description Read `cuppa.pred_summ.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_predsum = function(x) {
      self$.parse_file(x, "predsum")
    },
    #' @description Tidy `cuppa.pred_summ.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_predsum = function(x) {
      # hack to handle raw tibble input since other funcs use .tidy_file
      if (!tibble::is_tibble(x)) {
        x <- self$parse_predsum(x)
      }
      d <- x |>
        tidyr::pivot_longer(
          dplyr::contains("pred_class_"),
          names_prefix = "pred_class_",
          names_to = "pred_class_rank",
          values_to = "pred_class",
          names_transform = list(pred_class_rank = as.integer)
        ) |>
        tidyr::pivot_longer(
          dplyr::contains("pred_prob_"),
          names_prefix = "pred_prob_",
          names_to = "pred_prob_rank",
          values_to = "pred_prob",
          names_transform = list(pred_prob_rank = as.integer)
        ) |>
        dplyr::relocate("extra_info", .after = dplyr::last_col()) |>
        dplyr::relocate("extra_info_format", .after = dplyr::last_col())
      schema <- self$get_tidy_schema("predsum")
      assertthat::assert_that(identical(colnames(d), schema[["field"]]))
      list(predsum = d) |>
        nemo::enframe_data()
    },
    #' @description Read `cuppa.vis_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_datatsv = function(x) {
      self$.parse_file(x, "datatsv")
    },
    #' @description Tidy `cuppa.vis_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_datatsv = function(x) {
      self$.tidy_file(x, "datatsv")
    }
  ) # end public
)

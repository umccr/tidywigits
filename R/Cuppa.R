#' @title Cuppa Object
#'
#' @description
#' Cuppa file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oa_v2/cuppa"
#' )
#' cup <- Cuppa$new(path)
#' }
#' @export
Cuppa <- R6::R6Class(
  "Cuppa",
  inherit = Tool,
  public = list(
    #' @field tidy (`tibble()`)\cr
    #' Tidy tibble.
    tidy = NULL,
    #' @description Create a new Cuppa object.
    #' @param path (`character(1)`)\cr
    #' Output directory of tool.
    initialize = function(path) {
      super$initialize(name = "cuppa", path = path)
      self$tidy = super$.tidy(envir = self)
    },
    #' @description Read `cup.data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_datacsv = function(x) {
      schema <- self$config$.raw_schema("datacsv")
      d <- parse_file(x, schema, type = "csv")
    },
    #' @description Tidy `cup.data.csv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_datacsv = function(x) {
      raw <- self$parse_datacsv(x)
      # add a 'plot_section' column for potential easier grouping
      d <- raw |>
        dplyr::mutate(
          plot_section = dplyr::case_when(
            (.data$ResultType == "CLASSIFIER" & .data$DataType != "GENDER") |
              (.data$ResultType == "PREVALENCE" & .data$DataType == "GENDER") ~
              "classifier",
            (.data$ResultType == "PERCENTILE" & .data$Category == "SNV") ~
              "sigs",
            (.data$ResultType == "PERCENTILE" & .data$Category != "SNV") ~
              "percentiles",
            (.data$Category == "FEATURE" & .data$ResultType == "PREVALENCE") ~
              "features",
            .default = "other"
          )
        )
      # clean up cancer types
      d <- d |>
        dplyr::mutate(
          RefCancerType = dplyr::case_match(
            .data$RefCancerType,
            "Acute myeloid leukemia" ~ "acute_myeloid_leukemia",
            "Anogenital" ~ "anogenital",
            "Bile duct/Gallbladder" ~ "bile_duct_gallbladder",
            "Bone/Soft tissue: Other" ~ "bone_soft_tissue_other",
            "Breast" ~ "breast",
            "Cartilaginous neoplasm" ~ "cartilaginous_neoplasm",
            "Colorectum/Appendix/SmallIntestine" ~
              "colorectum_appendix_small_intestine",
            "Esophagus/Stomach" ~ "esophagus_stomach",
            "GIST" ~ "gist",
            "Glioma" ~ "glioma",
            "Head and neck: other" ~ "head_and_neck_other",
            "Kidney" ~ "kidney",
            "Kidney-ChRCC" ~ "kidney_chrcc",
            "Leiomyosarcoma" ~ "leiomyosarcoma",
            "Liposarcoma" ~ "liposarcoma",
            "Liver" ~ "liver",
            "Lung: NET" ~ "lung_net",
            "Lung: Non-small Cell" ~ "lung_nonsmallcell",
            "Lung: Small Cell" ~ "lung_smallcell",
            "Lymphoid tissue" ~ "lymphoid_tissue",
            "Medulloblastoma" ~ "medulloblastoma",
            "Melanoma" ~ "melanoma",
            "Mesothelium" ~ "mesothelium",
            "Myeloproliferative neoplasm" ~ "myeloproliferative_neoplasm",
            "Osteosarcoma" ~ "osteosarcoma",
            "Ovary/Fallopian tube" ~ "ovary_fallopian_tube",
            "Pancreas" ~ "pancreas",
            "Pancreas: NET" ~ "pancreas_net",
            "Pilocytic astrocytoma" ~ "pilocytic_astrocytoma",
            "Prostate" ~ "prostate",
            "Salivary gland/Adenoid cystic" ~ "salivary_gland_adenoid_cystic",
            "Skin: Other" ~ "skin_other",
            "Small intestine/Colorectum: NET" ~
              "small_intestine_colorectum_net",
            "Thyroid gland" ~ "thyroid_gland",
            "Urothelial tract" ~ "urothelial_tract",
            "Uterus: Endometrium" ~ "uterus_endometrium"
          )
        )
      schema <- self$config$.tidy_schema("datacsv")
      colnames(d) <- schema[["field"]]
      list(datacsv = d) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `cuppa_data.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_feat = function(x) {
      schema <- self$config$.raw_schema("feat")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `cuppa_data.tsv.gz` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_feat = function(x) {
      raw <- self$parse_feat(x)
      schema <- self$config$.tidy_schema("feat")
      colnames(raw) <- schema[["field"]]
      list(feat = raw) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `cuppa.pred_summ.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_predsum = function(x) {
      schema <- self$config$.raw_schema("predsum")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `cuppa.pred_summ.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_predsum = function(x) {
      d <- self$parse_predsum(x) |>
        tidyr::pivot_longer(
          contains("pred_class_"),
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
      schema <- self$config$.tidy_schema("predsum")
      assertthat::assert_that(all(colnames(d) == schema[["field"]]))
      list(predsum = d) |>
        tibble::enframe(value = "data")
    },
    #' @description Read `cuppa.vis_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    parse_datatsv = function(x) {
      schema <- self$config$.raw_schema("datatsv")
      d <- parse_file(x, schema, type = "tsv")
      d
    },
    #' @description Tidy `cuppa.vis_data.tsv` file.
    #' @param x (`character(1)`)\cr
    #' Path to file.
    tidy_datatsv = function(x) {
      raw <- self$parse_datatsv(x)
      schema <- self$config$.tidy_schema("datatsv")
      colnames(raw) <- schema[["field"]]
      list(datatsv = raw) |>
        tibble::enframe(value = "data")
    }
  ) # end public
)

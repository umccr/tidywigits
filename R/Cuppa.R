#' @title Cuppa Object
#'
#' @description
#' Cuppa file parsing and manipulation.
#' @examples
#' \dontrun{
#' path <- here::here(
#'   "nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/cuppa"
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
    }
  ) # end public
)

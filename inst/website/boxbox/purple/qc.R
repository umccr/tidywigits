#' @export
gt_tab_prep <- function(d, schemas_all) {
  box::use(./qc[get_fill_colour])
  stopifnot(all(c("res", "schema") %in% names(d)))
  cols_sel <- c(
    "qc_status",
    "gender",
    "purity",
    "contamination",
    "tinc_level",
    "loh_percent",
    "chimerism_percent",
    "method",
    "germline_aberrations",
    "deleted_genes",
    "cn_segments",
    "cn_segments_unsupported",
    "foobar"
  )
  d1 <- d$res |>
    dplyr::mutate(
      gender = dplyr::if_else(
        .data$gender_amber == .data$gender_cobalt,
        .data$gender_amber,
        paste(.data$gender_amber, .data$gender_cobalt, sep = "/")
      )
    ) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) |>
    dplyr::select(-c("gender_amber", "gender_cobalt")) |>
    dplyr::select(
      dplyr::any_of(cols_sel),
      dplyr::everything()
    ) |>
    tidyr::pivot_longer(dplyr::everything(), names_to = "field") |>
    dplyr::mutate(fill_colour = purrr::map2_chr(field, value, get_fill_colour))
  descriptions <- d$schema$schema |>
    dplyr::bind_rows(
      tibble::tibble(
        field = "gender",
        type = "c",
        description = "gender according to AMBER/COBALT"
      )
    )
  thresh <- tibble::tribble(
        ~field, ~threshold,
        "qc_status", "Green: PASS; Orange: WARN; Red: FAIL",
        "method", "Green: NORMAL; Orange: HIGHLY_DIPLOID or SOMATIC; Red: NO_TUMOR",
        "cn_segments", "No colour thresholds",
        "cn_segments_unsupported", "Green: 0; Orange: 1-10; Red: >10",
        "purity", "Green: >0.8; Orange: 0.4-0.8; Red: <0.4",
        "gender", "Green: matching values; Red: mismatched values",
        "deleted_genes", "Green: 0-99; Orange: 100-199; Red: >=200",
        "contamination", "Green: 0; Red: >0",
        "germline_aberrations", "Green: NONE; Red: any aberration detected",
        "mean_depth_amber", "Green: 25-150; Orange: >150; Red: 0-25",
        "loh_percent", "Green: 0-0.5; Orange: 0.5-0.8; Red: >0.8",
        "tinc_level", "Green: 0; Red: >0",
        "chimerism_percent", "Green: 0; Red: >0"
      )
  d1 |>
    dplyr::left_join(descriptions, by = "field") |>
    dplyr::select("field", "value", "fill_colour", "description") |>
    dplyr::left_join(thresh, by = "field") |>
    tidyr::unite("description", c("description", "threshold"), sep = "\n")
}

#' @export
gt_tab <- function(d, schemas_all) {
  box::use(../wigits/table[gt_tab], ./qc[gt_tab_prep])
  gt_tab_prep(d, schemas_all) |>
    gt_tab("purple_qc")
}

#' @export
get_fill_colour <- function(field, value) {
  green <- "#90EE90"
  orange <- "#FFA500"
  red <- "#FF6B6B"

  # Convert to numeric where needed
  num_val <- suppressWarnings(as.numeric(value))

  colour <- dplyr::case_when(
    field == "qc_status" & value == "PASS" ~ green,
    field == "qc_status" & grepl("WARN", value) ~ orange,
    field == "qc_status" ~ red,

    field == "method" & value == "NORMAL" ~ green,
    field == "method" & value %in% c("HIGHLY_DIPLOID", "SOMATIC") ~ orange,
    field == "method" ~ red,

    field == "cn_segments_unsupported" & num_val == 0 ~ green,
    field == "cn_segments_unsupported" & num_val > 0 & num_val <= 10 ~ orange,
    field == "cn_segments_unsupported" ~ red,

    field == "cn_segments" & num_val > 0 ~ green,
    field == "cn_segments" ~ red,

    field == "purity" & num_val >= 0.80 ~ green,
    field == "purity" & num_val >= 0.40 ~ orange,
    field == "purity" ~ red,

    # consolidated gender field
    field == "gender" & !grepl("/", value) ~ green,
    field == "gender" & grepl("/", value) ~ red,

    field == "deleted_genes" & num_val < 100 ~ green,
    field == "deleted_genes" & num_val < 200 ~ orange,
    field == "deleted_genes" ~ red,

    field == "contamination" & num_val == 0 ~ green,
    field == "contamination" ~ red,

    field == "germline_aberrations" & value == "NONE" ~ green,
    field == "germline_aberrations" ~ red,

    field == "mean_depth_amber" & num_val >= 25 & num_val <= 150 ~ green,
    field == "mean_depth_amber" & num_val > 150 ~ orange,
    field == "mean_depth_amber" ~ red,

    field == "loh_percent" & num_val <= 0.5 ~ green,
    field == "loh_percent" & num_val <= 0.8 ~ orange,
    field == "loh_percent" ~ red,

    field == "tinc_level" & num_val == 0 ~ green,
    field == "tinc_level" ~ red,

    field == "chimerism_percent" & num_val == 0 ~ green,
    field == "chimerism_percent" ~ red,

    .default = "white"
  )
  return(colour)
}

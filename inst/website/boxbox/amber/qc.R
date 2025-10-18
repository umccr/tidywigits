#' @export
gt_tab_prep <- function(d, schemas_all) {
  box::use(./qc[get_fill_colour])
  stopifnot(all(c("res", "schema") %in% names(d)))
  cols_sel <- c(
    "qc_status",
    "contamination",
    "consanguinity",
    "uniparental_disomy"
  )
  d1 <- d$res |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) |>
    dplyr::select(
      dplyr::any_of(cols_sel),
      dplyr::everything()
    ) |>
    tidyr::pivot_longer(dplyr::everything(), names_to = "field") |>
    dplyr::mutate(fill_colour = purrr::map2_chr(field, value, get_fill_colour))
  descriptions <- d$schema$schema
  thresh <- tibble::tribble(
        ~field, ~threshold,
        "qc_status", "Green: PASS; Orange: WARN; Red: FAIL",
        "contamination", "Green: 0; Red: >0",
        "consanguinity", "Green: 0; Orange: <=0.005; Red: >0.005",
        "uniparental_disomy", "Green: NONE; Red: Other"
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
    gt_tab("amber_qc")
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

    field == "contamination" & num_val == 0 ~ green,
    field == "contamination" ~ red,

    field == "uniparental_disomy" & value == "NONE" ~ green,
    field == "uniparental_disomy" ~ red,

    field == "consanguinity" & num_val == 0 ~ green,
    field == "consanguinity" & num_val <= 0.005 ~ orange,
    field == "consanguinity" ~ red,

    .default = "white"
  )
  return(colour)
}

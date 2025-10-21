#' @export
gt_tab_prep <- function(d, schemas_all) {
  box::use(./qc[get_fill_colour])
  stopifnot(all(c("res", "schema") %in% names(d)))
  cols_sel <- c(
    "status",
    "score_margin",
    "next_solution_alleles",
    "median_base_quality",
    "hla_y_allele",
    "discarded_indels",
    "discarded_indel_max_frags",
    "discarded_alignment_fragments",
    "a_low_coverage_bases",
    "b_low_coverage_bases",
    "c_low_coverage_bases",
    "a_types",
    "b_types",
    "c_types",
    "total_fragments",
    "fitted_fragments",
    "unmatched_fragments",
    "uninformative_fragments",
    "hla_y_fragments",
    "percent_unique",
    "percent_shared",
    "percent_wildcard",
    "unused_amino_acids",
    "unused_amino_acid_max_frags",
    "unused_haplotypes",
    "unused_haplotype_max_frags",
    "somatic_variants_matched",
    "somatic_variants_unmatched"
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
        "qc_status", "Green: PASS; Orange: WARN; Red: FAIL"
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
    gt_tab("lilac_qc")
}

#' @export
get_fill_colour <- function(field, value) {
  green <- "#90EE90"
  orange <- "#FFA500"
  red <- "#FF6B6B"

  # Convert to numeric where needed
  num_val <- suppressWarnings(as.numeric(value))

  colour <- dplyr::case_when(
    field == "status" & value == "PASS" ~ green,
    field == "status" & grepl("WARN", value) ~ orange,
    field == "status" ~ red,
    .default = "white"
  )
  return(colour)
}

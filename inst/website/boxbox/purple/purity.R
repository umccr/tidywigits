#' @export
gt_tab_prep <- function(d, schemas_all) {
  box::use(./purity[get_fill_colour])
  stopifnot(all(c("res", "schema") %in% names(d)))
  x1 <- list(
    select = c(
      "purity_str",
      "ploidy_str",
      "gender",
      "tmb_str",
      "ms_str",
      "tml_str",
      "diploid_proportion_str",
      "polyclonal_proportion",
      "whole_genome_duplication",
      "tmb_sv",
      "status",
      "run_mode",
      "targeted",
      "fit_score",
      "norm_factor",
      "somatic_penalty"
    ),
    remove = c(
      paste0(
        rep(c("purity", "ploidy", "diploid_proportion"), each = 3),
        c("", "_min", "_max")
      ),
      "tmb_per_mb",
      "tmb_status",
      "ms_status",
      "ms_indels_per_mb",
      "tml_status",
      "tml"
    )
  )
  d0 <- d$res |>
    dplyr::mutate(dplyr::across(
      dplyr::starts_with(
        c(
          "purity",
          "ploidy",
          "diploid_proportion",
          "polyclonal_proportion",
          "tmb_per_mb",
          "ms_indels_per_mb"
        )
      ),
      \(x) round(x, 2)
    )) |>
    dplyr::mutate(
      purity_str = glue::glue("{purity} ({purity_min}-{purity_max})"),
      ploidy_str = glue::glue("{ploidy} ({ploidy_min}-{ploidy_max})"),
      diploid_proportion_str = glue::glue(
        "{diploid_proportion} ({diploid_proportion_min}-{diploid_proportion_max})"
      ),
      tmb_str = glue::glue("{tmb_per_mb} ({tmb_status})"),
      tml_str = glue::glue("{tml} ({tml_status})"),
      ms_str = glue::glue("{ms_status} ({ms_indels_per_mb})")
    ) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) |>
    # determine the field order
    dplyr::select(dplyr::any_of(x1$select), dplyr::everything()) |>
    tidyr::pivot_longer(dplyr::everything(), names_to = "field") |>
    dplyr::mutate(fill_colour = purrr::map2_chr(field, value, get_fill_colour))
  # now grab the colour for the str fields from the original field
  d1 <- d0 |>
    dplyr::mutate(
      fill_colour = dplyr::case_when(
        field == "purity_str" ~ d0$fill_colour[match("purity", d0$field)],
        field == "ploidy_str" ~ d0$fill_colour[match("ploidy", d0$field)],
        field == "diploid_proportion_str" ~ d0$fill_colour[match("diploid_proportion", d0$field)],
        field == "tmb_str" ~ d0$fill_colour[match("tmb_status", d0$field)],
        field == "tml_str" ~ d0$fill_colour[match("tml_status", d0$field)],
        field == "ms_str" ~ d0$fill_colour[match("ms_status", d0$field)],
        .default = .data$fill_colour
      )
    ) |>
    dplyr::filter(!field %in% x1$remove)
  description1 <- tibble::tribble(
    ~field, ~description,
    "purity_str", "purity of tumor in the sample (min-max with score within 10% of best)",
    "ploidy_str", "average ploidy of tumor purity-adjusted (min-max with score within 10% of best)",
    "diploid_proportion_str", "proportion of cn regions that have 1 (+-0.2) minor and major allele (min-max)",
    "tmb_str", "tumor mutational burden: #passing variants per Mb (status: high, low or unknown if somatic variants not supplied)",
    "tml_str", "tumor mutational load: #missense variants (status: high, low or unknown if somatic variants not supplied",
    "ms_str", "microsatellite status (msi, mss or unknown if somatic variants not supplied) (microsatellite indels per Mb)"
  ) |>
    dplyr::bind_rows(d$schema$schema[c("field", "description")])

  thresh <- tibble::tribble(
        ~field, ~threshold,
        "purity", "Green: >0.8; Orange: 0.4-0.8; Red: <0.4",
        "ploidy", "Green: 1.8-2.2; Orange: 1-1.8 or 2.2-3; Red: <1 or >3",
        "gender", "Green: MALE or FEMALE",
        "tmb", "Green: LOW; Orange: HIGH; Red: other",
        "ms", "Green: MSS; Orange: MSI; Red: other",
        "tml", "Green: LOW; Orange: HIGH; Red: other",
        "diploid_proportion", "Green: >0.8; Orange: 0.5-0.8; Red: <0.5",
        "polyclonal_proportion", "Green: 0-0.4; Orange: 0.4-0.5; Red: >0.5",
        "whole_genome_duplication", "Green: false; Orange: true",
        "tmb_sv", "Green: 0-500; Orange: 500-1000; Red: >1000",
        "status", "Green: NORMAL; Red: SOMATIC or NO_TUMOR",
        "fit_score", "Green: 0-0.8; Orange: 0.8-1.0; Red: >1.0",
        "norm_factor", "No colour thresholds",
        "somatic_penalty", "Green: 0; Red: >0",
        "method", "Green: NORMAL; Orange: HIGHLY_DIPLOID or SOMATIC; Red: NO_TUMOR",
        "run_mode", "Green: TUMOR_GERMLINE; Blue: other",
        "targeted", "Green: false; Blue: true"
      )
  d1 |>
    dplyr::left_join(description1, by = "field") |>
    dplyr::mutate(field = sub("_str$", "", .data$field)) |>
    dplyr::select("field", "value", "fill_colour", "description") |>
    dplyr::left_join(thresh, by = "field") |>
    tidyr::unite("description", c("description", "threshold"), sep = "\n")
}

#' @export
gt_tab <- function(d, schemas_all) {
  box::use(../wigits/table[gt_tab], ./purity[gt_tab_prep])
  gt_tab_prep(d, schemas_all) |>
    gt_tab("purple_purity")
}

#' @export
get_fill_colour <- function(field, value) {
  green <- "#90EE90"
  orange <- "#FFA500"
  red <- "#FF6B6B"
  blue <- "#ADD8E6"

  # Convert to numeric where needed
  num_val <- suppressWarnings(as.numeric(value))
  colour <- dplyr::case_when(
    field == "purity" & num_val >= 0.80 ~ green,
    field == "purity" & num_val >= 0.40 ~ orange,
    field == "purity" ~ red,

    field == "ploidy" & num_val >= 1.8 & num_val <= 2.2 ~ green,
    field == "ploidy" & ((num_val >= 1 & num_val < 1.8) | (num_val > 2.2 & num_val <= 3)) ~ orange,
    field == "ploidy" ~ red,

    field == "gender" & value %in% c("MALE", "FEMALE") ~ green,
    field == "gender" ~ red,

    field == "tmb_status" & value == "LOW" ~ green,
    field == "tmb_status" & value == "HIGH" ~ orange,
    field == "tmb_status" ~ red,

    field == "ms_status" & value == "MSS" ~ green,
    field == "ms_status" & value == "MSI" ~ orange,
    field == "ms_status" ~ red,

    field == "tml_status" & value == "LOW" ~ green,
    field == "tml_status" & value == "HIGH" ~ orange,
    field == "tml_status" ~ red,

    field == "diploid_proportion" & num_val >= 0.8 ~ green,
    field == "diploid_proportion" & num_val >= 0.5 ~ orange,
    field == "diploid_proportion" ~ red,

    field == "polyclonal_proportion" & num_val <= 0.4 ~ green,
    field == "polyclonal_proportion" & num_val <= 0.5 ~ orange,
    field == "polyclonal_proportion" ~ red,

    field == "whole_genome_duplication" & value == "false" ~ green,
    field == "whole_genome_duplication" & value == "true" ~ orange,
    field == "whole_genome_duplication" ~ red,

    field == "tmb_sv" & num_val <= 500 ~ green,
    field == "tmb_sv" & num_val <= 1000 ~ orange,
    field == "tmb_sv" ~ red,

    field == "status" & value == "NORMAL" ~ green,
    field == "status" ~ red,

    field == "fit_score" & num_val <= 0.8 ~ green,
    field == "fit_score" & num_val <= 1.0 ~ orange,
    field == "fit_score" ~ red,

    field == "norm_factor" ~ green,

    field == "somatic_penalty" & num_val == 0 ~ green,
    field == "somatic_penalty" ~ red,

    field == "method" & value == "NORMAL" ~ green,
    field == "method" & value %in% c("HIGHLY_DIPLOID", "SOMATIC") ~ orange,
    field == "method" ~ red,

    field == "run_mode" & value == "TUMOR_GERMLINE" ~ green,
    field == "run_mode" ~ blue,

    field == "targeted" & value == "false" ~ green,
    field == "targeted" & value == "true" ~ blue,
    field == "targeted" ~ red,

    TRUE ~ "white"
  )
  return(colour)
}

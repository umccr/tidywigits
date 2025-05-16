x <- "~/projects/tidywigits/nogit/oa_2.0.0_colo829_20250507/bamtools/COLO829v003_WGTS_COLO829_tumor_bamtools/COLO829_tumor.bam_metric.summary.tsv"
y <- readr::read_tsv(x)
purrr::map_chr(y, class) |>
  tibble::enframe(name = "field", value = "type") |>
  dplyr::mutate(
    type = dplyr::case_match(
      .data$type,
      "character" ~ "char",
      "integer" ~ "int",
      "numeric" ~ "float",
      "logical" ~ "char"
    ),
    n = dplyr::row_number()
  ) |>
  tidyr::nest(.by = n, .key = "latest") |>
  dplyr::select(-"n") |>
  yaml::as.yaml() |>
  glue::glue()

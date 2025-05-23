"~/projects/tidywigits/nogit/oa_v1/isofox/L2500527.isf.gene_collection.csv" |>
  readr::read_csv() |>
  purrr::map_chr(class) |>
  tibble::enframe(name = "field", value = "type") |>
  dplyr::mutate(
    type = dplyr::case_match(
      .data$type,
      "character" ~ "'char'",
      "integer" ~ "'int'",
      "numeric" ~ "'float'",
      "logical" ~ "'char'"
    ),
    n = dplyr::row_number(),
    field = paste0("'", .data$field, "'")
  ) |>
  tidyr::nest(.by = n, .key = "latest") |>
  dplyr::select(-"n") |>
  yaml::as.yaml() |>
  glue::glue()

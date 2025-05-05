x <- "~/projects/tidywigits/nogit/oncoanalyser-wgts-dna/20250407e2ff5344/L2500331_L2500332/virusbreakend/L2500331.virusbreakend.vcf.summary.tsv"
d <- readr::read_tsv(x)
purrr::map_chr(d, class) |>
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

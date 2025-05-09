require(dplyr)
d <- here::here("nogit/linx_descriptions.rds") |>
  readr::read_rds() |>
  dplyr::mutate(
    table_description = "",
    pattern = "",
    ftype = "tsv",
    field_tidy = tolower(.data$Field),
    Type = dplyr::case_match(
      .data$Type,
      "c" ~ "char",
      "d" ~ "float",
      "i" ~ "int",
      .default = "char"
    )
  ) |>
  dplyr::rename(field = "Field", type = "Type", description = "Description")

tabs <- unique(d$Table)
n <- length(tabs)
l <- vector("list", length = n) |>
  purrr::set_names(tabs)
l2 <- vector("list", length = n) |>
  purrr::set_names(tabs)
for (tab in tabs) {
  l[[tab]] <- list(
    description = "",
    pattern = "foo",
    ftype = "tsv",
    schema = list(
      latest = d |> dplyr::filter(Table == tab) |> dplyr::select(field, type)
    )
  )
}

l |>
  yaml::write_yaml("nogit/linx_descriptions.yaml", column.major = FALSE)

for (tab in tabs) {
  l2[[tab]] <- list(
    description = "",
    schema = list(
      foo = d |>
        dplyr::filter(Table == tab) |>
        dplyr::select(field_tidy, type, description) |>
        dplyr::rename(field = "field_tidy")
    )
  )
}

l2 |>
  yaml::write_yaml("nogit/linx_descriptions_tidy.yaml", column.major = FALSE)

d1 <- here::here(
  "../biodaily/pdiakumis/nemo/accreditation_wgs/nogit/oncoanalyser-wgts-dna/202509100539df0e/L2101100__L2101099/neo"
)
pref <- "L2101100.neo"
tool <- "neo"
descr <- "Neoepitope prediction."
# fmt: skip
d <- tibble::tribble(
    ~name,               ~descr,                   ~pat,                                       ~path,
    "neocand", "Neoepitope candidates.", "\\.neo\\.neo_data\\.tsv$", glue("finder/{pref}.neo_data.tsv"),
    "neopred", "Neoepitope predictions.", "\\.neo\\.neoepitope\\.tsv$", glue("scorer/{pref}.neoepitope.tsv")
  ) |>
  dplyr::mutate(type = "tsv", path = file.path(d1, .data$path))
nemo::config_prep_multi(d, tool_descr = descr) |>
  nemo::config_prep_write(
    here::here(glue::glue("inst/config/tools/{tool}/raw.yaml"))
  )

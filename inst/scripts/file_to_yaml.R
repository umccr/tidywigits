# Script to convert output files to yaml configs
{
  use("glue", "glue")
  use("tibble", "tribble")
  use("dplyr")
  use("here", "here")
  use("nemo", c("config_prep_multi", "config_prep_write"))
}

tool <- "teal"
pref <- "sample1"
descr <- "Telomere characterisation."
d1 <- here(glue("inst/extdata/oa/{tool}"))
# fmt: skip
d <- tribble(
    ~name,    ~descr,                  ~pat,               ~path,
    "breakend", "Telomeric rearrangements.", "\\.teal\\.breakend\\.tsv\\.gz$", glue("{pref}.teal.breakend.tsv.gz"),
    "tellength", "Telomeric length and content.", "\\.teal\\.tellength\\.tsv$", glue("{pref}.teal.tellength.tsv"),
  ) |>
  mutate(type = "tsv", path = file.path(d1, .data$path))
stopifnot(all(file.exists(d$path)))
nemo::config_prep_multi(d, tool_descr = descr) |>
  nemo::config_prep_write(
    here(glue("inst/config/tools/{tool}/raw.yaml"))
  )

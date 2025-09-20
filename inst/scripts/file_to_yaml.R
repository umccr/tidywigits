# Script to convert output files to yaml configs
{
  use("glue", "glue")
  use("tibble", "tribble")
  use("dplyr", c("mutate"))
  use("here", "here")
  use("nemo", c("config_prep_multi", "config_prep_write"))
}

d1 <- here("inst/extdata/oa/peach")
pref <- "sample1"
tool <- "peach"
descr <- "Pharmacogenomic evaluator and caller of haplotypes."
# fmt: skip
d <- tribble(
    ~name,               ~descr,                   ~pat,                                       ~path,
    "events", ".", "\\.peach\\.events\\.tsv$", glue("{pref}.peach.events.tsv"),
    "eventsg", ".", "\\.peach\\.gene\\.events\\.tsv$", glue("{pref}.peach.gene.events.tsv"),
    "hapall", ".", "\\.peach\\.haplotypes\\.all\\.tsv$", glue("{pref}.peach.haplotypes.all.tsv"),
    "hapbest", ".", "\\.peach\\.haplotypes\\.best\\.tsv$", glue("{pref}.peach.haplotypes.best.tsv"),
    "qc", ".", "\\.peach\\.qc\\.tsv$", glue("{pref}.peach.qc.tsv"),
  ) |>
  mutate(type = "tsv", path = file.path(d1, .data$path))
nemo::config_prep_multi(d, tool_descr = descr) |>
  nemo::config_prep_write(
    here::here(glue::glue("inst/config/tools/{tool}/raw.yaml"))
  )

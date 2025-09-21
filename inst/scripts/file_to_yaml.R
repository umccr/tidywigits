# Script to convert output files to yaml configs
{
  use("glue", "glue")
  use("tibble", "tribble")
  use("dplyr")
  use("here", "here")
  use("nemo", c("config_prep_multi", "config_prep_write"))
}

tool <- "cider"
pref <- "sample1"
descr <- "Lists CDR3 sequences for each of the IG and TCR loci, including an abundance estimate, incomplete rearrangements and IGK-KDE deletions."
d1 <- here(glue("inst/extdata/oa/{tool}"))
# fmt: skip
d <- tribble(
    ~name,    ~descr,                  ~pat,               ~path,
    "blastn", "BLASTn hits.", "\\.cider\\.blastn_match\\.tsv\\.gz$", glue("{pref}.cider.blastn_match.tsv.gz"),
    "locstats", "Locus stats.", "\\.cider\\.locus_stats\\.tsv$", glue("{pref}.cider.locus_stats.tsv"),
    "vdj", "VDJ sequences.", "\\.cider\\.vdj\\.tsv.gz$", glue("{pref}.cider.vdj.tsv.gz"),
  ) |>
  mutate(type = "tsv", path = file.path(d1, .data$path))
stopifnot(all(file.exists(d$path)))
nemo::config_prep_multi(d, tool_descr = descr) |>
  nemo::config_prep_write(
    here(glue("inst/config/tools/{tool}/raw.yaml"))
  )

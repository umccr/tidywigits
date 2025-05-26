fpath <- "~/projects/tidywigits/nogit/oa_v2/esvee/prep/COLO829_tumor.esvee.prep.fragment_length.tsv"
name <- "prepfraglen"
description <- "Fragment length stats."
pattern <- "\\.esvee\\.prep\\.fragment_length\\.tsv$"
ftype <- "tsv"
version <- "latest"
delim <- "\t"

d1 <- here::here("nogit/oa_v2/esvee")
pref <- "COLO829_tumor.esvee"
# fmt: skip
d <- tibble::tribble(
    ~name,               ~descr,                   ~pat,                                       ~path,
    "prepfraglen",       "Fragment length stats.", "\\.esvee\\.prep\\.fragment_length\\.tsv$", glue("prep/{pref}.prep.fragment_length.tsv"),
    "prepdiscstats",     "Discordant read stats.", "\\.esvee\\.prep\\.disc_stats\\.tsv$",      glue("prep/{pref}.prep.disc_stats.tsv"),
    "prepjunction",      "Candidate junctions.",   "\\.esvee\\.prep\\.junction\\.tsv$",        glue("prep/{pref}.prep.junction.tsv"),
    "assemblephased",    "Phased assemblies.",     "\\.esvee\\.phased_assembly\\.tsv$",        glue("assemble/{pref}.phased_assembly.tsv"),
    "assembleassembly",  "Breakend assemblies.",   "\\.esvee\\.assembly\\.tsv$",               glue("assemble/{pref}.phased_assembly.tsv"),
    "assemblebreakend",  "Breakends.",             "\\.esvee\\.breakend\\.tsv$",               glue("assemble/{pref}.breakend.tsv"),
    "assemblealignment", "Realigned assemblies.",  "\\.esvee\\.alignment\\.tsv$",              glue("assemble/{pref}.alignment.tsv")
  ) |>
  dplyr::mutate(type = "tsv", path = file.path(d1, .data$path))
config_prep_multi(d) |>
  config_prep_write(here::here(glue::glue("inst/config/tools/esvee/raw.yaml")))

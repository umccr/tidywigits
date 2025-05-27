d1 <- here::here("nogit/oa_v2/esvee")
pref <- "COLO829_tumor.esvee"
tool <- "esvee"
descr <- "Structural variant caller optimised for short read sequencing."
# fmt: skip
d <- tibble::tribble(
    ~name,               ~descr,                   ~pat,                                       ~path,
    "prepfraglen",       "Fragment length stats.", "\\.esvee\\.prep\\.fragment_length\\.tsv$", glue("prep/{pref}.prep.fragment_length.tsv"),
    "prepdiscstats",     "Discordant read stats.", "\\.esvee\\.prep\\.disc_stats\\.tsv$",      glue("prep/{pref}.prep.disc_stats.tsv"),
    "prepjunction",      "Candidate junctions.",   "\\.esvee\\.prep\\.junction\\.tsv$",        glue("prep/{pref}.prep.junction.tsv"),
    "assemblephased",    "Phased assemblies.",     "\\.esvee\\.phased_assembly\\.tsv$",        glue("assemble/{pref}.phased_assembly.tsv"),
    "assembleassembly",  "Breakend assemblies.",   "\\.esvee\\.assembly\\.tsv$",               glue("assemble/{pref}.assembly.tsv"),
    "assemblebreakend",  "Breakends.",             "\\.esvee\\.breakend\\.tsv$",               glue("assemble/{pref}.breakend.tsv"),
    "assemblealignment", "Realigned assemblies.",  "\\.esvee\\.alignment\\.tsv$",              glue("assemble/{pref}.alignment.tsv")
  ) |>
  dplyr::mutate(type = "tsv", path = file.path(d1, .data$path))
config_prep_multi(d, tool_descr = descr) |>
  config_prep_write(
    here::here(glue::glue("inst/config/tools/{tool}/raw.yaml"))
  )

# fmt: skip
d <- tibble::tribble(
    ~name, ~descr, ~pat, ~path, ~type,
    "neoepitope", "Gene fusion neoepitopes.", "\\.linx\\.neoepitope\\.tsv$", here::here("nogit/oa_v2/linx/somatic_annotations/COLO829_tumor.linx.neoepitope.tsv"), "tsv",
)
config_prep_multi(d, tool_descr = "linx") |>
  yaml::as.yaml(column.major = F) |>
  cat()

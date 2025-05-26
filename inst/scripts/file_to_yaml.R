fpath <- "~/projects/tidywigits/nogit/oa_v2/esvee/prep/COLO829_tumor.esvee.prep.fragment_length.tsv"
name <- "prepfraglen"
description <- "Fragment length stats."
pattern <- "\\.esvee\\.prep\\.fragment_length\\.tsv$"
ftype <- "tsv"
version <- "latest"
delim <- "\t"
l <- file2config(
)

yaml::write_yaml(l, here(glue("inst/config/tools/{tool}/raw.yaml")))

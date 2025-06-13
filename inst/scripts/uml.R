# Construct UML diagram from all available classes

# fmt: skip
# classes start with a cap, copy into vector and get their value
# dput(ls("package:tidywigits", pattern = "[A-Z].*")) # note: load pkg prior
fun_char <- c(
  "Alignments", "Amber", "Bamtools", "Chord", "Cobalt", "Config", "Cuppa",
  "Esvee", "File", "Flagstats", "Isofox", "Lilac", "Linx", "Oncoanalyser",
  "Purple", "Sage", "Sigs", "Tool", "Virusbreakend", "Virusinterpreter",
  "Workflow"
)
# remotes::install_gitlab("b-rowlingson/R6toPlant")
require(R6toPlant, include.only = "make_plant")
require(tidywigits, include.only = fun_char)
require(purrr, include.only = "map")
require(here, include.only = "here")
require(glue, include.only = "glue")
require(fs, include.only = "dir_create")

# get returns value of function
x_as_fun <- purrr::map(fun_char, get)
out_pref <- here::here("inst/extdata/uml/tidywigits")
out_uml <- glue::glue("{out_pref}.uml")
fs::dir_create(dirname(out_uml))
R6toPlant::make_plant(
  classes = x_as_fun,
  output = out_uml
)
system(glue::glue("plantuml -tsvg {out_uml}"))

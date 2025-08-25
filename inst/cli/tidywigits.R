#!/usr/bin/env Rscript

{
  suppressPackageStartupMessages(use("argparse", "ArgumentParser"))
  suppressPackageStartupMessages(use("cli"))
  suppressPackageStartupMessages(use("emojifont", "emoji"))
  suppressPackageStartupMessages(use("tidywigits"))
  suppressPackageStartupMessages(use("nemo"))
  suppressPackageStartupMessages(use("fs", "dir_create"))
  suppressPackageStartupMessages(use("glue", "glue"))
}

pkg <- "tidywigits"
prog_nm <- paste0(pkg, ".R")
version <- as.character(packageVersion(pkg))
p <- argparse::ArgumentParser(
  description = glue("{emoji('tropical_fish')} WiGiTS Output Tidying {emoji('turtle')}"),
  prog = prog_nm
)
p$add_argument("-v", "--version", action = "version", version = glue("{prog_nm} {version}"))
subparser_name <- "subparser_name"
subp <- p$add_subparsers(help = "sub-command help", dest = subparser_name)

source(system.file("cli/tidy.R", package = pkg))
source(system.file("cli/list.R", package = pkg))
tidy_add_args(subp)
list_add_args(subp)
args <- p$parse_args()

if (length(args$subparser_name) == 0) {
  p$print_help()
} else if (args$subparser_name == "tidy") {
  tidy_parse_args(args)
} else if (args$subparser_name == "list") {
  list_parse_args(args)
} else {
  all_subp <- c("tidy", "list") |>
    glue::glue_collapse(sep = ", ", last = " or ")
  cli::cli_alert_danger("Need to specify one of the following: {all_subp}")
}

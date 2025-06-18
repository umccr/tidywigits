#!/usr/bin/env Rscript

{
  suppressPackageStartupMessages(require(argparse, include.only = "ArgumentParser"))
  suppressPackageStartupMessages(require(cli))
  suppressPackageStartupMessages(require(emojifont, include.only = "emoji"))
  suppressPackageStartupMessages(require(tidywigits))
  suppressPackageStartupMessages(require(fs, include.only = c("dir_create")))
  suppressPackageStartupMessages(require(glue, include.only = "glue"))
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

tidy_add_args(subp)
args <- p$parse_args()

if (length(args$subparser_name) == 0) {
  p$print_help()
} else if (args$subparser_name == "tidy") {
  tidy_parse_args(args)
} else {
  cli::cli_alert_danger("Need to specify 'tidy' in the cli...")
}

#!/usr/bin/env Rscript

suppressPackageStartupMessages(use("nemo", c("nemo_cli")))
nemo::nemo_cli(pkg = "tidywigits", descr = "✨ WiGiTS Output Tidying ✨", wf = "wigits")



<!-- README.md is generated from README.qmd. Please edit that file -->

# 🧬✨ tidywigits: Tidy WiGiTS Outputs

- Docs: <https://umccr.github.io/tidywigits/>

## Overview

{tidywigits} is an R package that parses and tidies outputs from the
[WiGiTS](https://github.com/hartwigmedical/hmftools "WiGiTS suite")
suite of genome and transcriptome analysis tools for cancer research and
diagnostics, created by the Hartwig Medical Foundation.

In short, it traverses through a directory containing results from one
or more runs of WiGiTS tools, parses any files it recognises, tidies
them up (which includes data reshaping, normalisation, column name
cleanup etc.), and writes them to the output format of choice
e.g. Apache Parquet, PostgreSQL, TSV etc..

**TODO: ADD GIF**

## Quick Links

- 📚 [Documentation](https://umccr.github.io/tidywigits/)
- 🎨 [Examples](#-examples)
- 🍕 [Installation](#-installation)
- 🌀 [CLI](#-cli)

## 🎨 Examples

You can output tidywigits results to a variety of formats, including
TSV, Parquet, or write directly to a PostgreSQL database.

- Parquet:

``` r
in_dir <- "path/to/wigits/results"
out_dir <- "path/to/tidied/output"
oa <- Oncoanalyser$new(in_dir)
res1 <- oa$nemofy(odir = out_dir, format = "parquet", id = "parquet_example")
```

- PostgreSQL (this should work with any typical database that has an R
  driver, e.g. MySQL, SQLite, etc., just make sure you create the
  correct connection object):

``` r
dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "orcabus"
)
res2 <-
  oa$nemofy(
    format = "db",
    id = "db_example",
    dbconn = dbconn
)
```

## 🍕 Installation

### R

You can install and load the latest version or a specific tag directly
from GitHub with one of the following:

``` r
remotes::install_github("umccr/tidywigits")
remotes::install_github("umccr/tidywigits@vX.X.X")
library(tidywigits)
```

### Conda

Conda package available from the umccr Anaconda channel at
<https://anaconda.org/umccr/r-tidywigits>.

``` bash
conda create \
  -n tidywigits_env \
  -c umccr -c conda-forge \
  r-tidywigits==X.X.X

conda activate tidywigits_env
```

### Docker

Docker image available in the GitHub Container Registry at
<https://github.com/umccr/tidywigits/pkgs/container/tidywigits>.

``` bash
docker pull --platform linux/amd64 ghcr.io/umccr/tidywigits:X.X.X
```

### Pixi

If you use Pixi, you can create a new environment with the released
conda package:

``` bash
pixi init -c umccr -c conda-forge ./tidy_env
cd ./tidy_env
pixi add r-tidywigits==X.X.X
```

## 🌀 CLI

A `tidywigits.R` command line interface is available for convenience.

- If you’re using the conda package, the `tidywigits.R` command will
  already be available inside the activated conda environment.
- If you’re *not* using the conda package, you need to export the
  `tidywigits/inst/cli/` directory to your `PATH` in order to use
  `tidywigits.R`.

``` bash
tw_cli=$(Rscript -e 'x = system.file("cli", package = "tidywigits"); cat(x, "\n")' | xargs)
export PATH="${tw_cli}:${PATH}"
```

    tidywigits.R --version
    tidywigits.R 0.0.3

    #-----------------------------------#
    tidywigits.R --help
    usage: tidywigits.R [-h] [-v] {tidy,list} ...

    🐠 WiGiTS Output Tidying 🐢

    positional arguments:
      {tidy,list}    sub-command help
        tidy         Tidy WiGiTS Workflow Outputs
        list         List Parsable WiGiTS Workflow Outputs

    options:
      -h, --help     show this help message and exit
      -v, --version  show program's version number and exit

    #-----------------------------------#
    #------- Tidy ----------------------#
    tidywigits.R tidy --help
    usage: tidywigits.R tidy [-h] -d IN_DIR [-o OUT_DIR] [-f FORMAT] -i ID
                             [--dbname DBNAME] [--dbuser DBUSER]
                             [--include INCLUDE] [--exclude EXCLUDE] [-q]

    options:
      -h, --help            show this help message and exit
      -d IN_DIR, --in_dir IN_DIR
                            🚑 Input directory.
      -o OUT_DIR, --out_dir OUT_DIR
                            🚀 Output directory.
      -f FORMAT, --format FORMAT
                            🎨 Format of output (def: parquet). Choices: parquet,
                            db, tsv, csv, rds
      -i ID, --id ID        🚩 ID to use for this run.
      --dbname DBNAME       🐶 Database name (def: nemo).
      --dbuser DBUSER       🐢 Database user (def: orcabus).
      --include INCLUDE     ✅ Include only these files (comma,sep).
      --exclude EXCLUDE     ❌ Exclude these files (comma,sep).
      -q, --quiet           😴 Shush all the logs.

    #-----------------------------------#
    #------- List ----------------------#
    tidywigits.R list --help
    usage: tidywigits.R list [-h] -d IN_DIR [-q]

    options:
      -h, --help            show this help message and exit
      -d IN_DIR, --in_dir IN_DIR
                            🚑 Input directory.
      -q, --quiet           😴 Shush all the logs.

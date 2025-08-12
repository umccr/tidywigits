

<!-- README.md is generated from README.qmd. Please edit that file -->

# 🧬✨ tidywigits: Tidy WiGiTS Outputs

📚 Docs: https://umccr.github.io/tidywigits/

## Overview

{tidywigits} is an R package that parses and tidies outputs from the
[WiGiTS](https://github.com/hartwigmedical/hmftools "WiGiTS suite")
suite of genome and transcriptome analysis tools for cancer research and
diagnostics, created by the Hartwig Medical Foundation.

In short, it traverses through a directory containing results from one
or more runs of WiGiTS tools, parses any files it recognises, tidies
them up (which includes data reshaping, normalisation, column name
cleanup etc.), and writes them to the output format of choice
e.g. Apache Parquet, PostgreSQL, TSV, RDS.

## Examples

You can output tidywigits results to a variety of formats, including TSV
and Parquet, or write directly to a PostgreSQL database.

- Parquet:

``` r
in_dir <- system.file("extdata/oa", package = "tidywigits")
out_dir <- tempdir() |> fs::dir_create("parquet_example")
oa <- Oncoanalyser$new(in_dir)
res <- oa$nemofy(odir = out_dir, format = "parquet", id = "parquet_example")
fs::dir_info(out_dir) |>
  dplyr::mutate(bname = basename(.data$path)) |>
  dplyr::select("bname", "size", "type")
# A tibble: 64 × 3
   bname                                              size type 
   <chr>                                       <fs::bytes> <fct>
 1 sample1_2_sage_bqrtsv.parquet                      3.1K file 
 2 sample1_alignments_dupfreq.parquet                1.95K file 
 3 sample1_amber_bafpcf.parquet                      3.27K file 
 4 sample1_amber_contaminationtsv.parquet            4.13K file 
 5 sample1_amber_homozygousregion.parquet            3.18K file 
 6 sample1_amber_qc.parquet                          2.35K file 
 7 sample1_bamtools_wgsmetrics_histo.parquet         4.19K file 
 8 sample1_bamtools_wgsmetrics_metrics.parquet      10.12K file 
 9 sample1_chord_prediction.parquet                  3.43K file 
10 sample1_chord_signatures.parquet                  2.17K file 
# ℹ 54 more rows
```

- PostgreSQL (this should work with any typical database that has an R
  driver, e.g. MySQL, SQLite, etc., just make sure you create the
  correct connection object):

``` r
in_dir <- system.file("extdata/oa", package = "tidywigits")
out_dir <- tempdir() |> fs::dir_create("parquet_example")
oa <- Oncoanalyser$new(in_dir)
dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "user1"
)
res <-
  oa$nemofy(
    format = "db",
    id = "db_example",
    dbconn = dbconn
  )
```

## 🍕 Installation

Install using {remotes} directly from GitHub:

``` r
install.packages("remotes")
remotes::install_github("umccr/tidywigits") # latest main commit
remotes::install_github("umccr/tidywigits@vX.X.X") # released version X.X.X
```

Alternatively:

- conda package: <https://anaconda.org/umccr/r-tidywigits>
- Docker image:
  <https://github.com/umccr/tidywigits/pkgs/container/tidywigits>

For more details see: <https://umccr.github.io/tidywigits/installation/>

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

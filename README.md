

<!-- README.md is generated from README.qmd. Please edit that file -->

<a href="https://umccr.github.io/tidywigits"><img src="man/figures/logo.png" alt="logo" align="left" height="100" /></a>

# 🧬✨ Tidy WiGiTS Outputs

[![conda-latest1](https://anaconda.org/umccr/r-tidywigits/badges/latest_release_date.svg "Conda Latest Release")](https://anaconda.org/umccr/r-tidywigits)
[![gha](https://github.com/umccr/tidywigits/actions/workflows/deploy.yaml/badge.svg "GitHub Actions")](https://github.com/umccr/tidywigits/actions/workflows/deploy.yaml)

- 📚 Docs: <https://umccr.github.io/tidywigits>:
  - [Installation](https://umccr.github.io/tidywigits/articles/installation)
  - [Files/tables
    supported](https://umccr.github.io/tidywigits/articles/schemas_raw)
  - [Tidy
    schemas](https://umccr.github.io/tidywigits/articles/schemas_tidy)
  - [Developer
    notes](https://umccr.github.io/tidywigits/articles/developers)
  - [Changelog](https://umccr.github.io/tidywigits/articles/NEWS)

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

## 🎨 Quick Start

The starting point of {tidywigits} is a directory with WiGiTS results.
Let’s look at some sample data (tracked via [DVC](https://dvc.org/))
under <https://github.com/umccr/tidywigits/tree/main/inst/extdata/oa>:

<details class="code-fold">
<summary>Click here</summary>

``` r
system.file("extdata/oa", package = "tidywigits") |>
  fs::dir_tree(invert = TRUE, glob = "*.dvc")
/Users/pdiakumis/Library/R/arm64/4.5/library/tidywigits/extdata/oa
├── alignments
│   └── sample1.duplicate_freq.tsv
├── amber
│   ├── sample1.amber.baf.pcf
│   ├── sample1.amber.contamination.tsv
│   ├── sample1.amber.homozygousregion.tsv
│   └── sample1.amber.qc
├── bamtools
│   └── sample1.wgsmetrics
├── chord
│   ├── sample1.chord.mutation_contexts.tsv
│   └── sample1.chord.prediction.tsv
├── cobalt
│   ├── cobalt.version
│   ├── sample1.cobalt.gc.median.tsv
│   ├── sample1.cobalt.ratio.median.tsv
│   └── sample1.cobalt.ratio.pcf
├── cuppa
│   ├── sample1.cuppa.pred_summ.tsv
│   ├── sample1.cuppa.vis_data.tsv
│   └── sample1.cuppa_data.tsv.gz
├── lilac
│   ├── sample1.lilac.candidates.coverage.tsv
│   ├── sample1.lilac.qc.tsv
│   └── sample1.lilac.tsv
├── linx
│   ├── germline_annotations
│   │   ├── linx.version
│   │   ├── sample1.linx.germline.breakend.tsv
│   │   ├── sample1.linx.germline.clusters.tsv
│   │   ├── sample1.linx.germline.disruption.tsv
│   │   ├── sample1.linx.germline.driver.catalog.tsv
│   │   ├── sample1.linx.germline.links.tsv
│   │   └── sample1.linx.germline.svs.tsv
│   └── somatic_annotations
│       ├── linx.version
│       ├── sample1.linx.breakend.tsv
│       ├── sample1.linx.clusters.tsv
│       ├── sample1.linx.driver.catalog.tsv
│       ├── sample1.linx.drivers.tsv
│       ├── sample1.linx.fusion.tsv
│       ├── sample1.linx.links.tsv
│       ├── sample1.linx.svs.tsv
│       ├── sample1.linx.vis_copy_number.tsv
│       ├── sample1.linx.vis_fusion.tsv
│       ├── sample1.linx.vis_gene_exon.tsv
│       ├── sample1.linx.vis_protein_domain.tsv
│       ├── sample1.linx.vis_segments.tsv
│       └── sample1.linx.vis_sv_data.tsv
├── purple
│   ├── purple.version
│   ├── sample1.purple.cnv.gene.tsv
│   ├── sample1.purple.cnv.somatic.tsv
│   ├── sample1.purple.driver.catalog.germline.tsv
│   ├── sample1.purple.driver.catalog.somatic.tsv
│   ├── sample1.purple.germline.deletion.tsv
│   ├── sample1.purple.purity.range.tsv
│   ├── sample1.purple.purity.tsv
│   ├── sample1.purple.qc
│   ├── sample1.purple.somatic.clonality.tsv
│   └── sample1.purple.somatic.hist.tsv
├── sage
│   ├── germline
│   │   ├── sample1.sage.bqr.tsv
│   │   ├── sample2.sage.bqr.tsv
│   │   ├── sample2.sage.exon.medians.tsv
│   │   └── sample2.sage.gene.coverage.tsv
│   └── somatic
│       ├── sample1.sage.bqr.tsv
│       ├── sample1.sage.exon.medians.tsv
│       ├── sample1.sage.gene.coverage.tsv
│       └── sample2.sage.bqr.tsv
├── sigs
│   ├── sample1.sig.allocation.tsv
│   └── sample1.sig.snv_counts.csv
├── virusbreakend
│   └── sample1.virusbreakend.vcf.summary.tsv
└── virusinterpreter
    └── sample1.virus.annotated.tsv
```

</details>

We can parse, tidy up, and write the WiGiTS results into e.g. Parquet
format or a PostgreSQL database as follows:

- Parquet:

``` r
in_dir <- system.file("extdata/oa", package = "tidywigits")
out_dir <- tempdir() |> fs::dir_create("parquet_example")
w <- Wigits$new(in_dir)
res <- w$nemofy(odir = out_dir, format = "parquet", id = "parquet_example")
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

- PostgreSQL:

``` r
in_dir <- system.file("extdata/oa", package = "tidywigits")
out_dir <- tempdir() |> fs::dir_create("parquet_example")
w <- Wigits$new(in_dir)
dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "orcabus"
)
res <- w$nemofy(
  format = "db",
  id = "db_example",
  dbconn = dbconn
)
```

**IMPORTANT**: support for VCFs is still under development.

## 🍕 Installation

Using {remotes} directly from GitHub:

``` r
install.packages("remotes")
remotes::install_github("umccr/tidywigits") # latest main commit
remotes::install_github("umccr/tidywigits@v0.0.5") # released version
```

Alternatively:

- conda package: <https://anaconda.org/umccr/r-tidywigits>
- Docker image:
  <https://github.com/umccr/tidywigits/pkgs/container/tidywigits>

For more details see:
<https://umccr.github.io/tidywigits/articles/installation>

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

    $ tidywigits.R --version
    tidywigits 0.0.5

    #-----------------------------------#
    $ tidywigits.R --help
    usage: tidywigits.R [-h] [-v] {tidy,list} ...

    ✨ WiGiTS Output Tidying ✨

    positional arguments:
      {tidy,list}    sub-command help
        tidy         Tidy Workflow Outputs
        list         List Parsable Workflow Outputs

    options:
      -h, --help     show this help message and exit
      -v, --version  show program's version number and exit
    '
    #-----------------------------------#
    #------- Tidy ----------------------#
    $ tidywigits.R tidy --help
    usage: tidywigits.R tidy [-h] -d IN_DIR [-o OUT_DIR] [-f FORMAT] -i ID
                             [--dbname DBNAME] [--dbuser DBUSER]
                             [--include INCLUDE] [--exclude EXCLUDE] [-q]

    options:
      -h, --help            show this help message and exit
      -d IN_DIR, --in_dir IN_DIR
                            Input directory.
      -o OUT_DIR, --out_dir OUT_DIR
                            Output directory.
      -f FORMAT, --format FORMAT
                            Format of output [def: parquet] (parquet, db, tsv,
                            csv, rds)
      -i ID, --id ID        ID to use for this run.
      --dbname DBNAME       Database name.
      --dbuser DBUSER       Database user.
      --include INCLUDE     Include only these files (comma,sep).
      --exclude EXCLUDE     Exclude these files (comma,sep).
      -q, --quiet           Shush all the logs.

    #-----------------------------------#
    #------- List ----------------------#
    $ tidywigits.R list --help
    usage: tidywigits.R list [-h] -d IN_DIR [-f FORMAT] [-q]

    options:
      -h, --help            show this help message and exit
      -d IN_DIR, --in_dir IN_DIR
                            Input directory.
      -f FORMAT, --format FORMAT
                            Format of list output [def: pretty] (tsv, pretty)
      -q, --quiet           Shush all the logs.



<!-- README.md is generated from README.qmd. Please edit that file -->

# 🧬✨ tidywigits

- Docs: <https://umccr.github.io/tidywigits/>

{tidywigits} is an R package that parses and tidies outputs from the
[WiGiTS](https://github.com/hartwigmedical/hmftools "WiGiTS suite")
suite of genome and transcriptome analysis tools for cancer research and
diagnostics, created by the Hartwig Medical Foundation.

In short, it traverses through a directory containing results from one
or more runs of WiGiTS tools, parses any files it recognises, tidies
them up (which includes data reshaping, normalisation, column name
cleanup etc.), and writes them to the output format of choice
e.g. Apache Parquet, PostgreSQL, Delta table.

## 🍕 Installation

### R

``` r
remotes::install_github("umccr/tidywigits")
```

### Conda

#### Linux & MacOS (non-ARM)

``` bash
conda create \
  -n tidywigits_env \
  -c umccr -c conda-forge \
  r-tidywigits==X.X.X

conda activate tidywigits_env
```

#### MacOS ARM

``` bash
CONDA_SUBDIR=osx-64 \
  conda create \
  -n tidywigits_env \
  -c umccr -c conda-forge \
  r-tidywigits==X.X.X

conda activate tidywigits_env
```

### Docker

``` bash
docker pull --platform linux/amd64 ghcr.io/umccr/tidywigits:X.X.X
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

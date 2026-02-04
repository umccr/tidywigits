# Bamtools Object

Bamtools file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Bamtools`

## Methods

### Public methods

- [`Bamtools$new()`](#method-Bamtools-new)

- [`Bamtools$parse_summary()`](#method-Bamtools-parse_summary)

- [`Bamtools$tidy_summary()`](#method-Bamtools-tidy_summary)

- [`Bamtools$parse_wgsmetrics()`](#method-Bamtools-parse_wgsmetrics)

- [`Bamtools$tidy_wgsmetrics()`](#method-Bamtools-tidy_wgsmetrics)

- [`Bamtools$parse_flagstats()`](#method-Bamtools-parse_flagstats)

- [`Bamtools$tidy_flagstats()`](#method-Bamtools-tidy_flagstats)

- [`Bamtools$parse_coverage()`](#method-Bamtools-parse_coverage)

- [`Bamtools$tidy_coverage()`](#method-Bamtools-tidy_coverage)

- [`Bamtools$parse_fraglength()`](#method-Bamtools-parse_fraglength)

- [`Bamtools$tidy_fraglength()`](#method-Bamtools-tidy_fraglength)

- [`Bamtools$parse_partitionstats()`](#method-Bamtools-parse_partitionstats)

- [`Bamtools$tidy_partitionstats()`](#method-Bamtools-tidy_partitionstats)

- [`Bamtools$parse_genecvg()`](#method-Bamtools-parse_genecvg)

- [`Bamtools$tidy_genecvg()`](#method-Bamtools-tidy_genecvg)

- [`Bamtools$parse_exoncvg()`](#method-Bamtools-parse_exoncvg)

- [`Bamtools$tidy_exoncvg()`](#method-Bamtools-tidy_exoncvg)

- [`Bamtools$clone()`](#method-Bamtools-clone)

Inherited methods

- [`nemo::Tool$.eval_func()`](https://umccr.github.io/nemo/reference/Tool.html#method-.eval_func)
- [`nemo::Tool$.parse_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file)
- [`nemo::Tool$.parse_file_keyvalue()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_keyvalue)
- [`nemo::Tool$.parse_file_nohead()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_nohead)
- [`nemo::Tool$.tidy_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.tidy_file)
- [`nemo::Tool$filter_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$list_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-list_files)
- [`nemo::Tool$nemofy()`](https://umccr.github.io/nemo/reference/Tool.html#method-nemofy)
- [`nemo::Tool$print()`](https://umccr.github.io/nemo/reference/Tool.html#method-print)
- [`nemo::Tool$tidy()`](https://umccr.github.io/nemo/reference/Tool.html#method-tidy)
- [`nemo::Tool$write()`](https://umccr.github.io/nemo/reference/Tool.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Bamtools object.

#### Usage

    Bamtools$new(path = NULL, files_tbl = NULL)

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this basically
  gets ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

------------------------------------------------------------------------

### Method `parse_summary()`

Read `summary.tsv` file.

#### Usage

    Bamtools$parse_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_summary()`

Tidy `summary.tsv` file.

#### Usage

    Bamtools$tidy_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_wgsmetrics()`

Read `wgsmetrics` file.

#### Usage

    Bamtools$parse_wgsmetrics(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_wgsmetrics()`

Tidy `wgsmetrics` file.

#### Usage

    Bamtools$tidy_wgsmetrics(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_flagstats()`

Read `flag_counts.tsv` file.

#### Usage

    Bamtools$parse_flagstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_flagstats()`

Tidy `flag_counts.tsv` file.

#### Usage

    Bamtools$tidy_flagstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_coverage()`

Read `coverage.tsv` file.

#### Usage

    Bamtools$parse_coverage(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_coverage()`

Tidy `coverage.tsv` file.

#### Usage

    Bamtools$tidy_coverage(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_fraglength()`

Read `frag_length.tsv` file.

#### Usage

    Bamtools$parse_fraglength(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_fraglength()`

Tidy `frag_length.tsv` file.

#### Usage

    Bamtools$tidy_fraglength(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_partitionstats()`

Read `partition_stats.tsv` file.

#### Usage

    Bamtools$parse_partitionstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_partitionstats()`

Tidy `partition_stats.tsv` file.

#### Usage

    Bamtools$tidy_partitionstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_genecvg()`

Read `gene_coverage.tsv` file.

#### Usage

    Bamtools$parse_genecvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_genecvg()`

Tidy `gene_coverage.tsv` file.

#### Usage

    Bamtools$tidy_genecvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_exoncvg()`

Read `exon_medians.tsv` file.

#### Usage

    Bamtools$parse_exoncvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_exoncvg()`

Tidy `exon_medians.tsv` file.

#### Usage

    Bamtools$tidy_exoncvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Bamtools$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Bamtools
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "bamtools_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "bamtools.*parquet", full.names = FALSE))
#> character(0)
```

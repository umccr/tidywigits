# Isofox Object

Isofox file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Isofox`

## Methods

### Public methods

- [`Isofox$new()`](#method-Isofox-new)

- [`Isofox$parse_summary()`](#method-Isofox-parse_summary)

- [`Isofox$tidy_summary()`](#method-Isofox-tidy_summary)

- [`Isofox$parse_genedata()`](#method-Isofox-parse_genedata)

- [`Isofox$tidy_genedata()`](#method-Isofox-tidy_genedata)

- [`Isofox$parse_transdata()`](#method-Isofox-parse_transdata)

- [`Isofox$tidy_transdata()`](#method-Isofox-tidy_transdata)

- [`Isofox$parse_altsj()`](#method-Isofox-parse_altsj)

- [`Isofox$tidy_altsj()`](#method-Isofox-tidy_altsj)

- [`Isofox$parse_retintron()`](#method-Isofox-parse_retintron)

- [`Isofox$tidy_retintron()`](#method-Isofox-tidy_retintron)

- [`Isofox$parse_fusionsall()`](#method-Isofox-parse_fusionsall)

- [`Isofox$tidy_fusionsall()`](#method-Isofox-tidy_fusionsall)

- [`Isofox$parse_fusionspass()`](#method-Isofox-parse_fusionspass)

- [`Isofox$tidy_fusionspass()`](#method-Isofox-tidy_fusionspass)

- [`Isofox$parse_genecollection()`](#method-Isofox-parse_genecollection)

- [`Isofox$tidy_genecollection()`](#method-Isofox-tidy_genecollection)

- [`Isofox$clone()`](#method-Isofox-clone)

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

Create a new Isofox object.

#### Usage

    Isofox$new(path = NULL, files_tbl = NULL)

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

Read `summary.csv` file.

#### Usage

    Isofox$parse_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_summary()`

Tidy `summary.csv` file.

#### Usage

    Isofox$tidy_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_genedata()`

Read `gene_data.csv` file.

#### Usage

    Isofox$parse_genedata(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_genedata()`

Tidy `gene_data.csv` file.

#### Usage

    Isofox$tidy_genedata(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_transdata()`

Read `transcript_data.csv` file.

#### Usage

    Isofox$parse_transdata(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_transdata()`

Tidy `transcript_data.csv` file.

#### Usage

    Isofox$tidy_transdata(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_altsj()`

Read `alt_splice_junc.csv` file.

#### Usage

    Isofox$parse_altsj(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_altsj()`

Tidy `alt_splice_junc.csv` file.

#### Usage

    Isofox$tidy_altsj(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_retintron()`

Read `retained_intron.csv` file.

#### Usage

    Isofox$parse_retintron(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_retintron()`

Tidy `retained_intron.csv` file.

#### Usage

    Isofox$tidy_retintron(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_fusionsall()`

Read `fusions.csv` file.

#### Usage

    Isofox$parse_fusionsall(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_fusionsall()`

Tidy `fusions.csv` file.

#### Usage

    Isofox$tidy_fusionsall(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_fusionspass()`

Read `pass_fusions.csv` file.

#### Usage

    Isofox$parse_fusionspass(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_fusionspass()`

Tidy `pass_fusions.csv` file.

#### Usage

    Isofox$tidy_fusionspass(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_genecollection()`

Read `gene_collection.csv` file.

#### Usage

    Isofox$parse_genecollection(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_genecollection()`

Tidy `gene_collection.csv` file.

#### Usage

    Isofox$tidy_genecollection(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Isofox$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Isofox
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "isofox_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "parquet", full.names = FALSE))
#> character(0)
#TODO: add isofox test data
```

# Sage Object

Sage file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Sage`

## Methods

### Public methods

- [`Sage$new()`](#method-Sage-new)

- [`Sage$parse_bqrtsv()`](#method-Sage-parse_bqrtsv)

- [`Sage$tidy_bqrtsv()`](#method-Sage-tidy_bqrtsv)

- [`Sage$parse_genecvg()`](#method-Sage-parse_genecvg)

- [`Sage$tidy_genecvg()`](#method-Sage-tidy_genecvg)

- [`Sage$parse_exoncvg()`](#method-Sage-parse_exoncvg)

- [`Sage$tidy_exoncvg()`](#method-Sage-tidy_exoncvg)

- [`Sage$clone()`](#method-Sage-clone)

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

Create a new Sage object.

#### Usage

    Sage$new(path = NULL, files_tbl = NULL)

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

### Method `parse_bqrtsv()`

Read `bqr.tsv` file.

#### Usage

    Sage$parse_bqrtsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_bqrtsv()`

Tidy `bqr.tsv` file.

#### Usage

    Sage$tidy_bqrtsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_genecvg()`

Read `gene.coverage.tsv` file.

#### Usage

    Sage$parse_genecvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_genecvg()`

Tidy `gene.coverage.tsv` file.

#### Usage

    Sage$tidy_genecvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_exoncvg()`

Read `exon.medians.tsv` file.

#### Usage

    Sage$parse_exoncvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_exoncvg()`

Tidy `exon.medians.tsv` file.

#### Usage

    Sage$tidy_exoncvg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Sage$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Sage
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "sage_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "sage.*parquet", full.names = FALSE))
#> character(0)
```

# Lilac Object

Lilac file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Lilac`

## Methods

### Public methods

- [`Lilac$new()`](#method-Lilac-new)

- [`Lilac$parse_summary()`](#method-Lilac-parse_summary)

- [`Lilac$tidy_summary()`](#method-Lilac-tidy_summary)

- [`Lilac$parse_qc()`](#method-Lilac-parse_qc)

- [`Lilac$tidy_qc()`](#method-Lilac-tidy_qc)

- [`Lilac$clone()`](#method-Lilac-clone)

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

Create a new Lilac object.

#### Usage

    Lilac$new(path = NULL, files_tbl = NULL)

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

Read `lilac.tsv` file.

#### Usage

    Lilac$parse_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_summary()`

Tidy `lilac.tsv` file.

#### Usage

    Lilac$tidy_summary(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_qc()`

Read `lilac.qc.tsv` file.

#### Usage

    Lilac$parse_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `lilac.qc.tsv` file.

#### Usage

    Lilac$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Lilac$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Lilac
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "lilac_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "lilac.*parquet", full.names = FALSE))
#> character(0)
```

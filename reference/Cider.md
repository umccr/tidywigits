# Cider Object

Cider file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Cider`

## Methods

### Public methods

- [`Cider$new()`](#method-Cider-new)

- [`Cider$parse_blastn()`](#method-Cider-parse_blastn)

- [`Cider$tidy_blastn()`](#method-Cider-tidy_blastn)

- [`Cider$parse_locstats()`](#method-Cider-parse_locstats)

- [`Cider$tidy_locstats()`](#method-Cider-tidy_locstats)

- [`Cider$parse_vdj()`](#method-Cider-parse_vdj)

- [`Cider$tidy_vdj()`](#method-Cider-tidy_vdj)

- [`Cider$clone()`](#method-Cider-clone)

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

Create a new Cider object.

#### Usage

    Cider$new(path = NULL, files_tbl = NULL)

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

### Method `parse_blastn()`

Read `blastn_match.tsv.gz` file.

#### Usage

    Cider$parse_blastn(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_blastn()`

Tidy `blastn_match.tsv.gz` file.

#### Usage

    Cider$tidy_blastn(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_locstats()`

Read `locus_stats.tsv` file.

#### Usage

    Cider$parse_locstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_locstats()`

Tidy `locus_stats.tsv` file.

#### Usage

    Cider$tidy_locstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_vdj()`

Read `vdj.tsv.gz` file.

#### Usage

    Cider$parse_vdj(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_vdj()`

Tidy `vdj.tsv.gz` file.

#### Usage

    Cider$tidy_vdj(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Cider$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Cider
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "cider_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "cider.*parquet", full.names = FALSE))
#> character(0)
```

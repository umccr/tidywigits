# Cuppa Object

Cuppa file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Cuppa`

## Methods

### Public methods

- [`Cuppa$new()`](#method-Cuppa-new)

- [`Cuppa$parse_datacsv()`](#method-Cuppa-parse_datacsv)

- [`Cuppa$tidy_datacsv()`](#method-Cuppa-tidy_datacsv)

- [`Cuppa$parse_feat()`](#method-Cuppa-parse_feat)

- [`Cuppa$tidy_feat()`](#method-Cuppa-tidy_feat)

- [`Cuppa$parse_predsum()`](#method-Cuppa-parse_predsum)

- [`Cuppa$tidy_predsum()`](#method-Cuppa-tidy_predsum)

- [`Cuppa$parse_datatsv()`](#method-Cuppa-parse_datatsv)

- [`Cuppa$tidy_datatsv()`](#method-Cuppa-tidy_datatsv)

- [`Cuppa$clone()`](#method-Cuppa-clone)

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

Create a new Cuppa object.

#### Usage

    Cuppa$new(path = NULL, files_tbl = NULL)

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

### Method `parse_datacsv()`

Read `cup.data.csv` file.

#### Usage

    Cuppa$parse_datacsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_datacsv()`

Tidy `cup.data.csv` file.

#### Usage

    Cuppa$tidy_datacsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_feat()`

Read `cuppa_data.tsv.gz` file.

#### Usage

    Cuppa$parse_feat(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_feat()`

Tidy `cuppa_data.tsv.gz` file.

#### Usage

    Cuppa$tidy_feat(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_predsum()`

Read `cuppa.pred_summ.tsv` file.

#### Usage

    Cuppa$parse_predsum(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_predsum()`

Tidy `cuppa.pred_summ.tsv` file.

#### Usage

    Cuppa$tidy_predsum(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_datatsv()`

Read `cuppa.vis_data.tsv` file.

#### Usage

    Cuppa$parse_datatsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_datatsv()`

Tidy `cuppa.vis_data.tsv` file.

#### Usage

    Cuppa$tidy_datatsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Cuppa$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Cuppa
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "cuppa_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "cuppa.*parquet", full.names = FALSE))
#> character(0)
```

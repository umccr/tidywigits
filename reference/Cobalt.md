# Cobalt Object

Cobalt file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Cobalt`

## Methods

### Public methods

- [`Cobalt$new()`](#method-Cobalt-new)

- [`Cobalt$parse_gcmed()`](#method-Cobalt-parse_gcmed)

- [`Cobalt$tidy_gcmed()`](#method-Cobalt-tidy_gcmed)

- [`Cobalt$parse_ratiomed()`](#method-Cobalt-parse_ratiomed)

- [`Cobalt$tidy_ratiomed()`](#method-Cobalt-tidy_ratiomed)

- [`Cobalt$parse_ratiotsv()`](#method-Cobalt-parse_ratiotsv)

- [`Cobalt$tidy_ratiotsv()`](#method-Cobalt-tidy_ratiotsv)

- [`Cobalt$parse_ratiopcf()`](#method-Cobalt-parse_ratiopcf)

- [`Cobalt$tidy_ratiopcf()`](#method-Cobalt-tidy_ratiopcf)

- [`Cobalt$parse_version()`](#method-Cobalt-parse_version)

- [`Cobalt$tidy_version()`](#method-Cobalt-tidy_version)

- [`Cobalt$clone()`](#method-Cobalt-clone)

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

Create a new Cobalt object.

#### Usage

    Cobalt$new(path = NULL, files_tbl = NULL)

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

### Method `parse_gcmed()`

Read `gc.median.tsv` file.

#### Usage

    Cobalt$parse_gcmed(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_gcmed()`

Tidy `gc.median.tsv` file.

#### Usage

    Cobalt$tidy_gcmed(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_ratiomed()`

Read `ratio.median.tsv` file.

#### Usage

    Cobalt$parse_ratiomed(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_ratiomed()`

Tidy `ratio.median.tsv` file.

#### Usage

    Cobalt$tidy_ratiomed(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_ratiotsv()`

Read `ratio.tsv` file.

#### Usage

    Cobalt$parse_ratiotsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_ratiotsv()`

Tidy `ratio.tsv` file.

#### Usage

    Cobalt$tidy_ratiotsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_ratiopcf()`

Read `ratio.pcf` file.

#### Usage

    Cobalt$parse_ratiopcf(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_ratiopcf()`

Tidy `ratio.pcf` file.

#### Usage

    Cobalt$tidy_ratiopcf(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_version()`

Read `cobalt.version` file.

#### Usage

    Cobalt$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_version()`

Tidy `cobalt.version` file.

#### Usage

    Cobalt$tidy_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Cobalt$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Cobalt
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "cobalt_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "cobalt.*parquet", full.names = FALSE))
#> character(0)
```

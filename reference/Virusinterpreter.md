# Virusinterpreter Object

Virusinterpreter file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Virusinterpreter`

## Methods

### Public methods

- [`Virusinterpreter$new()`](#method-Virusinterpreter-new)

- [`Virusinterpreter$parse_annotated()`](#method-Virusinterpreter-parse_annotated)

- [`Virusinterpreter$tidy_annotated()`](#method-Virusinterpreter-tidy_annotated)

- [`Virusinterpreter$clone()`](#method-Virusinterpreter-clone)

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

Create a new Virusinterpreter object.

#### Usage

    Virusinterpreter$new(
      path = NULL,
      files_tbl = NULL,
      tidy = TRUE,
      keep_raw = FALSE
    )

#### Arguments

- `path`:

  (`character(1)`)  
  Output directory of tool. If `files_tbl` is supplied, this basically
  gets ignored.

- `files_tbl`:

  (`tibble(n)`)  
  Tibble of files from
  [`nemo::list_files_dir()`](https://umccr.github.io/nemo/reference/list_files_dir.html).

- `tidy`:

  (`logical(1)`)  
  Should the raw parsed tibbles get tidied?

- `keep_raw`:

  (`logical(1)`)  
  Should the raw parsed tibbles be kept in the final output?

------------------------------------------------------------------------

### Method `parse_annotated()`

Read `virus.annotated.tsv` file.

#### Usage

    Virusinterpreter$parse_annotated(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_annotated()`

Tidy `virus.annotated.tsv` file.

#### Usage

    Virusinterpreter$tidy_annotated(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Virusinterpreter$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Virusinterpreter
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "virusinterpreter_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "virusinterpreter.*parquet", full.names = FALSE))
#> character(0)
```

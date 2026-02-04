# Chord Object

Chord file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Chord`

## Methods

### Public methods

- [`Chord$new()`](#method-Chord-new)

- [`Chord$parse_prediction()`](#method-Chord-parse_prediction)

- [`Chord$tidy_prediction()`](#method-Chord-tidy_prediction)

- [`Chord$parse_signatures()`](#method-Chord-parse_signatures)

- [`Chord$tidy_signatures()`](#method-Chord-tidy_signatures)

- [`Chord$clone()`](#method-Chord-clone)

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

Create a new Chord object.

#### Usage

    Chord$new(path = NULL, files_tbl = NULL)

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

### Method `parse_prediction()`

Read `prediction.txt` file.

#### Usage

    Chord$parse_prediction(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_prediction()`

Tidy `prediction.txt` file.

#### Usage

    Chord$tidy_prediction(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_signatures()`

Read `signatures.txt` file.

#### Usage

    Chord$parse_signatures(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_signatures()`

Tidy `signatures.txt` file.

#### Usage

    Chord$tidy_signatures(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Chord$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Chord
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "chord_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "chord.*parquet", full.names = FALSE))
#> character(0)
```

# Peach Object

Peach file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Peach`

## Methods

### Public methods

- [`Peach$new()`](#method-Peach-new)

- [`Peach$parse_events()`](#method-Peach-parse_events)

- [`Peach$tidy_events()`](#method-Peach-tidy_events)

- [`Peach$parse_eventsg()`](#method-Peach-parse_eventsg)

- [`Peach$tidy_eventsg()`](#method-Peach-tidy_eventsg)

- [`Peach$parse_hapall()`](#method-Peach-parse_hapall)

- [`Peach$tidy_hapall()`](#method-Peach-tidy_hapall)

- [`Peach$parse_hapbest()`](#method-Peach-parse_hapbest)

- [`Peach$tidy_hapbest()`](#method-Peach-tidy_hapbest)

- [`Peach$parse_qc()`](#method-Peach-parse_qc)

- [`Peach$tidy_qc()`](#method-Peach-tidy_qc)

- [`Peach$clone()`](#method-Peach-clone)

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

Create a new Peach object.

#### Usage

    Peach$new(path = NULL, files_tbl = NULL)

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

### Method `parse_events()`

Read `events.tsv` file.

#### Usage

    Peach$parse_events(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_events()`

Tidy `events.tsv` file.

#### Usage

    Peach$tidy_events(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_eventsg()`

Read `gene.events.tsv` file.

#### Usage

    Peach$parse_eventsg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_eventsg()`

Tidy `gene.events.tsv` file.

#### Usage

    Peach$tidy_eventsg(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_hapall()`

Read `haplotypes.all.tsv` file.

#### Usage

    Peach$parse_hapall(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_hapall()`

Tidy `haplotypes.all.tsv` file.

#### Usage

    Peach$tidy_hapall(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_hapbest()`

Read `haplotypes.best.tsv` file.

#### Usage

    Peach$parse_hapbest(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_hapbest()`

Tidy `haplotypes.best.tsv` file.

#### Usage

    Peach$tidy_hapbest(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_qc()`

Read `qc.tsv` file.

#### Usage

    Peach$parse_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `qc.tsv` file.

#### Usage

    Peach$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Peach$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Peach
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "peach_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "peach.*parquet", full.names = FALSE))
#> character(0)
```

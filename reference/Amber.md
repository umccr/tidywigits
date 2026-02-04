# Amber Object

Amber file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Amber`

## Methods

### Public methods

- [`Amber$new()`](#method-Amber-new)

- [`Amber$parse_bafpcf()`](#method-Amber-parse_bafpcf)

- [`Amber$tidy_bafpcf()`](#method-Amber-tidy_bafpcf)

- [`Amber$parse_baftsv()`](#method-Amber-parse_baftsv)

- [`Amber$tidy_baftsv()`](#method-Amber-tidy_baftsv)

- [`Amber$parse_contaminationtsv()`](#method-Amber-parse_contaminationtsv)

- [`Amber$tidy_contaminationtsv()`](#method-Amber-tidy_contaminationtsv)

- [`Amber$parse_homozygousregion()`](#method-Amber-parse_homozygousregion)

- [`Amber$tidy_homozygousregion()`](#method-Amber-tidy_homozygousregion)

- [`Amber$parse_qc()`](#method-Amber-parse_qc)

- [`Amber$tidy_qc()`](#method-Amber-tidy_qc)

- [`Amber$parse_version()`](#method-Amber-parse_version)

- [`Amber$tidy_version()`](#method-Amber-tidy_version)

- [`Amber$clone()`](#method-Amber-clone)

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

Create a new Amber object.

#### Usage

    Amber$new(path = NULL, files_tbl = NULL)

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

### Method `parse_bafpcf()`

Read `baf.pcf` file.

#### Usage

    Amber$parse_bafpcf(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_bafpcf()`

Tidy `baf.pcf` file.

#### Usage

    Amber$tidy_bafpcf(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_baftsv()`

Read `baf.tsv.gz` file.

#### Usage

    Amber$parse_baftsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_baftsv()`

Tidy `baf.tsv.gz` file.

#### Usage

    Amber$tidy_baftsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_contaminationtsv()`

Read `contamination.tsv` file.

#### Usage

    Amber$parse_contaminationtsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_contaminationtsv()`

Tidy `contamination.tsv` file.

#### Usage

    Amber$tidy_contaminationtsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_homozygousregion()`

Read `homozygousregion.tsv` file.

#### Usage

    Amber$parse_homozygousregion(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_homozygousregion()`

Tidy `homozygousregion.tsv` file.

#### Usage

    Amber$tidy_homozygousregion(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_qc()`

Read `qc` file.

#### Usage

    Amber$parse_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `qc` file.

#### Usage

    Amber$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_version()`

Read `amber.version` file.

#### Usage

    Amber$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_version()`

Tidy `amber.version` file.

#### Usage

    Amber$tidy_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Amber$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Amber
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "amber_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "amber.*parquet", full.names = FALSE))
#> character(0)
```

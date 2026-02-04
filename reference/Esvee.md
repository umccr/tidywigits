# Esvee Object

Esvee file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Esvee`

## Methods

### Public methods

- [`Esvee$new()`](#method-Esvee-new)

- [`Esvee$parse_prepfraglen()`](#method-Esvee-parse_prepfraglen)

- [`Esvee$tidy_prepfraglen()`](#method-Esvee-tidy_prepfraglen)

- [`Esvee$parse_prepdiscstats()`](#method-Esvee-parse_prepdiscstats)

- [`Esvee$tidy_prepdiscstats()`](#method-Esvee-tidy_prepdiscstats)

- [`Esvee$parse_prepjunction()`](#method-Esvee-parse_prepjunction)

- [`Esvee$tidy_prepjunction()`](#method-Esvee-tidy_prepjunction)

- [`Esvee$parse_assemblephased()`](#method-Esvee-parse_assemblephased)

- [`Esvee$tidy_assemblephased()`](#method-Esvee-tidy_assemblephased)

- [`Esvee$parse_assembleassembly()`](#method-Esvee-parse_assembleassembly)

- [`Esvee$tidy_assembleassembly()`](#method-Esvee-tidy_assembleassembly)

- [`Esvee$parse_assemblebreakend()`](#method-Esvee-parse_assemblebreakend)

- [`Esvee$tidy_assemblebreakend()`](#method-Esvee-tidy_assemblebreakend)

- [`Esvee$parse_assemblealignment()`](#method-Esvee-parse_assemblealignment)

- [`Esvee$tidy_assemblealignment()`](#method-Esvee-tidy_assemblealignment)

- [`Esvee$clone()`](#method-Esvee-clone)

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

Create a new Esvee object.

#### Usage

    Esvee$new(path = NULL, files_tbl = NULL)

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

### Method `parse_prepfraglen()`

Read `prep.fragment_length.tsv` file.

#### Usage

    Esvee$parse_prepfraglen(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_prepfraglen()`

Tidy `prep.fragment_length.tsv` file.

#### Usage

    Esvee$tidy_prepfraglen(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_prepdiscstats()`

Read `prep.disc_stats.tsv` file.

#### Usage

    Esvee$parse_prepdiscstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_prepdiscstats()`

Tidy `prep.disc_stats.tsv` file.

#### Usage

    Esvee$tidy_prepdiscstats(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_prepjunction()`

Read `prep.junction.tsv` file.

#### Usage

    Esvee$parse_prepjunction(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_prepjunction()`

Tidy `prep.junction.tsv` file.

#### Usage

    Esvee$tidy_prepjunction(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_assemblephased()`

Read `esvee.phased_assembly.tsv` file.

#### Usage

    Esvee$parse_assemblephased(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_assemblephased()`

Tidy `esvee.phased_assembly.tsv` file.

#### Usage

    Esvee$tidy_assemblephased(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_assembleassembly()`

Read `esvee.assembly.tsv` file.

#### Usage

    Esvee$parse_assembleassembly(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_assembleassembly()`

Tidy `esvee.assembly.tsv` file.

#### Usage

    Esvee$tidy_assembleassembly(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_assemblebreakend()`

Read `breakend.tsv` file.

#### Usage

    Esvee$parse_assemblebreakend(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_assemblebreakend()`

Tidy `breakend.tsv` file.

#### Usage

    Esvee$tidy_assemblebreakend(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_assemblealignment()`

Read `alignment.tsv` file.

#### Usage

    Esvee$parse_assemblealignment(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_assemblealignment()`

Tidy `alignment.tsv` file.

#### Usage

    Esvee$tidy_assemblealignment(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Esvee$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Esvee
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "esvee_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "cobalt.*parquet", full.names = FALSE))
#> character(0)
#TODO: add esvee test data
```

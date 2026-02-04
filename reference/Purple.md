# Purple Object

Purple file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Purple`

## Methods

### Public methods

- [`Purple$new()`](#method-Purple-new)

- [`Purple$list_files()`](#method-Purple-list_files)

- [`Purple$parse_qc()`](#method-Purple-parse_qc)

- [`Purple$tidy_qc()`](#method-Purple-tidy_qc)

- [`Purple$parse_cnvgenetsv()`](#method-Purple-parse_cnvgenetsv)

- [`Purple$tidy_cnvgenetsv()`](#method-Purple-tidy_cnvgenetsv)

- [`Purple$parse_cnvsomtsv()`](#method-Purple-parse_cnvsomtsv)

- [`Purple$tidy_cnvsomtsv()`](#method-Purple-tidy_cnvsomtsv)

- [`Purple$parse_drivercatalog()`](#method-Purple-parse_drivercatalog)

- [`Purple$tidy_drivercatalog()`](#method-Purple-tidy_drivercatalog)

- [`Purple$parse_germdeltsv()`](#method-Purple-parse_germdeltsv)

- [`Purple$tidy_germdeltsv()`](#method-Purple-tidy_germdeltsv)

- [`Purple$parse_purityrange()`](#method-Purple-parse_purityrange)

- [`Purple$tidy_purityrange()`](#method-Purple-tidy_purityrange)

- [`Purple$parse_puritytsv()`](#method-Purple-parse_puritytsv)

- [`Purple$tidy_puritytsv()`](#method-Purple-tidy_puritytsv)

- [`Purple$parse_somclonality()`](#method-Purple-parse_somclonality)

- [`Purple$tidy_somclonality()`](#method-Purple-tidy_somclonality)

- [`Purple$parse_somhist()`](#method-Purple-parse_somhist)

- [`Purple$tidy_somhist()`](#method-Purple-tidy_somhist)

- [`Purple$parse_version()`](#method-Purple-parse_version)

- [`Purple$tidy_version()`](#method-Purple-tidy_version)

- [`Purple$clone()`](#method-Purple-clone)

Inherited methods

- [`nemo::Tool$.eval_func()`](https://umccr.github.io/nemo/reference/Tool.html#method-.eval_func)
- [`nemo::Tool$.parse_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file)
- [`nemo::Tool$.parse_file_keyvalue()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_keyvalue)
- [`nemo::Tool$.parse_file_nohead()`](https://umccr.github.io/nemo/reference/Tool.html#method-.parse_file_nohead)
- [`nemo::Tool$.tidy_file()`](https://umccr.github.io/nemo/reference/Tool.html#method-.tidy_file)
- [`nemo::Tool$filter_files()`](https://umccr.github.io/nemo/reference/Tool.html#method-filter_files)
- [`nemo::Tool$nemofy()`](https://umccr.github.io/nemo/reference/Tool.html#method-nemofy)
- [`nemo::Tool$print()`](https://umccr.github.io/nemo/reference/Tool.html#method-print)
- [`nemo::Tool$tidy()`](https://umccr.github.io/nemo/reference/Tool.html#method-tidy)
- [`nemo::Tool$write()`](https://umccr.github.io/nemo/reference/Tool.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Purple object.

#### Usage

    Purple$new(path = NULL, files_tbl = NULL)

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

### Method `list_files()`

List files in given purple directory. Overwrites parent class to handle
germline driver.catalog files.

#### Usage

    Purple$list_files(type = "file")

#### Arguments

- `type`:

  (`character(1)`)  
  File type(s) to return (e.g. any, file, directory, symlink). See
  [`fs::dir_info`](https://fs.r-lib.org/reference/dir_ls.html).

#### Returns

A tibble of file paths.

------------------------------------------------------------------------

### Method `parse_qc()`

Read `purple.qc` file.

#### Usage

    Purple$parse_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_qc()`

Tidy `purple.qc` file.

#### Usage

    Purple$tidy_qc(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_cnvgenetsv()`

Read `purple.cnv.gene.tsv` file.

#### Usage

    Purple$parse_cnvgenetsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_cnvgenetsv()`

Tidy `purple.cnv.gene.tsv` file.

#### Usage

    Purple$tidy_cnvgenetsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_cnvsomtsv()`

Read `purple.cnv.somatic.tsv` file.

#### Usage

    Purple$parse_cnvsomtsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_cnvsomtsv()`

Tidy `purple.cnv.somatic.tsv` file.

#### Usage

    Purple$tidy_cnvsomtsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_drivercatalog()`

Read `purple.driver.catalog.germline|somatic.tsv` file.

#### Usage

    Purple$parse_drivercatalog(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_drivercatalog()`

Tidy `purple.driver.catalog.germline|somatic.tsv` file.

#### Usage

    Purple$tidy_drivercatalog(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_germdeltsv()`

Read `purple.germline.deletion.tsv` file.

#### Usage

    Purple$parse_germdeltsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_germdeltsv()`

Tidy `purple.germline.deletion.tsv` file.

#### Usage

    Purple$tidy_germdeltsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_purityrange()`

Read `purple.purity.range.tsv` file.

#### Usage

    Purple$parse_purityrange(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_purityrange()`

Tidy `purple.purity.range.tsv` file.

#### Usage

    Purple$tidy_purityrange(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_puritytsv()`

Read `purple.purity.tsv` file.

#### Usage

    Purple$parse_puritytsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_puritytsv()`

Tidy `purple.purity.tsv` file.

#### Usage

    Purple$tidy_puritytsv(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_somclonality()`

Read `purple.somatic.clonality.tsv` file.

#### Usage

    Purple$parse_somclonality(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_somclonality()`

Tidy `purple.somatic.clonality.tsv` file.

#### Usage

    Purple$tidy_somclonality(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_somhist()`

Read `purple.somatic.hist.tsv` file.

#### Usage

    Purple$parse_somhist(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_somhist()`

Tidy `purple.somatic.hist.tsv` file.

#### Usage

    Purple$tidy_somhist(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_version()`

Read `purple.version` file.

#### Usage

    Purple$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_version()`

Tidy `purple.version` file.

#### Usage

    Purple$tidy_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Purple$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Purple
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "purple_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "purple.*parquet", full.names = FALSE))
#> character(0)
```

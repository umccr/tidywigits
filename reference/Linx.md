# Linx Object

Linx file parsing and manipulation.

## Super class

[`nemo::Tool`](https://umccr.github.io/nemo/reference/Tool.html) -\>
`Linx`

## Methods

### Public methods

- [`Linx$new()`](#method-Linx-new)

- [`Linx$list_files()`](#method-Linx-list_files)

- [`Linx$parse_breakends()`](#method-Linx-parse_breakends)

- [`Linx$tidy_breakends()`](#method-Linx-tidy_breakends)

- [`Linx$parse_clusters()`](#method-Linx-parse_clusters)

- [`Linx$tidy_clusters()`](#method-Linx-tidy_clusters)

- [`Linx$parse_drivercatalog()`](#method-Linx-parse_drivercatalog)

- [`Linx$tidy_drivercatalog()`](#method-Linx-tidy_drivercatalog)

- [`Linx$parse_drivers()`](#method-Linx-parse_drivers)

- [`Linx$tidy_drivers()`](#method-Linx-tidy_drivers)

- [`Linx$parse_fusions()`](#method-Linx-parse_fusions)

- [`Linx$tidy_fusions()`](#method-Linx-tidy_fusions)

- [`Linx$parse_links()`](#method-Linx-parse_links)

- [`Linx$tidy_links()`](#method-Linx-tidy_links)

- [`Linx$parse_neoepitope()`](#method-Linx-parse_neoepitope)

- [`Linx$tidy_neoepitope()`](#method-Linx-tidy_neoepitope)

- [`Linx$parse_svs()`](#method-Linx-parse_svs)

- [`Linx$tidy_svs()`](#method-Linx-tidy_svs)

- [`Linx$parse_viscn()`](#method-Linx-parse_viscn)

- [`Linx$tidy_viscn()`](#method-Linx-tidy_viscn)

- [`Linx$parse_visfusion()`](#method-Linx-parse_visfusion)

- [`Linx$tidy_visfusion()`](#method-Linx-tidy_visfusion)

- [`Linx$parse_visgeneexon()`](#method-Linx-parse_visgeneexon)

- [`Linx$tidy_visgeneexon()`](#method-Linx-tidy_visgeneexon)

- [`Linx$parse_visproteindomain()`](#method-Linx-parse_visproteindomain)

- [`Linx$tidy_visproteindomain()`](#method-Linx-tidy_visproteindomain)

- [`Linx$parse_vissegments()`](#method-Linx-parse_vissegments)

- [`Linx$tidy_vissegments()`](#method-Linx-tidy_vissegments)

- [`Linx$parse_vissvdata()`](#method-Linx-parse_vissvdata)

- [`Linx$tidy_vissvdata()`](#method-Linx-tidy_vissvdata)

- [`Linx$parse_version()`](#method-Linx-parse_version)

- [`Linx$tidy_version()`](#method-Linx-tidy_version)

- [`Linx$clone()`](#method-Linx-clone)

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

Create a new Linx object.

#### Usage

    Linx$new(path = NULL, files_tbl = NULL)

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

List files in given linx directory. Overwrites parent class to handle
germline LINX files.

#### Usage

    Linx$list_files(type = "file")

#### Arguments

- `type`:

  (`character(1)`)  
  File type(s) to return (e.g. any, file, directory, symlink). See
  [`fs::dir_info`](https://fs.r-lib.org/reference/dir_ls.html).

#### Returns

A tibble of file paths.

------------------------------------------------------------------------

### Method `parse_breakends()`

Read `breakend.tsv` file.

#### Usage

    Linx$parse_breakends(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_breakends()`

Tidy `breakend.tsv` file.

#### Usage

    Linx$tidy_breakends(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_clusters()`

Read `clusters.tsv` file.

#### Usage

    Linx$parse_clusters(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_clusters()`

Tidy `clusters.tsv` file.

#### Usage

    Linx$tidy_clusters(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_drivercatalog()`

Read `linx.driver.catalog.tsv` file.

#### Usage

    Linx$parse_drivercatalog(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_drivercatalog()`

Tidy `linx.driver.catalog.tsv` file.

#### Usage

    Linx$tidy_drivercatalog(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_drivers()`

Read `linx.drivers.tsv` file.

#### Usage

    Linx$parse_drivers(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_drivers()`

Tidy `linx.drivers.tsv` file.

#### Usage

    Linx$tidy_drivers(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_fusions()`

Read `linx.fusion.tsv` file.

#### Usage

    Linx$parse_fusions(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_fusions()`

Tidy `linx.fusion.tsv` file.

#### Usage

    Linx$tidy_fusions(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_links()`

Read `links.tsv` file.

#### Usage

    Linx$parse_links(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_links()`

Tidy `links.tsv` file.

#### Usage

    Linx$tidy_links(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_neoepitope()`

Read `neoepitope.tsv` file.

#### Usage

    Linx$parse_neoepitope(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_neoepitope()`

Tidy `neoepitope.tsv` file.

#### Usage

    Linx$tidy_neoepitope(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_svs()`

Read `svs.tsv` file.

#### Usage

    Linx$parse_svs(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_svs()`

Tidy `svs.tsv` file.

#### Usage

    Linx$tidy_svs(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_viscn()`

Read `linx.vis_copy_number.tsv` file.

#### Usage

    Linx$parse_viscn(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_viscn()`

Tidy `linx.vis_copy_number.tsv` file.

#### Usage

    Linx$tidy_viscn(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_visfusion()`

Read `linx.vis_fusion.tsv` file.

#### Usage

    Linx$parse_visfusion(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_visfusion()`

Tidy `linx.vis_fusion.tsv` file.

#### Usage

    Linx$tidy_visfusion(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_visgeneexon()`

Read `linx.vis_gene_exon.tsv` file.

#### Usage

    Linx$parse_visgeneexon(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_visgeneexon()`

Tidy `linx.vis_gene_exon.tsv` file.

#### Usage

    Linx$tidy_visgeneexon(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_visproteindomain()`

Read `linx.vis_protein_domain.tsv` file.

#### Usage

    Linx$parse_visproteindomain(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_visproteindomain()`

Tidy `linx.vis_protein_domain.tsv` file.

#### Usage

    Linx$tidy_visproteindomain(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_vissegments()`

Read `linx.vis_segments.tsv` file.

#### Usage

    Linx$parse_vissegments(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_vissegments()`

Tidy `linx.vis_segments.tsv` file.

#### Usage

    Linx$tidy_vissegments(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_vissvdata()`

Read `linx.vis_sv_data.tsv` file.

#### Usage

    Linx$parse_vissvdata(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_vissvdata()`

Tidy `linx.vis_sv_data.tsv` file.

#### Usage

    Linx$tidy_vissvdata(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `parse_version()`

Read `linx.version` file.

#### Usage

    Linx$parse_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `tidy_version()`

Tidy `linx.version` file.

#### Usage

    Linx$tidy_version(x)

#### Arguments

- `x`:

  (`character(1)`)  
  Path to file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Linx$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
cls <- Linx
indir <- system.file("extdata/oa", package = "tidywigits")
odir <- tempdir()
id <- "linx_run1"
obj <- cls$new(indir)
obj$nemofy(diro = odir, format = "parquet", input_id = id)
#> NULL
(lf <- list.files(odir, pattern = "linx.*parquet", full.names = FALSE))
#> character(0)
```

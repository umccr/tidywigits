# Wigits Object

WiGiTS file parsing and manipulation.

## Super class

[`nemo::Workflow`](https://umccr.github.io/nemo/reference/Workflow.html)
-\> `Wigits`

## Methods

### Public methods

- [`Wigits$new()`](#method-Wigits-new)

- [`Wigits$get_metadata()`](#method-Wigits-get_metadata)

- [`Wigits$clone()`](#method-Wigits-clone)

Inherited methods

- [`nemo::Workflow$filter_files()`](https://umccr.github.io/nemo/reference/Workflow.html#method-filter_files)
- [`nemo::Workflow$get_raw_schemas_all()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_raw_schemas_all)
- [`nemo::Workflow$get_tbls()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_tbls)
- [`nemo::Workflow$get_tidy_schemas_all()`](https://umccr.github.io/nemo/reference/Workflow.html#method-get_tidy_schemas_all)
- [`nemo::Workflow$list_files()`](https://umccr.github.io/nemo/reference/Workflow.html#method-list_files)
- [`nemo::Workflow$nemofy()`](https://umccr.github.io/nemo/reference/Workflow.html#method-nemofy)
- [`nemo::Workflow$print()`](https://umccr.github.io/nemo/reference/Workflow.html#method-print)
- [`nemo::Workflow$tidy()`](https://umccr.github.io/nemo/reference/Workflow.html#method-tidy)
- [`nemo::Workflow$write()`](https://umccr.github.io/nemo/reference/Workflow.html#method-write)

------------------------------------------------------------------------

### Method `new()`

Create a new Wigits object.

#### Usage

    Wigits$new(path = NULL)

#### Arguments

- `path`:

  (`character(n)`)  
  Path(s) to Wigits results.

------------------------------------------------------------------------

### Method `get_metadata()`

Get metadata. Overwrites parent class to handle tidywigits not being a
dependency of nemo (see tidywigits issue 167)

#### Usage

    Wigits$get_metadata(
      input_id,
      output_id,
      output_dir,
      pkgs = c("nemo", "tidywigits")
    )

#### Arguments

- `input_id`:

  (`character(1)`)  
  Input ID to use for the dataset (e.g. `run123`).

- `output_id`:

  (`character(1)`)  
  Output ID to use for the dataset (e.g. `run123`).

- `output_dir`:

  (`character(1)`)  
  Output directory.

- `pkgs`:

  (`character(n)`)  
  Which R packages to extract versions for.

#### Returns

List with metadata

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Wigits$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
if (FALSE) { # \dontrun{
path <- here::here("nogit/oa_v2")
w <- Wigits$new(path)
x <-
  w$nemofy(
    diro = "nogit/test_data",
    format = "parquet",
    input_id = "run1"
)
dbconn <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  dbname = "nemo",
  user = "orcabus"
)
x <-
  w$nemofy(
    format = "db",
    input_id = "runABC456",
    dbconn = dbconn
)
DBI::dbDisconnect(dbconn)
} # }
```

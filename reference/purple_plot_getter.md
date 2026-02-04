# Retrieve PURPLE Plots

Retrieve PURPLE Plots

## Usage

``` r
purple_plot_getter(x, cp_dir = NULL)
```

## Arguments

- x:

  (`character(1)`)  
  Path to recursively look for PURPLE plots.

- cp_dir:

  (`character(1)`)  
  If provided, copies the plots from `x` into `cp_dir` for use in
  reports, and adds a 'copied' boolean column at the end.

## Value

Tibble with plot alias, basename, path, size, title and description.

## Examples

``` r
x <- tempdir()
cp_dir <- file.path(tempdir(), "cpdir")
file.create(file.path(x, paste0("sample1.", c("circos", "copynumber", "map"), ".png")))
#> [1] TRUE TRUE TRUE
(d1 <- purple_plot_getter(x))
#> # A tibble: 3 × 6
#>   alias                  bname                  path      size title description
#>   <chr>                  <chr>                  <chr>    <fs:> <chr> <chr>      
#> 1 circos_snv_indel_cn_sv sample1.circos.png     /tmp/Rt…     0 Circ… "A. Chromo…
#> 2 cn_distro              sample1.copynumber.png /tmp/Rt…     0 Copy… "AMBER BAF…
#> 3 map_distro             sample1.map.png        /tmp/Rt…     0 Mino… "AMBER BAF…
(d2 <- purple_plot_getter(x, cp_dir))
#> # A tibble: 3 × 7
#>   alias                  bname              path   size title description copied
#>   <chr>                  <chr>              <chr> <fs:> <chr> <chr>       <lgl> 
#> 1 circos_snv_indel_cn_sv sample1.circos.png /tmp…     0 Circ… "A. Chromo… TRUE  
#> 2 cn_distro              sample1.copynumbe… /tmp…     0 Copy… "AMBER BAF… TRUE  
#> 3 map_distro             sample1.map.png    /tmp…     0 Mino… "AMBER BAF… TRUE  
```

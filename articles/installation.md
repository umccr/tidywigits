# Installation

There are several ways to install {tidywigits}:

### R

Using {remotes} directly from GitHub:

``` r
install.packages("remotes")
remotes::install_github("umccr/tidywigits") # latest main commit
remotes::install_github("umccr/tidywigits@v0.0.5.9001") # released version
```

### Conda

[![conda-version](https://anaconda.org/umccr/r-tidywigits/badges/version.svg "Conda package version")![conda-latest](https://anaconda.org/umccr/r-tidywigits/badges/latest_release_date.svg "Conda package latest release date")](https://anaconda.org/umccr/r-tidywigits)

The conda package is available from the umccr channel at
<https://anaconda.org/umccr/r-tidywigits>.

``` bash
conda create \
  -n tidywigits_env \
  -c umccr -c conda-forge \
  r-tidywigits==0.0.5.9001

conda activate tidywigits_env
```

### Docker

[![ghcr-tags](https://ghcr-badge.egpl.dev/umccr/tidywigits/tags.png "GHCR tags")![ghcr-latest](https://ghcr-badge.egpl.dev/umccr/tidywigits/latest_tag.png "GHCR latest tag")![ghcr-size](https://ghcr-badge.egpl.dev/umccr/tidywigits/size?tag=0.0.5.9001 "GHCR image size")](https://github.com/umccr/tidywigits/pkgs/container/tidywigits)

The Docker image is available from the GitHub Container Registry at
<https://github.com/umccr/tidywigits/pkgs/container/tidywigits>.

``` bash
docker pull --platform linux/amd64 ghcr.io/umccr/tidywigits:0.0.5.9001
```

### Pixi

If you use [Pixi](https://pixi.sh/), you can create a new isolated
environment with the deployed conda package:

``` bash
pixi init -c umccr -c conda-forge ./tidy_env
cd ./tidy_env
pixi add r-tidywigits==0.0.5.9001
```

Then you can create a task to run the `tidywigits.R` CLI script:

``` bash
pixi task add tw "tidywigits.R"
pixi run tw --help
```

Or activate the environment and use tidywigits directly in an R
environment:

``` bash
pixi shell
R
```

``` r
library(tidywigits)
```

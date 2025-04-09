

<!-- README.md is generated from README.qmd. Please edit that file -->

# 🧬✨ tidywigits

- Docs: <https://umccr.github.io/tidywigits/>

## 🍕 Installation

### R

``` r
remotes::install_github("umccr/tidywigits")
```

### Conda

#### Linux & MacOS (non-M1)

``` bash
conda create \
  -n tidywigits_env \
  -c umccr -c bioconda -c conda-forge \
  r-tidywigits==X.X.X

conda activate tidywigits_env
```

#### MacOS M1

``` bash
CONDA_SUBDIR=osx-64 \
  conda create \
  -n tidywigits_env \
  -c umccr -c bioconda -c conda-forge \
  r-tidywigits==X.X.X

conda activate tidywigits_env
```

### Docker

``` bash
docker pull --platform linux/amd64 ghcr.io/umccr/tidywigits:X.X.X
```

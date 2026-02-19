# adapted from
# https://github.com/hartwigmedical/hmftools/blob/5a5ce0/cuppa/src/main/python/pycuppa/cuppa/visualization/plot_predictions.R
options(max.print = 500)
options(stringsAsFactors = FALSE)
{
  use("ggplot2")
  use("ggh4x")
  use("stringr")
  use("patchwork")
  use("here", "here")
  use("glue", "glue")
}

## Args ================================

VIS_DATA_PATH <- "~/s3/project-data-491085415398-ap-southeast-2/byob-icav2/project-tothill-main/cuppa/analysis/oncoanalyser-wgts-both/20251121f6d4c349/L2500965__L2500964__L2500971/cuppa/L2500965.cuppa.vis_data.tsv"
PLOT_PATH <- "nogit/cuppa_plot_test2.pdf"


## Load data + funcs ================================
VIS_DATA <- read.delim(VIS_DATA_PATH)
source(here("inst/scripts/cuppa/funcs.R"))
d0 <- VIS_DATA
d0$cancer_supertype <- CANCER_TYPE_METADATA[d0$cancer_type, "supertype"]
d0$cancer_type <- factor(d0$cancer_type, rownames(CANCER_TYPE_METADATA))

# for playing with probs/sigs/features
libid <- "L2500965"
plot_data <- d0 |>
  dplyr::filter(.data$sample_id == libid | .data$data_type == "cv_performance") |>
  dplyr::filter(.data$data_type == "feat_contrib")

write_plots(d0, PLOT_PATH)

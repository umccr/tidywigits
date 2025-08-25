#' @importFrom glue glue
#' @importFrom rlang .data !!! %||%
#' @importFrom R6 R6Class
#' @importFrom nemo Workflow Tool Config
#' @keywords internal
"_PACKAGE"

#' @noRd
dummy1 <- function() {
  # Solves R CMD check: Namespaces in Imports field not imported from
  argparse::ArgumentParser
  assertthat::assert_that
  dplyr::filter
  readr::read_tsv
  tibble::tibble
  tidyr::unnest
}

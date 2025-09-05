#' @importFrom glue glue
#' @importFrom rlang .data !!! %||%
#' @importFrom R6 R6Class
#' @importFrom nemo Workflow Tool Config
#' @keywords internal
"_PACKAGE"

#' @noRd
dummy1 <- function() {
  # Solves R CMD check: Namespaces in Imports field not imported from
  # most are in R6 classes and thus not detected by R CMD check
  dplyr::filter
  readr::read_tsv
  tibble::tibble
  tidyr::unnest
}

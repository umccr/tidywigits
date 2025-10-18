#' @export
gt_tab <- function(d) {
  tab1 <- d |>
    dplyr::filter(.data$filter == "PASS") |>
    gt::gt() |>
    gt::fmt_number(decimals = 0)
  tab2 <- d |>
    dplyr::mutate(size = .data$pos_end - .data$pos_start + 1) |>
    dplyr::group_by(filter) |>
    dplyr::summarise(
      tot_segs = dplyr::n(),
      avg_size = mean(.data$size),
      median_size = stats::median(.data$size)
    ) |>
    gt::gt() |>
    gt::fmt_number(decimals = 0)
  list(tab1 = tab1, tab2 = tab2)
}

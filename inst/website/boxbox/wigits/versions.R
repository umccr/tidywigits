#' @export
tab_prep <- function(x) {
  stopifnot(is.data.frame(x), all(c("tidy", "parser", "tool_parser") %in% names(x)))
  x |>
    dplyr::filter(.data$parser == "version") |>
    tidyr::unnest("tidy") |>
    tidyr::unnest("data") |>
    dplyr::mutate(tool = sub("_version$", "", .data$tool_parser) |> toupper()) |>
    dplyr::select("tool", "version", "date_build") |>
    dplyr::distinct() |>
    dplyr::arrange(.data$tool)
}

#' @export
gt_tab <- function(x, id = "versions") {
  box::use(./table[down_button])
  down <- down_button(x, id)
  gt::gt(x) |>
    gt::cols_label(tool = "Tool", version = "Version", date_build = "Build Date") |>
    gt::tab_style(
      style = list(gt::cell_text(weight = "bold")),
      locations = list(gt::cells_body(columns = c("tool")))
    ) |>
    gt::cols_align("left") |>
    gt::tab_options(
      table.width = gt::pct(50),
      table.align = "left"
    ) |>
    gt::opt_stylize(style = 1, color = "gray") |>
    gt::tab_source_note(down)
}

#' @export
cat_plot <- function(p, x, group = "gallery1") {
  dat <- p |>
    dplyr::filter(.data$alias == x) |>
    dplyr::mutate(
      md = glue::glue(
        "![<<.data$title>>](<<.data$path>>)",
        "{group='<<group>>' ",
        "description='<<.data$description>>' ",
        # "height=<<height>>",
        "}\n\n\n",
        .open = "<<",
        .close = ">>"
      )
    )
  stopifnot(nrow(dat) == 1)
  cat(dat$md)
}

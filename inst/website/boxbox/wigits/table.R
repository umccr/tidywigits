#' @export
down_button <- function(d, nm) {
  downloadthis::download_this(
    .data = d,
    output_name = nm,
    output_extension = ".csv",
    button_label = "CSV Download",
    button_type = "primary"
  )
}

#' @export
view_tbl <- function(x, pagination = FALSE, ...) {
  reactable::reactable(
    x,
    sortable = TRUE,
    searchable = TRUE,
    pagination = pagination,
    paginationType = "jump",
    filterable = TRUE,
    striped = TRUE,
    highlight = TRUE,
    bordered = TRUE,
    showSortable = TRUE,
    showPageSizeOptions = TRUE,
    showPagination = TRUE,
    theme = reactable::reactableTheme(
      borderColor = "#dfe2e5",
      stripedColor = "#f8f9fa",
      highlightColor = "#f0f5ff",
      cellPadding = "12px 15px"
    ),
    ...
  )
}

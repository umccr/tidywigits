#' @export
down_button <- function(d, nm) {
  downloadthis::download_this(
    .data = d,
    output_name = nm,
    output_extension = ".csv",
    button_label = "CSV Download",
    button_type = "primary",
    icon = "fa fa-download"
  )
}

#' @export
reactable_wrap <- function(x, pagination = FALSE, id, ...) {
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
    showPageSizeOptions = TRUE,
    showPagination = TRUE,
    elementId = id,
    theme = reactable::reactableTheme(
      borderColor = "#dfe2e5",
      stripedColor = "#f8f9fa",
      highlightColor = "#f0f5ff",
      cellPadding = "12px 15px"
    ),
    ...
  )
}

#' @export
reactable_wrapdown <- function(x, descriptions, id = "table", ...) {
  stopifnot(all(c("field", "description") == colnames(descriptions)))
  field2desc <- tibble::deframe(descriptions)

  # column formatting and tooltips
  col_defs <- colnames(x) |>
    purrr::map(function(col_name) {
      col_def <- reactable::colDef(
        name = gsub("_", " ", col_name),
        header = function(value) {
          # header tooltip
          tooltip_text <- field2desc[[col_name]]
          if (!is.null(tooltip_text)) {
            htmltools::div(title = tooltip_text, style = "cursor: help;", value)
          } else {
            value
          }
        }
      )

      # numeric formatting
      if (is.numeric(x[[col_name]])) {
        col_def$format <- reactable::colFormat(separators = TRUE, digits = 2)
      }
      col_def
    })
  names(col_defs) <- names(x)
  table <- reactable_wrap(x, columns = col_defs, id = id, ...)

  dbutton <- htmltools::tags$button(
    htmltools::tagList(fontawesome::fa("download"), "CSV Download"),
    class = "btn btn-primary",
    onclick = sprintf("Reactable.downloadDataCSV('%s', '%s.csv')", id, id),
    style = "margin-top: 10px; margin-bottom: 5px;"
  )

  htmltools::browsable(
    htmltools::tagList(
      dbutton,
      table
    )
  )
}

#' @export
down_button <- function(d, nm) {
  downloadthis::download_this(
    .data = d,
    output_name = nm,
    output_extension = ".csv",
    button_label = "CSV Download",
    button_type = "default",
    has_icon = TRUE,
    icon = "fa fa-save"
  )
}

#' @export
reactable_wrap <- function(x, pagination = FALSE, id, ...) {
  reactable::reactable(
    x,
    defaultColDef = reactable::colDef(
      format = reactable::colFormat(separators = TRUE),
      minWidth = 70
    ),
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
    resizable = TRUE,
    theme = reactable::reactableTheme(
      borderColor = "#dfe2e5",
      stripedColor = "#f8f9fa",
      highlightColor = "#f0f5ff",
      style = list(
        fontFamily = "Monaco",
        fontSize = "12px"
      )
    ),
    ...
  )
}

#' @export
reactable_wrapdown <- function(x, descriptions, id = "table", ...) {
  box::use(./table)
  stopifnot(all(c("field", "description") == colnames(descriptions)))
  field2desc <- tibble::deframe(descriptions)

  # note that tippy has been deprecated...
  with_tooltip <- function(value, tooltip, ...) {
    htmltools::div(
      style = "cursor: help",
      tippy::tippy(value, tooltip, ...)
    )
  }
  # column formatting and tooltips
  col_defs <- colnames(x) |>
    purrr::map(function(col_name) {
      col_def <- reactable::colDef(
        name = gsub("_", " ", col_name),
        header = function(value) {
          # header tooltip
          tooltip_text <- field2desc[[col_name]]
          if (!is.null(tooltip_text)) {
            with_tooltip(value, tooltip_text, placement = "bottom", theme = "light")
          } else {
            value
          }
        }
      )
      col_def
    })
  names(col_defs) <- names(x)
  table <- table$reactable_wrap(x, columns = col_defs, id = id, ...)

  dbutton <- htmltools::tags$button(
    htmltools::tagList(fontawesome::fa("download"), "CSV Download"),
    class = "btn btn-secondary btn-sm",
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

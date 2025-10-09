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

#' @export
gt_tab <- function(x, id) {
  box::use(./table)
  down <- table$down_button(x, id)
  gt::gt(x) |>
    gt::cols_label(value = "Value", description = "Description") |>
    # not needed
    gt::cols_hide(columns = c("fill_colour", "description")) |>
    # value colour fill
    gt::tab_style(
      style = gt::cell_fill(color = gt::from_column("fill_colour")),
      locations = gt::cells_body(columns = "value")
    ) |>
    # field name with hover description
    gt::fmt(
      columns = field,
      fns = function(y) {
        desc <- x$description[match(y, x$field)]
        sprintf(
          '<span title="%s" style="cursor: help;">%s</span>',
          desc,
          y
        )
      }
    ) |>
    # bold field and value text
    gt::tab_style(
      style = list(gt::cell_text(weight = "bold")),
      locations = list(gt::cells_body(columns = c("field", "value")))
    ) |>
    gt::cols_align("left") |>
    # gt::cols_width(
    #   field ~ gt::pct(50),
    #   description ~ gt::pct(50)
    # ) |>
    gt::tab_options(
      table.width = gt::pct(50),
      table.align = "left",
      column_labels.hidden = TRUE
    ) |>
    gt::opt_stylize(style = 1, color = "gray") |>
    gt::tab_source_note(down)
}

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

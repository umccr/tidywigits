require(shiny)
require(tibble, include.only = "as_tibble")
require(dplyr)
require(DBI, include.only = "dbConnect")
require(RPostgres, include.only = "Postgres")
require(reactable, include.only = c("reactable", "renderReactable", "reactableOutput", "colDef"))

nemoids <- c(
  "2024111009da2405",
  "202412012adef417",
  "202412133238a1c4",
  "20250113709c77e0",
  "2025012239384760",
  "202503028851ddaa",
  "20250407e2ff5344",
  "20250513ae34f991",
  "20250608f7479a9b",
  "20250617f2e5b3a0"
)
table_config <- list(
  list(name = "amber_qc", display = "AmberQC"),
  list(name = "lilac_qc", display = "LilacQC"),
  list(name = "purple_qc", display = "PurpleQC")
)
table_names <- sapply(table_config, function(x) x$name)

ui <- fluidPage(
  titlePanel("NemoUI"),
  fluidRow(
    column(
      3,
      wellPanel(
        selectInput(
          "nemoid",
          "NemoID:",
          choices = nemoids,
          multiple = TRUE,
          selected = nemoids[1],
          width = "100%"
        ),
        hr(),
        div(
          style = "font-size: 12px; color: #666;",
          textOutput("summary_text")
        )
      )
    ),
    column(
      9,
      wellPanel(
        style = "background-color: #f8f9fa; padding: 10px;",
        h4("DB Overview", style = "margin-top: 0;"),
        reactableOutput("overview_table", height = "200px")
      )
    )
  ),
  fluidRow(
    column(
      12,
      do.call(
        tabsetPanel,
        c(
          id = "main_tabs",
          lapply(
            table_config,
            function(config) {
              tabPanel(
                config$display,
                br(),
                fluidRow(
                  column(
                    12,
                    div(
                      style = "margin-bottom: 10px;",
                      h4(
                        paste("Table:", config$display),
                        style = "display: inline-block; margin-right: 20px;"
                      ),
                      span(
                        textOutput(paste0(config$name, "_info")),
                        style = "color: #666; font-size: 14px;"
                      )
                    ),
                    reactableOutput(paste0(config$name, "_table"))
                  )
                )
              )
            }
          ),
          list(
            tabPanel(
              "Summary",
              br(),
              fluidRow(
                column(6, h4("Table Stats"), reactableOutput("detailed_overview")),
                column(6, h4("Nemo Tables"), reactableOutput("all_tables_list"))
              )
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  con <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    dbname = "nemo",
    user = "orcabus"
  )
  nemoid <- reactive(input$nemoid)

  create_filtered_table_reactive <- function(nm) {
    reactive({
      req(nemoid())
      selected_nemoid <- nemoid()
      tryCatch(
        {
          dplyr::tbl(con, nm) |>
            dplyr::filter(nemo_id == selected_nemoid) |>
            dplyr::as_tibble()
        },
        error = function(e) {
          tibble::tibble(
            Error = paste("Could not load table:", nm),
            Details = as.character(e$message)
          )
        }
      )
    })
  }

  table_reactives <- setNames(
    lapply(table_names, create_filtered_table_reactive),
    table_names
  )

  lapply(table_config, function(config) {
    table_name <- config$name

    # main table output
    output[[paste0(table_name, "_table")]] <- renderReactable({
      data <- table_reactives[[table_name]]()

      if (nrow(data) == 0) {
        return(
          reactable(
            tibble::tibble(Message = paste("No data found for NemoID:", nemoid())),
            columns = list(Message = reactable::colDef(align = "center", style = "color: #999;"))
          )
        )
      }

      reactable(
        data,
        searchable = TRUE,
        filterable = TRUE,
        pagination = TRUE,
        defaultPageSize = 8,
        highlight = TRUE,
        striped = TRUE,
        compact = TRUE,
        wrap = FALSE,
        resizable = TRUE,
        theme = reactable::reactableTheme(
          borderColor = "#ddd",
          stripedColor = "#f6f8fa",
          highlightColor = "#f0f8ff",
          cellPadding = "8px 12px"
        )
      )
    })

    # info text per table
    output[[paste0(table_name, "_info")]] <- renderText({
      data <- table_reactives[[table_name]]()
      if (nrow(data) > 0 && !"Error" %in% names(data)) {
        paste0("(", nrow(data), " rows, ", ncol(data), " columns)")
      } else if ("Error" %in% names(data)) {
        "(Error loading table)"
      } else {
        "(No data)"
      }
    })
  })

  # summary text in header
  output$summary_text <- renderText({
    total_rows <- sum(sapply(table_reactives, function(reactive_data) {
      data <- reactive_data()
      if (!"Error" %in% names(data)) nrow(data) else 0
    }))
    paste0("NemoID: ", nemoid(), "\n\nTotal rows across all tables: ", total_rows)
  })

  # Overview table in header
  output$overview_table <- renderReactable({
    req(nemoid())

    overview_data <- tibble::tibble(
      Table = sapply(table_config, function(x) x$display),
      Rows = sapply(table_reactives, function(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) nrow(data) else 0
      }),
      Columns = sapply(table_reactives, function(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) ncol(data) else 0
      }),
      Status = sapply(table_reactives, function(reactive_data) {
        data <- reactive_data()
        if ("Error" %in% names(data)) {
          "Error"
        } else if (nrow(data) > 0) {
          "Data Available"
        } else {
          "No Data"
        }
      })
    )

    reactable(
      overview_data,
      columns = list(
        Table = colDef(name = "Table", minWidth = 120),
        Rows = colDef(name = "Rows", align = "right", minWidth = 60),
        Columns = colDef(name = "Cols", align = "right", minWidth = 60),
        Status = colDef(
          name = "Status",
          minWidth = 100,
          cell = function(value) {
            color <- switch(
              value,
              "Data Available" = "#28a745",
              "No Data" = "#ffc107",
              "Error" = "#dc3545",
              "#6c757d"
            )
            span(style = paste0("color: ", color, "; font-weight: bold;"), value)
          }
        )
      ),
      pagination = FALSE,
      searchable = FALSE,
      compact = TRUE,
      defaultPageSize = 15
    )
  })

  # Detailed overview for summary tab
  output$detailed_overview <- renderReactable({
    req(nemoid())

    detailed_data <- tibble::tibble(
      Table = table_names,
      Display_Name = sapply(table_config, function(x) x$display),
      Row_Count = sapply(table_reactives, function(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) nrow(data) else 0
      }),
      Column_Count = sapply(table_reactives, function(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) ncol(data) else 0
      }),
      Has_Data = sapply(table_reactives, function(reactive_data) {
        data <- reactive_data()
        !"Error" %in% names(data) && nrow(data) > 0
      })
    )

    reactable(
      detailed_data,
      columns = list(
        Table = colDef(name = "Table Name"),
        Display_Name = colDef(name = "Display Name"),
        Row_Count = colDef(name = "Rows", align = "right"),
        Column_Count = colDef(name = "Columns", align = "right"),
        Has_Data = colDef(
          name = "Has Data",
          cell = function(value) {
            if (value) {
              span(style = "color: #28a745; font-weight: bold;", "✓ Yes")
            } else {
              span(style = "color: #dc3545; font-weight: bold;", "✗ No")
            }
          }
        )
      ),
      defaultPageSize = 15
    )
  })

  # All tables in database
  output$all_tables_list <- renderReactable({
    all_tables <- DBI::dbListTables(con) |>
      tibble::as_tibble_col(column_name = "table_name") |>
      dplyr::mutate(
        in_app = table_name %in% table_names
      )

    reactable(
      all_tables,
      columns = list(
        table_name = colDef(name = "Table Name"),
        in_app = colDef(
          name = "In App",
          cell = function(value) {
            if (value) {
              span(style = "color: #28a745; font-weight: bold;", "✓")
            } else {
              span(style = "color: #6c757d;", "—")
            }
          }
        )
      ),
      searchable = TRUE,
      defaultPageSize = 15
    )
  })

  onStop(function() {
    DBI::dbDisconnect(con)
  })
}

shinyApp(ui, server)

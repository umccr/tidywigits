require(shiny)
require(tibble, include.only = "as_tibble")
require(dplyr, include.only = c("filter", "mutate", "select"))
require(DBI, include.only = "dbConnect")
require(RPostgres, include.only = "Postgres")
require(reactable, include.only = c("reactable", "renderReactable", "reactableOutput", "colDef"))
require(glue, include.only = "glue")
require(purrr, include.only = "map")

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

# fmt: skip
table_config <- tibble::tribble(
  ~name,                          ~display,
  "amber_qc",                     "AmberQC",
  "lilac_qc",                     "LilacQC",
  "lilac_summary",                "LilacSummary",
  "purple_qc",                    "PurpleQC",
  "purple_puritytsv",             "PurplePuritytsv",
  "purple_drivercatalog",         "PurpleDriverCatalog",
  "linx_drivers",                 "LinxDrivers",
  "chord_prediction",             "ChordPred",
  "cobalt_gcmed_sample_stats",    "CobaltGCmed Sample",
  "cobalt_gcmed_bucket_stats",    "CobaltGC Bucket",
  "sigs_allocation",              "SigsAllocation",
  "flagstats_flagstats",          "FlagStats",
  "bamtools_wgsmetrics_metrics",  "BamtoolsWgsMetrics",
  "virusbreakend_summary",        "VirusBreakend",
  "virusinterpreter_annotated",   "VirusInterpreter"
)
table_names <- table_config$name

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
        checkboxInput(
          "select_all_ids",
          "Select All IDs",
          value = FALSE
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
  # main tabbed interface
  fluidRow(
    column(
      12,
      tabsetPanel(
        id = "main_tabs",
        !!!purrr::pmap(table_config, function(name, display) {
          tabPanel(
            display,
            br(),
            fluidRow(
              column(
                12,
                div(
                  style = "margin-bottom: 10px;",
                  h4(
                    glue("Table: {display}"),
                    style = "display: inline-block; margin-right: 20px;"
                  ),
                  span(
                    textOutput(glue("{name}_info")),
                    style = "color: #666; font-size: 14px;"
                  )
                ),
                reactableOutput(glue("{name}_table"))
              )
            )
          )
        }),
        # summary tab
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

server <- function(input, output, session) {
  con <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    dbname = "nemo",
    user = "orcabus"
  )
  nemoid <- reactive(
    {
      if (input$select_all_ids) {
        nemoids
      } else {
        input$nemoid
      }
    }
  )

  # observer to handle "Select All" checkbox
  observeEvent(input$select_all_ids, {
    if (input$select_all_ids) {
      updateSelectInput(session, "nemoid", selected = nemoids)
    } else {
      updateSelectInput(session, "nemoid", selected = nemoids[1])
    }
  })

  create_filtered_table_reactive <- function(nm) {
    reactive({
      req(nemoid())
      selected_nemoid <- nemoid()
      tryCatch(
        {
          dplyr::tbl(con, nm) |>
            dplyr::filter(nemo_id %in% selected_nemoid) |>
            tibble::as_tibble()
        },
        error = function(e) {
          tibble::tibble(
            Error = glue("Could not load table: {nm}"),
            Details = as.character(e$message)
          )
        }
      )
    })
  }

  table_reactives <- table_names |>
    purrr::map(create_filtered_table_reactive) |>
    purrr::set_names(table_names)

  purrr::pwalk(table_config, function(name, display) {
    # main table output
    output[[glue("{name}_table")]] <- renderReactable({
      data <- table_reactives[[name]]()

      if (nrow(data) == 0) {
        return(
          reactable(
            tibble::tibble(
              Message = glue(
                "No data found for NemoID(s): ",
                glue::glue_collapse(nemoid(), sep = ", ", last = " and ")
              )
            ),
            columns = list(Message = colDef(align = "center", style = "color: #999;"))
          )
        )
      }

      reactable(
        data,
        searchable = TRUE,
        filterable = TRUE,
        pagination = TRUE,
        defaultPageSize = 15,
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
    output[[glue("{name}_info")]] <- renderText({
      data <- table_reactives[[name]]()
      if (nrow(data) > 0 && !"Error" %in% names(data)) {
        glue("({nrow(data)} rows {ncol(data)} columns)")
      } else if ("Error" %in% names(data)) {
        "(Error loading table)"
      } else {
        "(No data)"
      }
    })
  })

  # summary text in header
  output$summary_text <- renderText({
    selected_ids <- nemoid()
    total_rows <- sum(purrr::map_int(table_reactives, \(reactive_data) {
      data <- reactive_data()
      if (!"Error" %in% names(data)) nrow(data) else 0
    }))
    if (length(selected_ids) == 1) {
      glue("NemoID: {selected_ids}; Total rows across all tables: {total_rows}")
    } else {
      glue(
        "Selected {length(selected_ids)} NemoIDs; ",
        "Total rows across all tables: {total_rows}"
      )
    }
  })

  # Overview table in header
  output$overview_table <- renderReactable({
    req(nemoid())

    overview_data <- tibble::tibble(
      Table = table_config$display,
      Rows = purrr::map_int(table_reactives, \(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) nrow(data) else 0
      }),
      Columns = purrr::map_int(table_reactives, \(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) ncol(data) else 0
      }),
      Status = purrr::map_chr(table_reactives, \(reactive_data) {
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
            span(style = glue("color: {color}; font-weight: bold;"), value)
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
      Table = table_config$name,
      Display_Name = table_config$display,
      Row_Count = purrr::map_int(table_reactives, \(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) nrow(data) else 0
      }),
      Column_Count = purrr::map_int(table_reactives, \(reactive_data) {
        data <- reactive_data()
        if (!"Error" %in% names(data)) ncol(data) else 0
      }),
      Has_Data = purrr::map_int(table_reactives, \(reactive_data) {
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
              span(style = "color: #6c757d;", "-")
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

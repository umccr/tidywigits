{
  use("arrow", "read_parquet")
  use("DBI", "dbConnect")
  use("dplyr", c("filter", "mutate", "select"))
  use("ggplot2")
  use("glue", "glue")
  use("plotly", c("renderPlotly", "plotlyOutput", "ggplotly"))
  use("reactable", c("reactable", "renderReactable", "reactableOutput", "colDef", "colFormat"))
  use("RPostgres", "Postgres")
  use("shiny")
  use("shinydashboard")
  use("tibble", "tibble")
}

# UI
ui <- dashboardPage(
  dashboardHeader(title = "WiGiTS Results"),
  dashboardSidebar(
    sidebarMenu(
      # ID selection
      div(
        style = "padding: 20px;",
        h4("Pick ID"),
        textInput("library_id", "LibraryID:", placeholder = "LibraryID"),
        actionButton("load_data", "Data Load", class = "btn-primary"),
        br(),
        br(),
      ),

      # Nav menu
      conditionalPanel(
        condition = "output.data_loaded",
        menuItem("QC", tabName = "qc", icon = icon("chart-line")),
        menuItem("SNVs", tabName = "snv", icon = icon("dna")),
        menuItem("CNVs", tabName = "cnv", icon = icon("copy")),
        menuItem("SVs", tabName = "sv", icon = icon("exchange-alt")),
        menuItem("Summary", tabName = "summary", icon = icon("chart-bar"))
      )
    )
  ),

  dashboardBody(
    tags$head(
      tags$style(HTML(
        "
        .content-wrapper, .right-side {
          background-color: #f4f4f4;
        }
        .loading-message {
          text-align: center;
          margin-top: 100px;
          font-size: 18px;
        }
      "
      ))
    ),

    tabItems(
      # Welcome/Loading tab
      tabItem(
        tabName = "welcome",
        fluidRow(
          box(
            width = 12,
            title = "Welcome",
            status = "primary",
            solidHeader = TRUE,
            div(
              class = "loading-message",
              h3("LibraryID"),
              br(),
              conditionalPanel(
                condition = "input.load_data > 0 && !output.data_loaded",
                div(
                  icon("spinner", class = "fa-spin"),
                  "Loading data..."
                )
              )
            )
          )
        )
      ),

      # QC Results tab
      tabItem(
        tabName = "qc",
        fluidRow(
          box(
            width = 12,
            title = "QC Status",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = FALSE,
            tabsetPanel(
              tabPanel("PURPLE", reactableOutput("purple_qc")),
              tabPanel("AMBER", reactableOutput("amber_qc")),
              tabPanel("LILAC", reactableOutput("lilac_qc"))
            )
          )
        ),
        fluidRow(
          box(
            width = 12,
            title = "QC Details",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = FALSE,
            tabsetPanel(
              tabPanel("PURPLE Purity", reactableOutput("purple_puritytsv")),
              tabPanel("CHORD", reactableOutput("chord_prediction")),
              tabPanel("LILAC Summary", reactableOutput("lilac_summary"))
            )
          )
        )
      ),

      # SNV Results tab
      tabItem(
        tabName = "snv",
        fluidRow(
          box(
            width = 12,
            title = "Single Nucleotide Variants",
            status = "primary",
            solidHeader = TRUE,
            div(
              style = "margin-bottom: 10px;",
              downloadButton("download_snv", "Download SNV Results", class = "btn-success")
            ),
            reactableOutput("snv_table")
          )
        ),
        fluidRow(
          box(
            width = 6,
            title = "Allele Frequency Distribution",
            status = "info",
            solidHeader = TRUE,
            plotlyOutput("snv_af_plot")
          ),
          box(
            width = 6,
            title = "Quality Score Distribution",
            status = "info",
            solidHeader = TRUE,
            plotlyOutput("snv_quality_plot")
          )
        )
      ),

      # CNV Results tab
      tabItem(
        tabName = "cnv",
        fluidRow(
          box(
            width = 12,
            title = "Copy Number Variants",
            status = "primary",
            solidHeader = TRUE,
            div(
              style = "margin-bottom: 10px;",
              downloadButton("download_cnv", "Download CNV Results", class = "btn-success")
            ),
            reactableOutput("cnv_table")
          )
        )
      ),

      # SV Results tab
      tabItem(
        tabName = "sv",
        fluidRow(
          box(
            width = 12,
            title = "Structural Variants",
            status = "primary",
            solidHeader = TRUE,
            div(
              style = "margin-bottom: 10px;",
              downloadButton("download_sv", "Download SV Results", class = "btn-success")
            ),
            reactableOutput("sv_table")
          )
        )
      ),

      # Summary tab
      tabItem(
        tabName = "summary",
        fluidRow(
          box(
            width = 12,
            title = "Analysis Summary",
            status = "primary",
            solidHeader = TRUE,
            uiOutput("summary_overview")
          )
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  # DB connection
  con <- DBI::dbConnect(
    drv = RPostgres::Postgres(),
    dbname = "nemo",
    user = "orcabus"
  )

  # Reactive values
  values <- reactiveValues(
    patient_data = NULL,
    data_loaded = FALSE
  )

  # Data loader
  # library_id <- "L2300659"
  load_data <- function(library_id) {
    tabs <- c(
      "purple_qc",
      "amber_qc",
      "lilac_qc",
      "lilac_summary",
      "purple_puritytsv",
      "purple_drivercatalog",
      "chord_prediction",
      "sigs_allocation",
      "flagstats_flagstats",
      "bamtools_wgsmetrics_metrics",
      "virusbreakend_summary",
      "virusinterpreter_annotated"
    )
    library_exists <- FALSE
    # Check if library exists in any of the tables
    for (tab in tabs) {
      query <- glue("SELECT COUNT(*) as count FROM \"{tab}\" WHERE nemo_pfix = '{library_id}'")
      result <- DBI::dbGetQuery(con, query)
      if (result$count > 0) {
        library_exists <- TRUE
        break
      }
    }
    if (!library_exists) {
      stop(glue("LibraryID {library_id} not found in any table"))
    }
    safe_query <- function(tab) {
      tryCatch(
        {
          # query <- glue("SELECT * FROM \"{tab}\" WHERE nemo_pfix = '{library_id}'")
          # result <- DBI::dbGetQuery(con, query)
          result <- dplyr::tbl(con, tab) |>
            dplyr::filter(nemo_pfix == library_id) |>
            dplyr::select(-c("nemo_id", "nemo_pfix")) |>
            dplyr::collect()
          if (nrow(result) == 0) {
            return(tibble(library_id = character(0)))
          }
          return(result)
        },
        error = function(e) {
          warning(glue("Error querying table {tab}: {e$message}"))
          return(tibble(library_id = character(0)))
        }
      )
    }

    dat <- list()
    for (tab in tabs) {
      dat[[tab]] <- safe_query(tab)
    }
    return(dat)
  }

  # Load data upon click
  observeEvent(input$load_data, {
    req(input$library_id)

    tryCatch(
      {
        values$patient_data <- load_data(input$library_id)
        values$data_loaded <- TRUE

        # Switch to QC tab after loading
        updateTabItems(session, "tabs", "qc")
      },
      error = function(e) {
        showNotification(glue("Error loading data: {e$message}"), type = "error")
      }
    )
  })

  # Output to control conditional panels
  output$data_loaded <- reactive({
    values$data_loaded
  })
  outputOptions(output, "data_loaded", suspendWhenHidden = FALSE)

  # QC Summary Cards
  output$qc_summary_cards <- renderUI({
    req(values$data_loaded)

    fluidRow(
      valueBox(
        value = "1.0M",
        subtitle = "Total Reads",
        icon = icon("dna"),
        color = "green"
      ),
      valueBox(
        value = "95%",
        subtitle = "Mapping Rate",
        icon = icon("bullseye"),
        color = "blue"
      ),
      valueBox(
        value = "5%",
        subtitle = "Duplicate Rate",
        icon = icon("copy"),
        color = "yellow"
      )
    )
  })

  # QC Tables
  output$purple_qc <- renderReactable({
    req(values$data_loaded)

    reactable(
      values$patient_data$purple_qc,
      filterable = TRUE,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      columns = list(
        qc_status = colDef(cell = function(value) {
          if (value == "PASS") {
            span(style = "color: green; font-weight: bold;", value)
          } else {
            span(style = "color: red; font-weight: bold;", value)
          }
        })
      )
    )
  })

  output$amber_qc <- renderReactable({
    req(values$data_loaded)

    reactable(
      values$patient_data$amber_qc,
      filterable = TRUE,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      columns = list(
        qcstatus = colDef(cell = function(value) {
          if (value == "PASS") {
            span(style = "color: green; font-weight: bold;", value)
          } else {
            span(style = "color: red; font-weight: bold;", value)
          }
        })
      )
    )
  })

  output$lilac_qc <- renderReactable({
    req(values$data_loaded)

    reactable(
      values$patient_data$lilac_qc,
      filterable = TRUE,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      columns = list(
        status = colDef(cell = function(value) {
          if (value == "PASS") {
            span(style = "color: green; font-weight: bold;", value)
          } else {
            span(style = "color: red; font-weight: bold;", value)
          }
        })
      )
    )
  })

  # SNV Table with filtering
  filtered_snv <- reactive({
    req(values$data_loaded)

    data <- values$patient_data$snv_results
    data <- data[data$allele_freq >= input$min_af / 100, ]
    data <- data[data$quality_score >= input$min_quality, ]

    data
  })

  output$snv_table <- renderReactable({
    req(values$data_loaded)

    reactable(
      filtered_snv(),
      filterable = TRUE,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      defaultPageSize = 15,
      columns = list(
        allele_freq = colDef(format = colFormat(percent = TRUE, digits = 1)),
        quality_score = colDef(format = colFormat(digits = 1))
      )
    )
  })

  # SNV Plots
  output$snv_af_plot <- renderPlotly({
    req(values$data_loaded)

    p <- ggplot(filtered_snv(), aes(x = allele_freq)) +
      geom_histogram(bins = 30, fill = "steelblue", alpha = 0.7) +
      labs(title = "Allele Frequency Distribution", x = "Allele Frequency", y = "Count") +
      theme_minimal()

    ggplotly(p)
  })

  output$snv_quality_plot <- renderPlotly({
    req(values$data_loaded)

    p <- ggplot(filtered_snv(), aes(x = quality_score)) +
      geom_histogram(bins = 30, fill = "orange", alpha = 0.7) +
      labs(title = "Quality Score Distribution", x = "Quality Score", y = "Count") +
      theme_minimal()

    ggplotly(p)
  })

  # CNV Table
  output$cnv_table <- renderReactable({
    req(values$data_loaded)

    reactable(
      values$patient_data$cnv_results,
      filterable = TRUE,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      defaultPageSize = 15
    )
  })

  # SV Table
  output$sv_table <- renderReactable({
    req(values$data_loaded)

    reactable(
      values$patient_data$sv_results,
      filterable = TRUE,
      searchable = TRUE,
      striped = TRUE,
      highlight = TRUE,
      defaultPageSize = 15,
      columns = list(
        quality_score = colDef(format = colFormat(digits = 1))
      )
    )
  })

  # Download handlers
  output$download_snv <- downloadHandler(
    filename = function() {
      paste0("snv_results_", input$library_id, "_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(filtered_snv(), file, row.names = FALSE)
    }
  )

  output$download_cnv <- downloadHandler(
    filename = function() {
      paste0("cnv_results_", input$library_id, "_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(values$patient_data$cnv_results, file, row.names = FALSE)
    }
  )

  output$download_sv <- downloadHandler(
    filename = function() {
      paste0("sv_results_", input$library_id, "_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(values$patient_data$sv_results, file, row.names = FALSE)
    }
  )

  # Summary overview
  output$summary_overview <- renderUI({
    req(values$data_loaded)

    snv_count <- nrow(filtered_snv())
    cnv_count <- nrow(values$patient_data$cnv_results)
    sv_count <- nrow(values$patient_data$sv_results)

    fluidRow(
      valueBox(
        value = snv_count,
        subtitle = "SNVs (filtered)",
        icon = icon("dna"),
        color = "green"
      ),
      valueBox(
        value = cnv_count,
        subtitle = "CNVs",
        icon = icon("copy"),
        color = "blue"
      ),
      valueBox(
        value = sv_count,
        subtitle = "SVs",
        icon = icon("exchange-alt"),
        color = "purple"
      )
    )
  })

  # Close database connection when session ends
  session$onSessionEnded(function() {
    DBI::dbDisconnect(con)
  })
}

shinyApp(ui = ui, server = server)

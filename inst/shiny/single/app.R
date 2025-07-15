{
  use("shiny")
  use("shinydashboard")
  use("dplyr", c("filter", "mutate", "select"))
  use("DBI", "dbConnect")
  use("RPostgres", c("Postgres"))
  use("reactable", c("reactable", "renderReactable", "reactableOutput", "colDef", "colFormat"))
  use("plotly", c("renderPlotly", "plotlyOutput", "ggplotly"))
  use("arrow", "read_parquet")
  use("glue", "glue")
  use("ggplot2")
}

# UI
ui <- dashboardPage(
  dashboardHeader(title = "WiGiTS Results"),
  dashboardSidebar(
    sidebarMenu(
      # Patient selection
      div(
        style = "padding: 20px;",
        h4("Pick ID"),
        textInput("library_id", "Library ID:", placeholder = "LibraryID"),
        actionButton("load_data", "Data Load", class = "btn-primary"),
        br(),
        br(),

        # Global filters (initially hidden)
        conditionalPanel(
          condition = "output.data_loaded",
          h4("Global Filters"),
          numericInput(
            "min_af",
            "Min Allele Frequency (%):",
            value = 0,
            min = 0,
            max = 100,
            step = 1
          ),
          numericInput("min_quality", "Min Quality Score:", value = 0, min = 0, step = 1)
        )
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
              h3("Gimme a LibraryID"),
              br(),
              conditionalPanel(
                condition = "input.load_data > 0 && !output.data_loaded",
                div(
                  icon("spinner", class = "fa-spin"),
                  "Loading patient data..."
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
            title = "Quality Control Summary",
            status = "primary",
            solidHeader = TRUE,
            collapsible = TRUE,
            uiOutput("qc_summary_cards")
          )
        ),
        fluidRow(
          box(
            width = 12,
            title = "QC Details",
            status = "info",
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = TRUE,
            tabsetPanel(
              tabPanel("QC Table 1", reactableOutput("qc_table_1")),
              tabPanel("QC Table 2", reactableOutput("qc_table_2")),
              tabPanel("QC Table 3", reactableOutput("qc_table_3")),
              tabPanel("QC Table 4", reactableOutput("qc_table_4")),
              tabPanel("QC Table 5", reactableOutput("qc_table_5"))
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
  # Database connection
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

  # Data loading function
  load_patient_data <- function(library_id) {
    # Example data:
    list(
      qc_table_1 = data.frame(
        library_id = library_id,
        metric = c("Total Reads", "Mapped Reads", "Duplicate Rate"),
        value = c(1000000, 950000, 0.05),
        status = c("PASS", "PASS", "PASS")
      ),
      snv_results = data.frame(
        library_id = rep(library_id, 100),
        chromosome = sample(paste0("chr", 1:22), 100, replace = TRUE),
        position = sample(1:1000000, 100),
        ref = sample(c("A", "T", "C", "G"), 100, replace = TRUE),
        alt = sample(c("A", "T", "C", "G"), 100, replace = TRUE),
        allele_freq = runif(100, 0, 1),
        quality_score = runif(100, 0, 100),
        gene = sample(paste0("Gene", 1:50), 100, replace = TRUE)
      ),
      cnv_results = data.frame(
        library_id = rep(library_id, 20),
        chromosome = sample(paste0("chr", 1:22), 20, replace = TRUE),
        start = sample(1:1000000, 20),
        end = sample(1000000:2000000, 20),
        copy_number = sample(c(0, 1, 3, 4), 20, replace = TRUE),
        gene = sample(paste0("Gene", 1:50), 20, replace = TRUE)
      ),
      sv_results = data.frame(
        library_id = rep(library_id, 15),
        chromosome1 = sample(paste0("chr", 1:22), 15, replace = TRUE),
        position1 = sample(1:1000000, 15),
        chromosome2 = sample(paste0("chr", 1:22), 15, replace = TRUE),
        position2 = sample(1000000:2000000, 15),
        sv_type = sample(c("DEL", "DUP", "INV", "TRA"), 15, replace = TRUE),
        quality_score = runif(15, 0, 100)
      )
    )
  }

  # Load data when button is clicked
  observeEvent(input$load_data, {
    req(input$library_id)

    tryCatch(
      {
        values$patient_data <- load_patient_data(input$library_id)
        values$data_loaded <- TRUE

        # Switch to QC tab after loading
        updateTabItems(session, "tabs", "qc")
      },
      error = function(e) {
        showNotification(paste("Error loading data:", e$message), type = "error")
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
  output$qc_table_1 <- renderReactable({
    req(values$data_loaded)

    reactable(
      values$patient_data$qc_table_1,
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

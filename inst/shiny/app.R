library(shiny)
library(reactable, include.only = c("reactable", "renderReactable", "reactableOutput"))

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
ui <- fluidPage(
  titlePanel("NemoUI"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "nemoid",
        "NemoId",
        choices = nemoids
      )
    ),
    mainPanel(
      reactableOutput("table_list"),
      reactableOutput("amber_qc")
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
  tbl_list <- DBI::dbListTables(con) |>
    tibble::as_tibble_col()
  output$table_list <- renderReactable({
    reactable(tbl_list)
  })
  output$amber_qc <- renderReactable({
    dplyr::tbl(con, "amber_qc") |>
      dplyr::as_tibble() |>
      dplyr::filter(nemo_id == nemoid()) |>
      reactable()
  })
  onStop(function() {
    DBI::dbDisconnect(con)
  })
}

shinyApp(ui, server)

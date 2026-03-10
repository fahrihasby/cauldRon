library(shiny)
library(rmarkdown)
library(purrr) # For mapping over lists

# Define various protocols with multiple mixes
# QIAseq miRNA
protocol_library <- list(
  "Genotyping PCR" = list(
    "PCR Master Mix" = data.frame(
      Reagent = c("2x Green Mix", "FWD Primer (10uM)", "REV Primer (10uM)", "Nuclease-Free Water"),
      Vol = c(12.5, 0.5, 0.5, 9.5)
    )
  ),
  "RT-qPCR (2-Step)" = list(
    "RT Mix (Step 1)" = data.frame(
      Reagent = c("5x RT Buffer", "RT Enzyme Mix", "Random Hexamers", "RNAse Inhibitor", "Water"),
      Vol = c(4.0, 1.0, 1.0, 0.5, 3.5)
    ),
    "qPCR Mix (Step 2)" = data.frame(
      Reagent = c("2x SYBR Master", "Primer Mix (10uM)", "Water"),
      Vol = c(10.0, 1.2, 3.8)
    )
  )
)


ui <- fluidPage(
  theme = shinythemes::shinytheme("flatly"),
  titlePanel("🧪 CauldRon: Advanced Master Mix Generator"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Project Metadata"),
      textInput("proj_id", "Project ID:", "EXP-702"),
      textInput("proj_num", "Project Number:", "12"),
      
      hr(),
      selectInput("proto", "Select Protocol:", choices = names(protocol_library)),
      numericInput("n_samples", "Number of Samples:", value = 8, min = 1),
      downloadButton("brew", "Download Recipe Scroll", class = "btn-success")
    ),
    
    mainPanel(
      uiOutput("preview_tables") # Dynamically generates UI for multiple tables
    )
  )
)

server <- function(input, output) {
  
  # Reactive logic to calculate ALL mixes in a protocol
  all_calculated_mixes <- reactive({
    selected_proto <- protocol_library[[input$proto]]
    multiplier <- input$n_samples * (1 + (10 / 100))
    
    # Calculate totals for every mix in the selected protocol
    map(selected_proto, function(df) {
      df$Total_Vol <- round(df$Vol * multiplier, 2)
      return(df)
    })
  })
  
  # Render multiple tables in the UI
  output$preview_tables <- renderUI({
    mixes <- all_calculated_mixes()
    
    # Create a list of tags: Heading + Table for each mix
    tagList(
      lapply(names(mixes), function(mix_name) {
        tagList(
          h4(paste("Mix:", mix_name), style = "color: #2c3e50; border-bottom: 1px solid #eee;"),
          renderTable(mixes[[mix_name]]),
          br()
        )
      })
    )
  })
  
  output$brew <- downloadHandler(
    filename = function() { paste0(input$proj_id, "_MasterMix.html") },
    content = function(file) {
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      rmarkdown::render(tempReport, output_file = file,
                        params = list(
                          proj_id = input$proj_id,
                          proj_num = input$proj_num,
                          protocol = input$proto,
                          samples = input$n_samples,
                          all_mixes = all_calculated_mixes()
                        ),
                        envir = new.env(parent = globalenv())
      )
    }
  )
}

shinyApp(ui, server)
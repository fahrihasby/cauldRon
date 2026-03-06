#load shiny & bslib
library(shiny)
library(bslib)

# Define UI for application that
ui <- fluidPage(
  titlePanel("🧪 CauldRon: Advanced Master Mix Generator"),
  sidebarLayout(
    sidebarPanel(
      textInput("project", "What's the project ID?", placeholder = "P.roject_00_00", ), 
      textInput("pnum", "What is the P number?", placeholder = "P12345"),
      textInput("n", "What is the number of sample ordered?", placeholder = "96"),
      selectInput("Dilution", 
                  label = "Input amount", 
                  choices = c("≥500 ng", 
                              "100 ng", 
                              "10 ng", 
                              "1 ng", 
                              "Serum/plasma"),
                  selected = "≥500 ng"),
      downloadButton("downloadReport", "Download recipe!")
    ),
    mainPanel(
      p("Fill out the fields and click download to see the result."),
      tags$i("This text is italicized.")
    )
  )
)

# Define server logic
server <- function(input, output, session){
  
}

# Run the application 
shinyApp(ui = ui, server = server)

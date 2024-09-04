library(shiny)
library(english)

# Define UI
ui <- fluidPage(

    # Application title
    titlePanel("NumbeR"),
    
    sidebarLayout(
      sidebarPanel(
        # Slider for max value
        sliderInput("range", label = "Range", min = 0, max = 10000, value = c(100, 1000)),
        
        # Generate number
        actionButton("go", "Go"),
        actionButton("spell", "Spell"),
        br(),
        br(),
        
      ),
      mainPanel(
        ## Outputs
        # Number
        textOutput("number"),
        
        # Spelling
        textOutput("spelling")
      )
    )



)

# Define server
server <- function(input, output) {
  
  # Generate random number
  min_val <- reactive(input$range[1])
  max_val <- reactive(input$range[2])
  x <- eventReactive(input$go, {
    round(runif(1, min = min_val(), max = max_val()))
  })
  
  # Reactive value to show / hide spelling
  v <- reactiveValues(spell = "")
  
  # When spell is triggered, spell x
  observeEvent(input$spell, {
    v$spell <- as.character(as.english(x()))
  })
  
  # When generating a new number, erase spelling
  observeEvent(input$go, {
    v$spell <- ""
  })
    
  # Outputs
  output$number <- renderText(x())
  output$spelling <- renderText(v$spell)
}

# Run the application 
shinyApp(ui = ui, server = server)




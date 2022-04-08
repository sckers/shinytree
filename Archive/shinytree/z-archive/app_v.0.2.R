# Script to run an R-Shiny server allowing for the customization and visualization
# of phylogenetic trees.  

# Dependencies: shiny, shinydashboard

# Group project for BIFS 613 9040 Statistical Processes for Biotechnology
# Sara Kerscher, Benjamin Sparklin, and Aaron Tyler
# 1Oct20

# Import required libraries
library(shiny)
library(shinydashboard)
library(shinycssloaders)
source("shinytree_helper.R")

# Provide UI functions for shiny server
ui <- dashboardPage(
  # Title banner
  dashboardHeader(title="shinytree"),
  # Sidebar to hold inputs
  dashboardSidebar(
    sidebarMenu(
      #collect model input with dropdown menu 
      selectInput("model", "Phylogeny Model:", 
                  choices=c("UPGMA" = "UPGMA",
                            "Neighbor Joining" = "Neighbor Joining", 
                            "Maximum Likelihood" = "Maximum Likelihood", 
                            "Maximum Parsimony" = "Maximum Parsimony")),
      #collect bootstraps input with slider
      sliderInput("bootstraps", "Bootstraps:", min=1, max=50, value=2),
      #collect style input with dropdown menu 
      selectInput("style", "Tree Style:", 
                  choices=c("Circular" = "circular",
                            "Slanted" = "slanted",
                            "Fan" = "fan",
                            "Rectangular" = "rectangular")),
      #creates new plot with updated parameters when pressed
      actionButton("button", "New Tree")
    )
  ),
  # Body to hold outputs
  dashboardBody(
    #receives plot output from server
    fillPage(
      shinycssloaders::withSpinner(
        box(plotOutput(("plot"), width=1200, height=1200))
      )
    )
  )
)

# Carry out server side functions based on inputs in UI and return outputs
server <- function(input, output) {
    #delay building tree until action button is clicked
    eventReactive(input$button, {
      tree_build(input$model, input$bootstraps)
      #render tree plot with inputs from UI
      output$plot <- renderPlot({
        tree_plot(input$style)
      })
    })
    
  }
shinyApp(ui, server)
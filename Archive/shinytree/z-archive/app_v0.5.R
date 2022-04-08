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
      box(shinycssloaders::withSpinner(plotOutput(("plot"), width="100%", height=1200)))
    )
  )
)

# Carry out server side functions based on inputs in UI and return outputs
server <- function(input, output) {
    #creates an empty plot so that spinner doesn't spin until first action button click
    output$plot <- plot.new()
    #populates tree upon clicking the "new tree" button
    observeEvent(input$button, {
      #render tree plot with selected inputs
      output$plot <- renderPlot({
        #creates tree data given the selected inputs
        tree_build(isolate(input$model), isolate(input$bootstraps))
        # creates plot output
        if (input$model == "UPGMA"){
          tree_plot_UPGMA(isolate(input$style))
        } else if (input$model == "Neighbor Joining"){
          tree_plot_NJ(isolate(input$style))
        } else if (input$model == "Maximum Likelihood") {
          tree_plot_ML(isolate(input$style))
        } else {
          tree_plot_MP(isolate(input$style))
        }
      })
    })
  }
shinyApp(ui, server)
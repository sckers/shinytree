# Script to run an R-Shiny server allowing for the customization and visualization
# of phylogenetic trees.  

# Dependencies: shiny, shinydashboard

# Group project for BIFS 613 9040 Statistical Processes for Biotechnology
# Sara Kerscher, Benjamin Sparklin, and Aaron Tyler
# 19Sep20

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
      #collect model input as text
      textInput(inputId="model", "Phylogeny Model:", "Maximum Likelihood"),
      #collect bootstraps input as slider
      sliderInput("bootstraps", "Bootstraps:", min=1, max=50, value=2),
      #collect tree style input as text
      textInput(inputId ="style", "Tree style:", "circular"),
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
  #render tree plot with inputs from UI
  #Server side stuff goes here
  #plot the tree
    output$plot <- renderPlot({
      tree_build(input$model, input$bootstraps)
      tree_plot(input$style)
    })
  }
  

shinyApp(ui, server)
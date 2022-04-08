# Script to run an R-Shiny server allowing for the customization and visualization
# of phylogenetic trees.  

# Dependencies: shiny, shinydashboard

# Group project for BIFS 613 9040 Statistical Processes for Biotechnology
# Sarah Kerscher, Benjamin Sparklin, and Aaron Tyler
# 1Oct20

# Import required libraries
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinydashboardPlus)
source("shinytree_helper_v0.5.R")

#build the ui pieces separately
#build ui header - title/logo
header <- dashboardHeaderPlus(title = span(tagList("shinytree", 
                                                   tags$img(src = "www\tree_image.jpg", 
                                                            width = "50px", height = "64px")))
)

#build ui sidebar - contains tabs for different pages in the app
sidebar <- dashboardSidebar(
  sidebarMenu(
    #home tab
    menuItem("Home", tabName = "home", icon = icon("fas fa-home")),
    menuItem("Make Tree", tabName = "tree", icon = icon("fas fa-tree")),
    menuItem("About", tabName = "about", icon = icon("fas fa-question"))
  )
)

#build ui body - contains content for each tab including user input modules and plot output
body <- dashboardBody(
  tabItems(
    #home tab to explain how to use the app
    tabItem(tabName = "home",
            p(h3(tags$b("Generate phylogenetic trees from your settings"))), 
            p(h4("This app is designed to produce phylogenetic trees of the Nocardia family based on your desired settings. On the 'Make Tree' page, select the phylogeny model and tree style from the dropdowns, then use the slider to set the number of bootstraps. Hit the 'New Tree' button to generate the tree. You can go back and adjust the settings and generate a new tree if desired."))),
    #Make Tree tab content for user inputs - tree plot is a closeable pop-up in this tab
    tabItem(tabName = "tree",
            fluidRow(
              
              #box for model dropdown
              box(title = "Phylogeny Model", 
                  selectInput("model", label = NULL, 
                              choices = list("UPGMA" = "UPGMA", "Neighbor Joining" = "Neighbor Joining",
                                             "Maximum Likelihood" = "Maximum Likelihood", 
                                             "Maximum Parsimony" = "Maximum Parsimony")), width = 4),
              
              #box for bootstraps slider
              box(title = "Bootstraps", sliderInput("bootstraps", label = NULL, 
                                                    min = 1, max = 50, value = 10),
                  width = 4),
              
              #box for tree style dropdown
              box(title = "Tree Style", 
                  selectInput("style", label = NULL, 
                              choices = list("Circular" = "circular", "Slanted" = "slanted", "Fan" = "fan",
                                             "Rectangular" = "rectangular")), width = 4)
            ),
            fluidRow(
              #box for submit button
              box(actionButton("button", "New Tree", width = "100%"), width = 3)
              
            ),
            fluidRow(
              #box for plot output
              box(shinycssloaders::withSpinner(plotOutput("plot")), width = 12)
            )
    ),
    #About tab for about the project
    tabItem(tabName = "about", p(h3(tags$b("About shinytree"))), p(h4("The shinytree app was designed for academic purposes under the supervision of Dr. Herrerra. The app was created to fulfill the requirements of the group project for class BIFS 613 in the fall of 2020. Group members include Sarah Kerscher, Benjamin Sparklin, and Aaron Tyler.")))
  )
)

#build ui footer - byline
footer <- dashboardFooter(left_text = h6("By Sarah Kerscher, Benjamin Sparklin, and Aaron Tyler"),
  right_text = h6("UMGC | BIFS 613 | Oct2020")
)

#put together ui pieces
ui <- dashboardPagePlus(header, sidebar, body, footer)

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
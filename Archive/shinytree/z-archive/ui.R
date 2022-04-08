# Import required libraries
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinydashboardPlus)

#build the ui separately
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
              column(
            
                #box for model dropdown
                box(title = "Phylogeny Model", 
                    selectInput("model", title = NULL, 
                                choices = list("UPGMA" = 1, "Neighbor Joining" = 2,
                                               "Maximum Likelihood" = 3, 
                                               "Maximum Parsimony" = 4))),
                
                #box for bootstraps slider
                box(title = "Bootstraps", sliderInput("bootstraps", title = NULL, 
                                                      min = 1, max = 50, value = 10)),
                
                #box for tree style dropdown
                box(title = "Tree Style", 
                    selectInput("style", title = NULL, 
                                choices = list("Circular" = 1, "Slanted" = 2, "Fan" = 3,
                                               "Rectangular" = 4))),
              
                #box for submit button
                box(actionButton("button", "New Tree"))
                
                ),
              column(
                #box for plot output
                box(shinycssloaders::withSpinner(plotOutput("plot")))
               )
              )
            ),
    #About tab for about the project
    tabItem(tabName = "about", p(h3(tags$b("About shinytree"))), p(h4("The shinytree app was designed for academic purposes under the supervision of Dr. Herrerra. The app was created to fulfill the requirements of the group project for class BIFS 613 in the fall of 2020. Group members include Sarah Kerscher, Benjamin Sparklin, and Aaron Tyler.")))
  )
)

#build ui footer - byline
footer <- dashboardFooter(
  right_text = h6(p("By Sarah Kerscher, Benjamin Sparklin, and Aaron Tyler"),
                p("UMGC | BIFS 613 | Oct2020"))
)

#put together ui pieces
ui <- shinydashboardPlus(header, sidebar, body, footer)
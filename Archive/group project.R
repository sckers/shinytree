# shiny.rstudio.com/tutorial/written-tutorial/  - lessons 2 and 3
library(shiny)
ui <- fluidPage(
  # App title
  titlePanel("Insert our App title here",
             # Text explaining app
             h4("This app will create a phylogenetic tree based on your settings.\n
             Choose your phylogenetic model and tree style from the dropdown\n
             menus and use the slider to select your bootstraps setting.")
             ),
  
  # Sidebar
  sidebarLayout(
    # Inputs
    sidebarPanel(
      # Drop-down for phylogenetic model
      selectInput("model", "Phylogenetic Model", choices = list("Choose model..." = 1, "UPGMA" = 2, "Neighbor Joining" = 3, "Maximum Likelihood" = 4, "Maximum Parsimony" = 5, selected = 1)),
      
      # Slider for bootstraps
      sliderInput(inputId = "bootstraps", label = "Bootstraps", min = 1, max = 100, value = 50),
      
      # Drop-down for tree style
      selectInput("tree", "Tree Style", choices = list("Choose tree style..." = 1, "Circular" = 2, "Slanted" = 3, selected = 1)),
      
      # Go Button
      actionButton("gobutton", "Go")
      
    ),
    
    # Output panel
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
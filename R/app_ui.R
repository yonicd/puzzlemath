#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinyWidgets checkboxGroupButtons
#' @importFrom shinyjs useShinyjs
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      shinyjs::useShinyjs(),
      # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          shinyWidgets::checkboxGroupButtons(
            inputId = "signs", label = "Choose Signs",
            choices = c('+','-','*','/'),
            selected = c('+','-','*','/'),
            individual = TRUE,
            justified = FALSE, 
            status = "primary",
            size = 'sm'
          ),
          sliderInput(inputId = 'range', label = 'Number Range',
                      min = 1, max = 100, value = c(1,10)
          ),
          sliderInput(inputId = 'n', label = 'Number of Questions',
                      min = 4, max = 100,step = 1, value = 25
          ),
          wellPanel(
            actionButton(
              inputId = 'game',
              label = 'New Game',
              onclick  = "document.getElementById('draw').click()"
            ),
            actionButton('draw','New Question')
            # actionButton('pause','pause')
          ),
          verbatimTextOutput('ques'),
          wellPanel(
            id = 'anspanel',
            textInput(
              inputId = 'ans',
              label = NULL,
              value = '',
              placeholder = 'answer')
          )
        ),
        
        # Show a plot of the generated distribution
        # mainPanel(
        #   tabsetPanel(
        #     tabPanel(title = 'puzzle',plotUI("plot1")),
        #     tabPanel(title = 'data',tableOutput('tbl'))
        #   )
        # )
        mainPanel(
          h1('Puzzle Math!'),
          tabPanel(title = 'puzzle',plotUI("plot1")),
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'puzzlemath'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}


#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
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
          actionButton('game','New Game'),
          actionButton('draw','New Question'),
          checkboxGroupInput(
            inputId = 'signs',
            label = 'Choose Signs',
            choices = c('+','-','*','/'),
            selected = c('+','-','*','/'),
            inline = TRUE
          ),
          sliderInput(inputId = 'range',
                      label = 'Number Range',
                      min = 1,max = 100,
                      value = c(1,10)
          ),
          sliderInput(inputId = 'mat_dim',
                      label = 'Game Dimensions',
                      min = 1,max = 10,step = 1,
                      value = 5
          ),
          checkboxInput(
            inputId = 'arrows',
            label = 'Show Arrows',
            value = FALSE
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
        mainPanel(
          #tableOutput('vals'),
          plotUI("plot1")
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


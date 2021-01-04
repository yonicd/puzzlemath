ui <- shiny::tagList(
    shiny::fluidPage(
      htmltools::includeScript(path = "www/script.js"),
      shiny::checkboxGroupInput(
        inputId = "signs", 
        label = "Choose Signs",
        inline = TRUE,
        choices = c('+','-','*','/'),
        selected = c('+','-','*','/')
      ),
      shiny::sliderInput(inputId = 'range', label = 'Number Range',
                         min = 1, max = 100, value = c(1,10)
      ),
      shiny::sliderInput(inputId = 'n', label = 'Number of Questions',
                         min = 4, max = 50,step = 1, value = 25
      ),
      shiny::wellPanel(
        shiny::actionButton(
          inputId = 'game',
          label = 'New Game',
          onclick  = "document.getElementById('draw').click()"
        ),
        shiny::actionButton('draw','New Question')
      ),
      shiny::verbatimTextOutput('ques'),
      shiny::wellPanel(
        id = 'anspanel',
        shiny::textInput(
          inputId = 'ans',
          label = NULL,
          value = '',
          placeholder = 'answer')
      )
    )
  )

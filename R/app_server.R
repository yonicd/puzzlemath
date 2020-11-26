#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @noRd
#' @import shiny
#' @importFrom glue glue
app_server <- function( input, output, session ) {
  
  shiny::observeEvent(c(input$range,input$mat_dim,input$game),{
    
    req(input$range)
    req(input$mat_dim)
    req(input$signs)
    
    this$df <- new_game(
      n = input$range, 
      mat_dim = input$mat_dim,
      signs = input$signs
    )
    
    this$counter <- c()
    
  }) 
  
  qp <- shiny::eventReactive(input$draw,{
    this$df[sample(which(this$df$a==1),1),]
  })    
  
  shiny::observeEvent(c(input$draw),{
    tqp <- qp()
    
    output$ques <- shiny::renderText({ 
      glue::glue('{as.character(tqp$v1)} {tqp$sign} {as.character(tqp$v2)} ?') })
    
    output$vals <- shiny::renderTable(tqp,rownames = TRUE)
    
    shiny::updateTextInput(session,'ans',value = '')
  })
  
  observeEvent(c(input$game,input$draw,input$ans,input$arrows),{
    plotServer("plot1",qp,input$arrows, input$mat_dim, input$ans)  
  })

  observeEvent(input$ans,{
    
    col <- 'grey'
    
    if(nzchar(input$ans)){
      if(as.numeric(input$ans)==qp()[['m']]){
        col <- 'green'
      }else{
        col <- 'red'
      } 
    }
    
    shinyjs::runjs(glue::glue("document.getElementById('anspanel').style.borderColor = '{col}'"))
  })
  
}

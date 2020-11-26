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
  
  observeEvent( input$draw , {
    this$qp <- this$df[sample(which(this$df$a==1),1),]
  })
  
  shiny::observeEvent(c(input$draw),{
    tqp <- this$qp
    
    output$ques <- shiny::renderText({ 
      glue::glue('{as.character(tqp$v1)} {tqp$sign} {as.character(tqp$v2)} ?') })
    
    output$vals <- shiny::renderTable(tqp,rownames = TRUE)
    
    shiny::updateTextInput(session,'ans',value = '')
  })
  
  # Store everything as a reactiveValues 
  # that is passed to the module
  r <- reactiveValues(
    arrows = NULL, 
    mat_dim = NULL,
    ans = "", 
    draw = NULL
  )
  
  # Update the Values using the inputs
  observeEvent( input$game, {
    r$game <- input$game
  })
  
  observeEvent( input$draw, {
    r$draw <- input$draw
  })
  
  observeEvent( input$arrows, {
    r$arrows <- input$arrows
  })
  
  observeEvent( input$mat_dim, {
    r$mat_dim <- input$mat_dim
  })
  
  observeEvent( input$ans, {
    req(input$ans)
    # Update the plot only if answer is correct
    if(as.numeric(input$ans)==this$qp[['m']]){
      r$ans <- input$ans
    }
  })
  
  # Pass r to the module
  plotServer("plot1", r)  

  observeEvent(input$ans,{
    
    col <- 'grey'
    
    if(nzchar(input$ans)){
      if(as.numeric(input$ans)==this$qp[['m']]){
        col <- 'green'
      }else{
        col <- 'red'
      } 
    }
    
    shinyjs::runjs(glue::glue("document.getElementById('anspanel').style.borderColor = '{col}'"))
  })
  
}

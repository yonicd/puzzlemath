#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @noRd
#' @import shiny
#' @importFrom glue glue
#' @importFrom shinyjs runjs hide show
app_server <- function( input, output, session ) {
  
  shiny::observeEvent(c(input$range,input$n,input$game,input$signs),{
    
    shiny::req(input$range)
    shiny::req(input$n)
    shiny::req(input$signs)
    
    this$df <- new_game(
      rng = input$range, 
      n = input$n,
      signs = input$signs
    )
    
    this$counter <- 1
    
    if(any(this$df$a==1)){
      shinyjs::show('draw')  
    }
    
    output$tbl <- shiny::renderTable({
      this$df
    },rownames = TRUE)
  }) 
  
  shiny::observeEvent( input$draw , {

    idx <- which(this$df$a==1)
    
    if(length(idx)==1){
      s <- idx
    }else{
      s <- sample(idx,1)  
    }

    this$qp <- this$df[s,]
  })
  
  shiny::observeEvent(c(input$draw),{
    tqp <- this$qp
    
    output$ques <- shiny::renderText({ 
      glue::glue('{tqp$x} {tqp$sign} {tqp$y} ?') })
    
    output$vals <- shiny::renderTable(tqp,rownames = TRUE)
    
    shiny::updateTextInput(session,'ans',value = '')
  })
  
  # Store everything as a reactiveValues 
  # that is passed to the module
  r <- shiny::reactiveValues(
    n = NULL,
    ans = "", 
    draw = NULL,
    # pause = FALSE,
    counter = 0,
    qp = NULL
  )
  
  # Update the Values using the inputs
  shiny::observeEvent( input$game, {
    r$game <- input$game
  })
  
  shiny::observeEvent( input$draw, {
    r$draw <- input$draw
  })
  
  # observeEvent( input$pause, {
  #   r$pause <- (input$pause%%2)==1
  # })
  
  shiny::observeEvent( input$range, {
    r$range <- input$range
    shinyjs::click('game')
  })
  
  shiny::observeEvent( input$signs, {
    
    defaults <- c('+','-','*','/')
    root <- "$(':button')[%s].className = 'btn checkbtn btn-%s active'"
    
    for(i in 1:length(defaults)){

      if(defaults[i]%in%input$signs){
        shiny_call <- sprintf(root,i-1,'primary')
      }else{
        shiny_call <- sprintf(root,i-1,'danger')
      }
      shinyjs::runjs(shiny_call)
    }
    
    shinyjs::click('game')
  })
    
  shiny::observeEvent( input$n, {
    r$n <- input$n
  })
  
  shiny::observeEvent( input$ans, {
    
    shiny::req(input$ans)
    
    num <- tryCatch(
      as.numeric(input$ans),
      error=function(e) e, 
      warning=function(w) w
      )
    
    if(inherits(num,what = 'numeric')){
      # Update the plot only if answer is correct
      if(num==this$qp[['m']]){
        r$ans <- input$ans
        
        this$df$a[as.numeric(rownames(this$qp))] <- 0
        r$counter <- r$counter + 1
      }      
    }

    if(all(this$df$a==0)){
      shiny::updateTextInput(session,'ans',value = '')
      shinyjs::hide('draw')
    }
    output$tbl <- shiny::renderTable({
      this$df
    },rownames = TRUE)
  })
  
  shiny::observeEvent( input$ans, {
    col <- 'grey'
    width <- 1

    num <- tryCatch(
      as.numeric(input$ans),
      error=function(e) e, 
      warning=function(w) w
    )
    
    if(inherits(num,'numeric')){
      if(nzchar(input$ans)){
        if(as.numeric(input$ans)==this$qp[['m']]){
          col <- 'green'
          width <- 2
        }else{
          col <- 'red'
          width <- 4
        } 
      }
    
    }else{
      
      col <- 'red'
      width <- 4
      
    }
    
    shinyjs::runjs(glue::glue("document.getElementById('anspanel').style.borderColor = '{col}'"))
    shinyjs::runjs(glue::glue("document.getElementById('anspanel').style.borderWidth = '{width}px'"))

  })  
  
  # Pass r to the module
  plotServer("plot1", r)  
}

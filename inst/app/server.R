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
      # shinyjs::show('draw')
      session$sendCustomMessage('showid','draw')
    }
    
  }) 
  
  shiny::observeEvent( input$draw , {
    whereami::cat_where(whereami::whereami(tag = 'draw'))
    idx <- which(this$df$a==1)
    
    if(length(idx)==1){
      s <- idx
    }else{
      s <- sample(idx,1)  
    }
    
    this$qp <- this$df[s,]
    
    output$ques <- shiny::renderText({ 
      glue::glue('{this$qp$x} {this$qp$sign} {this$qp$y} ?') })
    
    output$vals <- shiny::renderTable(this$qp,rownames = TRUE)
    
    shiny::updateTextInput(session,'ans',value = '')
    
    r$draw <- input$draw
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
  
  shiny::observeEvent( input$range, {
    r$range <- input$range
    r$counter <- r$counter + 1
    session$sendCustomMessage('clickon','#game')
  })
  
  shiny::observeEvent( input$signs, {
    r$counter <- r$counter + 1
    session$sendCustomMessage('clickon','#game')
  })
  
  shiny::observeEvent( input$n, {
    r$counter <- r$counter + 1
    r$n <- input$n
  })
  
}

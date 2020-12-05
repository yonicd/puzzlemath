#' start UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList plotOutput
plotUI <- function(id){
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::plotOutput(ns("plot"),height = 500)
  )
}
    
#' start Server Function
#'
#' @noRd 
#' @import shiny
#' @importFrom whereami whereami
#' @import ggplot2 
#' @importFrom ggpubr background_image
#' @importFrom ggvoronoi geom_voronoi
#' @importFrom grid arrow
plotServer <- function(id, r){
  shiny::moduleServer(id,
    function(input, output, session){

      output$plot <- shiny::renderPlot({
        
        whereami::whereami(tag = 'plot')
        
        shiny::req(r$game)
        shiny::req(r$n)
        shiny::req(r$counter)

        dat <- this$df 
        
        p <- ggplot2::ggplot(
          data = dat, 
          ggplot2::aes(xx, yy)
        ) + 
          ggpubr::background_image(this$img)
        
        if(any(dat$a==1)){
          
          if(all(dat$a==1)){
            p <- p + ggvoronoi::geom_voronoi(
              color = 'grey90',ggplot2::aes(fill = z),show.legend = FALSE)
          }else{
            p <- p + ggvoronoi::geom_voronoi(
              color = 'grey90',ggplot2::aes(fill = z,alpha = a),show.legend = FALSE)
          }
   
          p <- p + viridis::scale_fill_viridis(option = 'B')
        }  
        
        p + 
          ggplot2::scale_x_continuous(expand = c(0,0)) + 
          ggplot2::scale_y_continuous(expand = c(0,0)) + 
          ggplot2::theme(
            axis.text  = ggplot2::element_blank(),
            axis.ticks = ggplot2::element_blank(),
            axis.title = ggplot2::element_blank()
          )
        
      })  

  })
}

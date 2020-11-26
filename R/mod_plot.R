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
    shiny::plotOutput(ns("plot"))
  )
}
    
#' start Server Function
#'
#' @noRd 
#' @import shiny
#' @importFrom whereami cat_where whereami
#' @import ggplot2 
#' @importFrom ggpubr background_image
#' @importFrom grid arrow
plotServer <- function(id, qp, arrows, mat_dim, ans){
  shiny::moduleServer(id,
    function(input, output, session){

      output$plot <- shiny::renderPlot({
        
        whereami::cat_where(whereami::whereami())

        tqp <- qp()
        
        dat <- plot_data(tqp,ans)
        
        aa <- tqp$y
        bb <- tqp$x

        p <- ggplot2::ggplot(
          data = dat, 
          ggplot2::aes(x = y, y = x, fill = z)
        ) + 
          ggpubr::background_image(this$img)
        
        if(any(dat$a==1)){
          
          if(all(dat$a==1)){
            p <- p + ggplot2::geom_raster(show.legend = FALSE)
          }else{
            p <- p + ggplot2::geom_raster(ggplot2::aes(alpha = a),show.legend = FALSE)
          }
          
          if(arrows){
            p <- p + 
              ggplot2::geom_segment(
                x = aa, xend = aa, y = 0.5, yend = bb-0.25,
                arrow = grid::arrow(),
                colour = 'red',
                size = 1) +
              ggplot2::geom_segment(
                x = 0.5, xend = aa-0.25, y = bb, yend = bb,
                arrow = grid::arrow(),
                colour = 'red',
                size = 1)
          }
          
          p <- p + ggplot2::scale_fill_viridis_b()
        }  
        
        p + ggplot2::scale_x_continuous(
          expand = c(0,0),
          breaks = seq(mat_dim),
          labels = attr(this$df,'v2')
        ) +
          ggplot2::scale_y_continuous(
            expand = c(0,0),
            breaks = seq(mat_dim),
            labels = attr(this$df,'v1')
          ) + 
          ggplot2::theme(
            axis.text = ggplot2::element_text(size  = 20),
            axis.title = ggplot2::element_blank()
          )
        
      })  

  })
}

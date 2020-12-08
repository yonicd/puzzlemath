#' @importFrom magick image_read
#' @importFrom glue glue
#' @importFrom stats runif
new_game <- function(rng = c(2,50), n = 25,signs = c('+','-','*','/')){
  
  this$img <- magick::image_read(sample(splash_links,1))

  r <- sample(rng[1]:rng[2],2000,replace = TRUE)
  
  df <- r2df(r,n)
  
  sub_signs <- intersect(signs,c('+','-','*'))
  df$sign <- sample(sub_signs,n,replace = TRUE)
  
  if('/'%in%signs){
    df$sign[df$x%%df$y==0] <- '/'        
  }
  
  for(i in 1:nrow(df)){
    df$m[i] <- eval(
      parse(text = glue::glue('{df$x[i]} {df$sign[i]} {df$y[i]}'))
      )
  }

  df
}

plot_data <- function(tqp, ans){
  
  idx <- as.numeric(rownames(tqp))
  
  if(nzchar(ans)){
    
    if(as.numeric(ans)==this$df$m[idx]){
      
      if(is.null(this$counter)){
        this$counter <- c()
      }
      
      this$counter <- unique(c(this$counter,idx))
      
      this$df$a[this$counter] <- 0   
    }
  }
  
  this$df
}

r2df <- function(r,nn){
  
  mat <- matrix(r,ncol = 2, byrow = FALSE)
  mat <- apply(mat,1,sort,decreasing = TRUE)
  mat <- t(mat)
  mat <- unique(mat[apply(mat,1,function(x) x[1]!=x[2]),])
  nn <- min(nn,nrow(mat))
  mat <- mat[sample(1:nrow(mat),nn),]
  mat_df <- as.data.frame(mat)
  names(mat_df) <- c('x','y')
  mat_df$row_id <- 1:nn
  mat_df$a <- 1
  mat_df$z <- stats::runif(nn)
  
  v <- sample(1:2000,2*nn,replace = FALSE)
  
  mat_df$xx <- v[1:nn]
  mat_df$yy <- v[(nn+1):(2*nn)]
  
  mat_df
}

this <- new.env()

#' @importFrom magick image_read
#' @importFrom glue glue
#' @importFrom stats runif
new_game <- function(rng = c(2,50), n = 25,signs = c('+','-','*','/')){
  
  this$img <- magick::image_read(sample(splash_links,1))

  r <- sample(rng[1]:rng[2],1000,replace = TRUE)
  
  df <- r2df(r,n)
  
  ndf <- nrow(df)
  
  df$a <- 1
  df$z <- stats::runif(ndf)
  
  v <- sample(1:2000,ndf*2,replace = FALSE)
  
  df$xx <- v[1:ndf]
  df$yy <- v[(ndf+1):(2*ndf)]
  
  sub_signs <- intersect(signs,c('+','-','*'))
  df$sign <- sample(sub_signs,ndf,replace = TRUE)
  
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

r2df <- function(r,n){
  mat <- matrix(r,ncol = 2, byrow = FALSE)
  mat <- apply(mat,1,sort,decreasing = TRUE)
  mat <- t(mat)
  mat <- mat[apply(mat,1,function(x) x[1]!=x[2]),]    
  mat <- mat[sample(1:nrow(mat),round(sqrt(n))),]
  expand.grid(x = mat[,1],y = mat[,2])
}

this <- new.env()

#' @importFrom magick image_read
#' @importFrom glue glue
#' @importFrom stats runif
new_game <- function(n = c(2,50), mat_dim = 5,signs = c('+','-','*','/')){
  
  this$img <- magick::image_read(sample(splash_links,1))

  r <- sample(n[1]:n[2],1000,replace = TRUE)
  
  mat <- t(apply(matrix(r,ncol = 2, byrow = FALSE),1,sort,decreasing = TRUE))
  
  mat <- mat[apply(mat,1,function(x) x[1]!=x[2]),]
  
  sub_mat <- mat[sample(1:nrow(mat),mat_dim),]
  
  v1 <- sub_mat[,1]
  v2 <- sub_mat[,2]
  
  df <- expand.grid(x = 1:mat_dim,y = 1:mat_dim)
  df$v1 <- factor(df$x,labels = v1)
  df$v2 <- factor(df$y,labels = v2)
  df$z <- stats::runif(nrow(df))
  sub_signs <- intersect(signs,c('+','-','*'))
  df$sign <- sample(sub_signs,nrow(df),replace = TRUE)
  
  if('/'%in%signs){
    df$sign[as.numeric(as.character(df$v1))%%as.numeric(as.character(df$v2))==0] <- '/'        
  }
  
  
  for(i in 1:nrow(df)){
    df$m[i] <- eval(parse(text = glue::glue('{as.character(df$v1[i])} {df$sign[i]} {as.character(df$v2[i])}')))        
  }
  
  df$a <- rep(1,nrow(df))
  
  
  attr(df,'v1') <- v1
  attr(df,'v2') <- v2
  
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
      
      # shinyjs::runjs("document.getElementById('anspanel').style.borderColor = 'green'")
      
      this$df$a[this$counter] <- 0   
    }
  }
  
  this$df
}

this <- new.env()

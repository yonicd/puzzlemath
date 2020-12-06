## code to prepare `splash` dataset goes here

root <- 'https://api.unsplash.com/'
search_path <- 'search/photos'
query <- 'cartoon'
splash_key <- sprintf("Client-ID %s",keyring::key_get('unspash'))

ret_first <- httr::GET(
  url = file.path(root,search_path), 
  httr::add_headers(Authorization = splash_key),
  query = list(page='1',query = query)
)

pages <- ceiling(as.numeric(ret_first$headers$`x-total`)/as.numeric(ret_first$headers$`x-per-page`))

ret_pages <- purrr::map(seq(2,min(10,pages)),
                        function(i){
                          httr::GET(
                            url = file.path(root,search_path), 
                            httr::add_headers(Authorization = splash_key),
                            query = list(page = as.character(i),
                                         query = query)
                          )
                        })

results <- append(list(ret_first),ret_pages)

splash_links_new <- purrr::flatten_chr(purrr::map(results,function(x){
  purrr::map_chr(httr::content(x)$results,function(xx){
    xx$urls$small
  })
}))

slickR::slickR(splash_links_new,height = 200)

splash_links <- c(splash_links,splash_links_new)

usethis::use_data(splash_links, overwrite = TRUE,internal = TRUE)

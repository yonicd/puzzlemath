testthat::context("testing startup of chrome")

testthat::describe('reactivity at startup',{

  it('chrome',{
    
    init_reactor()%>%
      set_golem_args(package_name = 'puzzlemath')%>%
      set_chrome_driver(
        chromever = chrome_version()
      )%>%
      start_reactor()%>%
      expect_reactivity('plot',1)%>%
      expect_reactivity('draw',1)%>%
      kill_app()
    
  })
  
})

testthat::context("testing startup of firefox")

testthat::describe('reactivity at startup',{

  it('firefox',{
    
    init_reactor()%>%
      set_golem_args(package_name = 'puzzlemath')%>%
      set_firefox_driver(
        geckover = gecko_version()
      )%>%
      start_reactor()%>%
      expect_reactivity('plot',1)%>%
      expect_reactivity('draw',1)%>%
      kill_app()
    
  })
  
})


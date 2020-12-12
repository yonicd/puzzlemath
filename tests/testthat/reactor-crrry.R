testthat::context("testing reactivity")

# We run a test with the expectation that the hist tag will be triggered once.

driver_commands <- quote({
  
  # wait for input$n element to be created
  el_game <- reactor::wait(
    test_driver = test_driver,
    expr = test_driver$client$findElement(using = 'id', value = 'game')
  )
  
  el_game$clickElement()
  
  el_draw <- reactor::wait(
    test_driver = test_driver,
    expr = test_driver$client$findElement(using = 'id', value = 'draw')
  )
  
  el_draw$clickElement()
  
})

testthat::describe('reactivity',{

  click_counter <- reactor::test_reactor(
    test_port = 3456,
    expr          = driver_commands,
    test_driver   = reactor::firefox_driver(),
    processx_args = c(
      reactor::runApp_args()[-4],
      glue::glue("options('shiny.port'= 3456,shiny.host='0.0.0.0')"),
      'puzzlemath::run_app()'
    )
  )
  
  it('reactivity at startup',{
    reactor::expect_reactivity(object = click_counter, tag = 'plot',count =  1)
  })
  
  it('reactivity first draw',{
    reactor::expect_reactivity(object = click_counter, tag = 'draw',count =  4)
  })
  
})

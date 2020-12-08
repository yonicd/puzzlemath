testthat::context("testing reactivity")

# We run a test with the expectation that the hist tag will be triggered once.

testthat::describe('reactivity',{

  test <- crrry::CrrryProc$new(
    chrome_bin = pagedown::find_chrome(),
    shiny_port = httpuv::randomPort(),
    chrome_port = httpuv::randomPort(),
    fun = "puzzlemath::run_app()",
    pre_launch_cmd = glue::glue("whereami::set_whereami_log('{tempdir()}')"),
    headless = FALSE
  )
  
  test$wait_for_shiny_ready()
  hist_counter <- reactor::read_reactor(tempdir())
  test$stop()
  
  it('reactivity at startup',{
    reactor::expect_reactivity(object = hist_counter, tag = 'plot',count =  1)
  })
  
})

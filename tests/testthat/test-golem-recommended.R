context("golem tests")

library(golem)

testdir <- file.path('/Users/yonis/projects/puzzlemath',
                     'tests/testthat/testapp')

dir.create(testdir,showWarnings = FALSE)

test_that("app ui", {
  ui <- app_ui()
  expect_shinytaglist(ui)
})

test_that("app server", {
  server <- app_server
  testthat::expect_is(server, "function")
})

# Configure this test to fit your need
test_that(
  "app launches",{
    testthat::skip_on_cran()

    test_pkg_stem <- gsub('/tests/testthat$','',here::here())
    
    test_pkg_name <- tools::file_path_sans_ext(basename(test_pkg_stem))
    
    cat(normalizePath(Sys.getenv("R_HOME")),file = file.path(testdir,'path.txt'))
    
    x <- processx::process$new(
      command = normalizePath(file.path(Sys.getenv("R_HOME"),'R')), 
      c(
        "-e", 
        sprintf("library(%s);run_app()",test_pkg_name)
      ),
      stderr  = file.path(testdir,'err.txt'),
      stdout  = file.path(testdir,'out.txt')
    )
    
    Sys.sleep(5)
    
    testthat::expect_true(x$is_alive())
    x$kill()
  }
)

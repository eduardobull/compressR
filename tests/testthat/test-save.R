test_that("saveZstd and readZstd works", {
  data(mtcars)

  mtcars.file <- file.path(tempdir(), "mtcars.zst")

  expect_silent(saveZST(mtcars, mtcars.file))
  expect_true(file.exists(mtcars.file))

  mtcars.zst <- readZST(mtcars.file)
  expect_identical(mtcars, mtcars.zst)
})

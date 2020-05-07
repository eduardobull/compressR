test_that("compression and decompression works", {
  data(mtcars)

  mtcars.zst <- compressZstd(mtcars)
  expect_false(identical(mtcars, mtcars.zst))

  mtcars.ser <- serialize(mtcars, NULL)
  expect_lt(length(mtcars.zst), length(mtcars.ser))

  mtcars.zst.un <- uncompressZstd(mtcars.zst)
  expect_identical(mtcars, mtcars.zst.un)
})

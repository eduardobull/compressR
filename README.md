[![Build Status](https://travis-ci.com/eduardobull/compressR.svg?branch=master)](https://travis-ci.com/eduardobull/compressR)

About
-----

Dot not use this package.


Installation
------------

To install development version from GitHub:

``` r
devtools::install_github("eduardobull/compressR")
```


Usage
-----

``` r
# Load package
library(compressR)

# Test dataset and temporary file path
data(mtcars)
file_dir <- tempfile()

# Package usage
saveZstd(mtcars, file_dir)
mtcars.zst <- readZstd(file_dir)

# Test code
stopifnot(identical(mtcars, zst))
```


Links
-----

-   [zstandard official site](http://facebook.github.io/zstd/)

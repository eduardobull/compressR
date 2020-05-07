#' Faster Serialization Interface for Single Objects
#'
#' @description
#'  Functions to write a single \code{R} object to a file and
#'  to restore it using the Zstandard algorithm.
#'
#' @param object Object to compress.
#' @param file A connection or the name of the file where the \code{R} object is saved to or read from.
#' @param level Integer. Compression level.
#'
#' @return
#'   For \code{saveZST}, NULL invisibly.
#'
#'   For \code{readZST}, the uncompressed and unserialized \code{R} object.
#'
#' @seealso
#'   \code{\link{serialize}}, \code{\link{saveRDS}} and \code{\link{loadRDS}}.
#'
#' @name save
NULL

#' @rdname save
#' @export
saveZST <- function(object, file, level = 3) {
  writeBin(compressZstd(object), file)
}

#' @rdname save
#' @export
readZST <- function(file) {
  uncompressZstd(readBin(file, "raw", n = file.size(file)))
}

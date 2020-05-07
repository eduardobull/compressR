#' Compress and Decompress Objects Using the Zstandard algorithm
#'
#' @description
#'   Compress and decompress raw vectors and serialized objects using the Zstandard algorithm.
#'
#' @param object Object to (un)compress.
#' @param level Integer. Compression level.
#' @param raw Logical. If FALSE, the \code{object} will be serialized before compression or after decompression.
#'
#' @return (un)compressed, and possibly (un)serialized, data.
#'
#' @name compression
NULL

#' @rdname compression
#' @export
compressZstd <- function(object, level = 3, raw = FALSE) {
  if (!is.raw(object)) {
    if (isTRUE(raw)) {
      stop("object must be a raw vector when raw = TRUE")
    }
    object <- serialize(object, connection = NULL)
  }

  impl_zstdCompress(object, level)
}

#' @rdname compression
#' @export
uncompressZstd <- function(object, raw = FALSE) {
  ret <- impl_zstdUncompress(object)
  if (!isTRUE(raw))
    ret <- unserialize(ret)

  ret
}

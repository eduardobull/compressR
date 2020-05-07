#include <Rcpp.h>
#include <memory.h>
#include "zstd.h"

using namespace Rcpp;

// [[Rcpp::export]]
RawVector impl_zstdCompress(RObject object, int level)
{
    if (!is<RawVector>(object))
        stop("object type must be RAWSXP (raw vector), got %s", type2name(object));

    RawVector src = as<RawVector>(object);

    int max_level = ZSTD_maxCLevel();
    int min_level = ZSTD_minCLevel();
    if (level > max_level)
    {
        warning("level should be <= %d, using %d", max_level, max_level);
        level = max_level;
    }
    else if (level < min_level)
    {
        warning("level should be >= %d, using %d", min_level, min_level);
        level = 1;
    }

    auto buffer_size = ZSTD_compressBound(src.size());
    auto buffer = new char[buffer_size];
    // auto buffer = std::unique_ptr<char[]>(new char[buffer_size]);

    auto output_size = ZSTD_compress(buffer, buffer_size,
                                     src.begin(), src.size(),
                                     level);
    if (ZSTD_isError(output_size))
    {
        delete[] buffer;
        stop("internal error in ZSTD_compress(): %s", ZSTD_getErrorName(output_size));
    }

    auto output = RawVector(buffer, buffer + output_size / sizeof(*buffer));
    delete[] buffer;

    return output;
}

// [[Rcpp::export]]
RawVector impl_zstdUncompress(RObject raw)
{
    if (!is<RawVector>(raw))
        stop("object type must be RAWSXP (raw vector), got %s", type2name(raw));

    RawVector src = as<RawVector>(raw);

    auto output_size = ZSTD_getFrameContentSize(src.begin(), src.size());
    if (output_size == ZSTD_CONTENTSIZE_ERROR)
        stop("internal error in ZSTD_getFrameContentSize(): content size error");
    if (output_size == ZSTD_CONTENTSIZE_UNKNOWN)
        stop("internal error in ZSTD_getFrameContentSize(): size cannot be determined");
    if (output_size == 0)
        return (RawVector());

    RawVector output(output_size);

    auto nb = ZSTD_decompress(output.begin(), output.size(), src.begin(), src.size());
    if (ZSTD_isError(nb))
        stop("internal error in ZSTD_decompress(): %s", ZSTD_getErrorName(nb));

    return output;
}

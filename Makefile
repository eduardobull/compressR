ZSTD_VERSION=1.4.4

R ?= R --vanilla -q
FIND ?= find
ECHO ?= echo -e

default: clean install

clean:
	$(RM) -rv build autom4te.cache config.log config.status src/Makevars ..Rcheck
	$(FIND) . -regex '.*\.s?o$$' -exec rm -v {} \;
	$(FIND) . -regex '.*\.a$$' -exec rm -v {} \;

prepare:
	autoreconf
	$(R) -e "Rcpp::compileAttributes()"

document:
	$(R) -e "devtools::document()"
	$(ECHO) "useDynLib(compressR, .registration=TRUE)" >> NAMESPACE
	$(ECHO) "importFrom(Rcpp, evalCpp)" >> NAMESPACE

check: prepare clean
	_R_CHECK_CRAN_INCOMING_REMOTE_=false $(R) CMD check --as-cran --ignore-vignettes --no-stop-on-test-error .

test:
	$(R) -e "devtools::test()"

build: prepare document clean
	$(R) CMD build --no-build-vignettes .

install: prepare document
	$(R) CMD INSTALL --no-multiarch --strip .

uninstall:
	$(R) CMD REMOVE compressR || true

release: prepare document test clean

install_remote:
	$(R) -e "devtools::install_github('eduardobull/compressR', force = TRUE)"

update_zstd:
	$(RM) -r src/third_party/zstd-*
	curl -L "https://github.com/facebook/zstd/archive/v${ZSTD_VERSION}.tar.gz" | tar xz -C src/third_party \
		zstd-${ZSTD_VERSION}/lib \
		zstd-${ZSTD_VERSION}/build/cmake

.PHONY: default clean prepare document check build install uninstall release install_remote update_zstd

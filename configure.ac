# require at least autoconf 2.61
AC_PREREQ(2.61)

# Process this file with autoconf to produce a configure script.
AC_INIT([compressR])

## Set R_HOME, respecting an environment variable if set
: ${R_HOME=$(R RHOME)}
if test -z "${R_HOME}"; then
    AC_MSG_ERROR([Could not determine R_HOME.])
fi

# We are using C++
AC_LANG(C++)
AC_REQUIRE_CPP

## Check the C++ compiler using the CXX value set
AC_PROG_CXX

AC_CHECK_PROG(CMAKE_CHECK, cmake, yes)
if test x"$CMAKE_CHECK" != x"yes" ; then
    AC_MSG_ERROR([Could not find cmake.])
fi


## --------------------------------------------
## ZSTD
AC_MSG_NOTICE([Configuring zstd library])

AC_SEARCH_LIBS(ZSTD_compress, zstd,
    [AC_SUBST([PKG_LIBS],["${PKG_LIBS} ${LIBS}"])
     AC_SUBST([HAS_ZSTD], [1])],
    [AC_SUBST([PKG_CFLAGS],["${PKG_CFLAGS} -I'\${ZSTD_SRC_DIR}/lib'"])
     AC_SUBST([PKG_CXXFLAGS],["${PKG_CXXFLAGS} -I'\${ZSTD_BUILD_DIR}/lib'"])
     AC_SUBST([PKG_LIBS],["${PKG_LIBS} \${ZSTD_BUILD_DIR}/lib/libzstd.a"])])

AC_MSG_NOTICE([Finished configuring zstd library])


## --------------------------------------------

AC_CONFIG_FILES([src/Makevars])
AC_OUTPUT

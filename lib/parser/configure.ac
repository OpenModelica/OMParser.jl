dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.63])
AC_INIT([OMCompiler],[dev],[https://trac.openmodelica.org/OpenModelica],[openmodelica],[https://openmodelica.org])
AC_SUBST(date)
AC_SUBST(host_short)
AC_SUBST(omc_antlr_jar)
AC_SUBST(antlrinc)
AC_SUBST(antlrlib)
AC_SUBST(CONFIGURE_ARGS)
AC_SUBST(CHECK_C_ERRORS)
AC_SUBST(EXTRA_CFLAGS_GENERATED_CODE)
AC_SUBST(GENERATED_AUTOCONF_FILES)
AC_SUBST(SOURCE_REVISION)
AC_SUBST(OMSHELL_TERMINAL)
AC_SUBST(MODELICA_SPEC_PLATFORM)
AC_SUBST(OPENMODELICA_SPEC_PLATFORM)
AC_SUBST(MAKE)
AC_SUBST(SHREXT)
AC_SUBST(STAEXT)
AC_SUBST(LINK)
AC_SUBST(RPATH)
AC_SUBST(WITH_UUID)
AC_SUBST(OS_TARGET)
AC_SUBST(AR)
AC_SUBST(AR_SH)
AC_SUBST(OMENCRYPTION)
AC_SUBST(BSTATIC)
AC_SUBST(MINGW_EXTRA_LDFLAGS)
AC_SUBST(DLLEXT)
AC_SUBST(JULIA_CFLAGS)
AC_SUBST(JULIA_LDFLAGS)

FINAL_MESSAGES="\nConfigured OMParser.jl successfully using the following options: []"

m4_include([common/m4/pre-commit.m4])
cp common/install-sh common/config.guess common/config.sub ./
m4_include([common/m4/ombuilddir.m4])

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET

# Check for platform arch (32 vs 64 bit)
# sets OMC_TARGET_ARCH_IS_64 to true if 64 bit.
AC_SUBST(OMC_TARGET_ARCH_IS_64)
AC_CHECK_SIZEOF([void *])
if test "x$ac_cv_sizeof_void_p" = "x8" ; then
   OMC_TARGET_ARCH_IS_64="true"
else
   OMC_TARGET_ARCH_IS_64="false"
fi

build_short=$build_cpu-$build_os
host_short=$host_cpu-$host_os

echo "build_short: $build_short"
echo "host_short: $host_short"

if echo $host | grep -i darwin; then
  DARWIN=1
else
  DARWIN=0
fi

if test -z "$AR"; then
  AR=ar
fi

if test -z "$MAKE"; then
  MAKE=make
fi

dnl Disables the default CXXFLAGS="-g -O2"
if test -z "$CXXFLAGS"; then
CXXFLAGS=""
fi

dnl Checks for programs.
AC_LANG([C])
AC_PROG_CC
AC_PROG_CXX
AC_PROG_CPP
AC_PROG_MAKE_SET
AC_PROG_FC

AC_MSG_CHECKING([julia])
AC_PATH_PROG(JULIA, julia, NOPROG, $PATH)
AS_IF([test x"$JULIA" != x"NOPROG"], [], [AC_MSG_ERROR([Please install julia and add its directory to the path before configuring.])])
AC_MSG_RESULT([$JULIA])

AC_MSG_CHECKING([julia path])
JULIA_PATH=`$(dirname "$JULIA")`
AC_MSG_RESULT([$JULIA_PATH])

AC_MSG_CHECKING([julia-config.jl])
AC_PATH_PROG(JULIACONFIG,[julia-config.jl], NOPROG, $PATH:/usr/share/julia:$JULIA_PATH/../share/julia)
AS_IF([test x"$JULIACONFIG" != x"NOPROG"], [], [AC_MSG_ERROR([Please install julia-config.jl and add its directory to the path before configuring.])])
AC_MSG_RESULT([$JULIACONFIG])

AC_MSG_CHECKING([running julia julia-config.jl --cflags])
AS_IF([! $JULIA $JULIACONFIG --cflags], [
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([cannot run $JULIA $JULIACONFIG --cflags successfuly])
], [])
JULIA_CFLAGS=`$JULIA $JULIACONFIG --cflags`
AC_MSG_RESULT([$JULIA_CFLAGS])

AC_MSG_CHECKING([running julia julia-config.jl --ldflags --ldlibs])
AS_IF([! $JULIA $JULIACONFIG --ldflags --ldlibs], [
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([cannot run $JULIA $JULIACONFIG --ldflags --ldlibs successfuly])
], [])
JULIA_LDFLAGS=`$JULIA $JULIACONFIG --ldflags --ldlibs`
AC_MSG_RESULT([$JULIA_LDFLAGS])

AC_ARG_WITH(msys, [  --with-msys[=no]              Point to an msys installation, to setup CPPFLAGS, etc automatically.],
  [
    if echo $host_cpu | grep -q x86_64; then
      MINGWNUM=mingw64
    else
      MINGWNUM=mingw32
    fi
    CPPFLAGS="$CPPFLAGS -I$withval/$MINGWNUM/include -I$withval/$MINGWNUM/include/tre"
    LDFLAGS="$LDFLAGS -L$withval/$MINGWNUM/lib"
    echo "Got: $CPPFLAGS"
  ]
)

CFLAGS_BEFORE="$CFLAGS"
CFLAGS="$CFLAGS -Werror"
AC_MSG_CHECKING([if -Werror works])
AC_TRY_LINK([void abc() {}], [abc();], [AC_MSG_RESULT([ok])], [AC_MSG_ERROR([failed (check your CFLAGS)])])
CFLAGS="$CFLAGS_BEFORE"

dnl Disables the default CFLAGS="-g -O2"
if test -z "$CFLAGS"; then
if test "$DARWIN" = "1"; then
CFLAGS="-O3"
else
CFLAGS_BEFORE="$CFLAGS"
CFLAGS="-O3 -march=native"
AC_MSG_CHECKING([looking for -march=native])
AC_TRY_LINK([void abc() {}], [abc();], [AC_MSG_RESULT([yes])], [AC_MSG_RESULT([no]);CFLAGS="-O3"])
fi
fi

LDFLAGS_BEFORE="$LDFLAGS"
LIBS_BEFORE="$LIBS"
LDFLAGS="$LDFLAGS -Wl,--no-undefined"
AC_MSG_CHECKING([looking for --no-undefined])
AC_TRY_LINK([void abc() {}], [abc();], [AC_MSG_RESULT([yes]);LD_NOUNDEFINED=" -Wl,--no-undefined"], [AC_MSG_RESULT([no])])
LDFLAGS="$LDFLAGS_BEFORE"
LIBS="$LIBS_BEFORE"

TRY_FLAGS="-fno-stack-protector"

if echo $CC | grep -v ccc-analyzer; then # ccc-analyzer calls gcc first and then clang; the CFLAGS need to work in both compilers...

  # GCC 5.x generates bad code due to detecting some impure functions as pure
  if $CC --version | grep -q gcc && $CC -dumpversion | grep -q "^5"; then
    TRY_FLAGS="$TRY_FLAGS -fno-ipa-pure-const"
  fi
  # GCC 8.x generates bad code, too
  if $CC --version | grep -q gcc && $CC -dumpversion | grep -q "^8"; then
    TRY_FLAGS="$TRY_FLAGS -fno-tree-vrp"
  fi
  # GCC 7.x issues:
  # - RUNPATH instead of RPATH, disable that via -Wl,--disable-new-dtags
  # - sqrt from libcolamd is not found in -lm if -Wl,--no-as-needed is not specified
  TRY_FLAGS_LD="$TRY_FLAGS_LD -Wl,--no-as-needed -Wl,--disable-new-dtags"
fi

AC_MSG_CHECKING([for flags to append to CFLAGS ($TRY_FLAGS)])
for flag in $TRY_FLAGS; do
  OLD_CFLAGS="$CFLAGS"
  CFLAGS="$RUNTIMECFLAGS $flag -Werror"
  AC_TRY_LINK([], [return 0;], [CFLAGS="$OLD_CFLAGS $flag"],[CFLAGS="$OLD_CFLAGS"])
done
AC_MSG_RESULT([$CFLAGS])

AC_MSG_CHECKING([for flags to append to LDFLAGS ($TRY_FLAGS_LD)])
for flag in $TRY_FLAGS_LD; do
  OLD_LDFLAGS="$LDFLAGS"
  LDFLAGS="$flag -Werror"
  AC_TRY_LINK([], [return 0;], [LDFLAGS="$OLD_LDFLAGS $flag"],[LDFLAGS="$OLD_LDFLAGS"])
done
AC_MSG_RESULT([$LDFLAGS])

OLD_CFLAGS="$CFLAGS"
for flag in -Wno-parentheses-equality -Wno-unused-variable; do
  CFLAGS="$RUNTIMECFLAGS $flag -Werror"
  AC_TRY_LINK([], [return 0;], [
    CHECK_C_ERRORS="$CHECK_C_ERRORS $flag"
    EXTRA_CFLAGS_GENERATED_CODE="$EXTRA_CFLAGS_GENERATED_CODE $flag"
  ],[])
done
for flag in -Werror=implicit-function-declaration -Werror=incompatible-pointer-types; do
  CFLAGS="$RUNTIMECFLAGS $flag -Werror"
  AC_TRY_LINK([], [return 0;], [
    CHECK_C_ERRORS="$CHECK_C_ERRORS $flag"
    EXTRA_CFLAGS_GENERATED_CODE="$EXTRA_CFLAGS_GENERATED_CODE $flag"
  ],[])
done
CFLAGS="$OLD_CFLAGS"

AC_LANG([C])

if test ! "$DARWIN" = "1"; then

if test "`getconf LONG_BIT`" = "64"; then

AC_MSG_CHECKING([getconf LONG_BIT = 64 CFLAGS])

if echo $CFLAGS | grep -q -- -fPIC; then
  AC_MSG_RESULT([already got -fPIC])
else
  CFLAGS_BEFORE="$CFLAGS"
  CFLAGS="$CFLAGS -fPIC -Werror"
  AC_TRY_LINK([void abc() {}], [abc();], [AC_MSG_RESULT([adding -fPIC]); CFLAGS="$CFLAGS_BEFORE -fPIC"; FPIC="-fPIC"], [AC_MSG_RESULT([does not need -fPIC]); CFLAGS="$CFLAGS_BEFORE"])
fi

else

AC_MSG_CHECKING([getconf LONG_BIT != 64 CFLAGS])

if echo $CFLAGS | grep -q -- -fPIC; then
  AC_MSG_RESULT([already got -fPIC])
else
  CFLAGS_BEFORE="$CFLAGS"
  CFLAGS="$CFLAGS -fPIC -Werror"
  AC_TRY_LINK([void abc() {}], [abc();], [AC_MSG_RESULT([adding -fPIC]); CFLAGS="$CFLAGS_BEFORE -fPIC"; FPIC="-fPIC"], [AC_MSG_RESULT([does not need -fPIC]); CFLAGS="$CFLAGS_BEFORE"])
fi

fi

else # Is Darwin

AC_LANG_PUSH([C++])
OLD_CXXFLAGS=$CXXFLAGS
for flag in -stdlib=libstdc++; do
  CXXFLAGS="$OLD_CXXFLAGS $flag"
  AC_TRY_LINK(
    [#include <regex>],
    [int main() {return 0;}],
    [LDFLAGS_LIBSTDCXX="$flag"],
    [CXXFLAGS="$OLD_CXXFLAGS"])
done
AC_LANG_POP([C++])

fi

m4_include([common/m4/ax_cxx_compile_stdcxx.m4])
AX_CXX_COMPILE_STDCXX(14,[noext],[optional])

if test "`getconf LONG_BIT`" = "32"; then
dnl Simulations spin forever unless -msse2 -mfpmath=sse is set

CFLAGS_BEFORE=$CFLAGS
CFLAGS="-mfpmath=sse -Werror"
AC_MSG_CHECKING([for floating point bugs])
AC_TRY_LINK([int abc() {}], [abc();], [AC_MSG_RESULT([force SSE2]); FPMATHFORTRAN="-msse -mfpmath=sse"], [AC_MSG_RESULT([no]); FPMATHFORTRAN=-ffloat-store])
CFLAGS=$CFLAGS_BEFORE

fi # End x86-specific CFLAGS

dnl check for environment variables

dnl Checks for libraries.

if test ! "$DARWIN" = "1" && (! echo $host | grep -q mingw ); then
  LIBS=""
  AC_SEARCH_LIBS(clock_gettime,rt,[],[AC_MSG_ERROR([clock_gettime missing])])
  LIBRT="$LIBS"
  LIBS=""
fi

dnl Checks for header files.
AC_HEADER_STDC

AC_CHECK_HEADERS(sys/time.h, [], [AC_MSG_ERROR(Missing header file sys/time.h)])
# AC_CHECK_HEADERS(sqlite3.h, [], [AC_MSG_ERROR(Missing header file sqlite3.h)])

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_TYPE_SIZE_T

dnl Checks for library functions.
AC_FUNC_VPRINTF
AC_CHECK_FUNCS(getcwd select strdup strerror)

AC_ARG_VAR(RUNTIMECC, [Selects a compiler to be used to compile generated code. It is more important to compile fast than to generate fast code for the runtime compiler.])
AC_ARG_VAR(RUNTIMECFLAGS, [CFLAGS for the selected runtime compiler (defaults to -falign-functions -mfpmath=sse -fno-dollars-in-identifiers -fPIC as long as neither gives warnings to the CC). Note that heavy optimisations may cause the run-time to be faster while increasing compile-time. -O0 is often best.])

CC_OLD="$CC"
CFLAGS_OLD="$CFLAGS"
if test ! -z "$RUNTIMECC"; then
  CC="$RUNTIMECC"
else
  RUNTIMECC="$CC"
fi
AC_MSG_CHECKING([runtime compiler])
if test -z "$RUNTIMECFLAGS"; then
  CFLAGS="$FPIC -Werror"
  AC_TRY_LINK([], [return 0;], [AC_MSG_RESULT($CC ok);],[AC_MSG_ERROR($CC failed)])
  CFLAGS="$FPIC"
  AC_MSG_CHECKING([runtime compiler CFLAGS])
  RUNTIMECFLAGS="$FPIC"
  for flag in -falign-functions -mfpmath=sse -fno-dollars-in-identifiers -Wno-parentheses-equality; do
    CFLAGS="$FPIC $flag -Werror"
    AC_TRY_LINK([], [return 0;], [RUNTIMECFLAGS="$RUNTIMECFLAGS $flag"],[])
  done
else
  CFLAGS="$RUNTIMECFLAGS $FPIC -Werror"
  AC_TRY_LINK([], [return 0;], [RUNTIMECFLAGS="$RUNTIMECFLAGS $FPIC"],[AC_MSG_ERROR([$CC $CFLAGS -Werror failed])])
fi
AC_MSG_RESULT([$RUNTIMECFLAGS])

CC="$CC_OLD"
CFLAGS="$CFLAGS_OLD"



LIBS=""
AC_SEARCH_LIBS(dlopen,dl)
LIBDL="$LIBS"
LIBS=""

if ! (echo "$host" | grep -q "mingw"); then
  AC_CHECK_FUNC(socket,[LIBSOCKET=""],
   [AC_MSG_CHECKING([for libsocket]);
    AC_CHECK_LIB(socket, socket,[AC_MSG_RESULT([yes]); LIBSOCKET="-lsocket"],[AC_MSG_ERROR([neither socket nor libsocket.a found])])
  ])

  AC_CHECK_FUNC(gethostbyname,
   [LIBNSL=""],
   [AC_MSG_CHECKING([for libnsl]);
    AC_CHECK_LIB(nsl,gethostbyname, [AC_MSG_RESULT([yes]); LIBNSL="-lnsl"],[AC_MSG_ERROR([neither gethostbyname nor libnsl.a found])])
  ])
fi

LIBS=""
AC_CHECK_HEADERS(uuid/uuid.h,
  [AC_CHECK_LIB(uuid,uuid_unparse,
    [WITH_UUID="#define WITH_LIBUUID 1";OMC_LIBS="$OMC_LIBS -luuid";LIBUUID="-luuid"],
    [WITH_UUID="/* Without libuuid */"])],
  [WITH_UUID="/* Without libuuid */"]
)

LIBS=""

AC_CHECK_LIB(pthread,pthread_self,[RT_LDFLAGS="$RT_LDFLAGS $LIBS"],[AC_MSG_ERROR([pthreads not found])])

LIBS=""

OLD_LDFLAGS="$LDFLAGS"
LDFLAGS="$LDFLAGS -Wl,-Bstatic  -Wl,-Bdynamic"
AC_TRY_LINK([], [return 0;], [BSTATIC="true"],[BSTATIC="false"; AC_MSG_RESULT(["Don't know the flags to force static linking"])])
LDFLAGS="$OLD_LDFLAGS"

MINGW_EXTRA_LDFLAGS=""

AC_SUBST(CONFIG_OS)
if test "$DARWIN" = "1"; then
  EXE=""
  STAEXT=".a"
  SHREXT=".dylib"
  DLLEXT=".dylib"
  LIBGC="$OMBUILDDIR/lib/$host_short/omc/libomcgc.a"
  LIBSIMULATION=libSimulationRuntimeC.dylib
  LIBRUNTIME=libOpenModelicaRuntimeC.dylib
  LIBFMIRUNTIME=libOpenModelicaFMIRuntimeC.dylib
  LIBFMILIB=libfmilib_shared.dylib
  FMILIB_SHARED=ON
  LIBCMINPACKLIB=libcminpack.dylib
  LIBZMQLIB=libzmq.dylib
  CMINPACKLIB_SHARED=ON
  RT_LDFLAGS_SIM="$LDFLAGS $RT_LDFLAGS -lexpat -lomcgc -lpthread -lm $LIBDL -lstdc++"
  RT_LDFLAGS_SIM_OPTIONAL="$SUNDIALS_LDFLAGS $IPOPT_LDFLAGS $SUITESPARSE_LDFLAGS -llis -lcdaskr -lcminpack -liconv"
  RT_LDFLAGS="$LDFLAGS $RT_LDFLAGS -lomcgc -lm -lpthread $LIBDL -lstdc++"
  RT_LDFLAGS_OPTIONAL="$RT_LDFLAGS_OPTIONAL -liconv"
  # All libraries are dynamically linked; we don't need anything else
  RT_LDFLAGS_GENERATED_CODE="$LDFLAGS -lOpenModelicaRuntimeC $LD_LAPACK -lm"
  RT_LDFLAGS_GENERATED_CODE_SIM="$LDFLAGS -lSimulationRuntimeC $LD_LAPACK -lm -lomcgc"
  RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU="$LDFLAGS $LD_LAPACK -lm$LD_NOUNDEFINED"
  RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU_STATIC=" -lSimulationRuntimeFMI $RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU"
  RT_LDFLAGS_SHARED=
  OMCRUNTIME_SHARED_LDFLAGS="$RT_LDFLAGS -Wl,-undefined -Wl,dynamic_lookup $LIBLPSOLVE55 -lzmq $LIBUUID $RT_LDFLAGS_OPTIONAL"
  LINK="cp -fr"
  RPATH="-Wl,-rpath,'@loader_path/../lib/$host_short/omc/'"
  RPATH_QMAKE="-Wl,-rpath,'@loader_path/../../../../lib/$host_short/omc',-rpath,'@loader_path/../../../../lib/',-rpath,'$PREFIX/lib/$host_short/omc',-rpath,'$PREFIX/lib/'"
  OS_TARGET="osx"
  LIS_LDFLAGS="-Wl,-install_name,@rpath/liblis.dylib"
  AR_SH="sh -x ar.sh"
  OMC_LIBS="$OMC_LIBS -Wl,-undefined -Wl,dynamic_lookup"
  BOOTSTRAP_STATIC=""
  CMAKE_LDFLAGS_UNDEFINED_LOOKUP="-Wl,-undefined -Wl,dynamic_lookup"
  SUITESPARSE_SHARED=ON
  CONFIG_OS=OSX
elif echo "$host" | grep -iq "mingw"; then
  EXE=".exe"
  # Yes, we build static libs on Windows, so the "shared" extension is .a
  STAEXT=".a"
  SHREXT=".dll"
  DLLEXT=".dll"
  LIBGC="$OMBUILDDIR/lib/$host_short/omc/libomcgc.a"
  LIBSIMULATION=libSimulationRuntimeC.a
  LIBRUNTIME=libOpenModelicaRuntimeC.a
  LIBFMIRUNTIME=libOpenModelicaFMIRuntimeC.a
  LIBFMILIB=libfmilib.a
  FMILIB_SHARED=OFF
  LIBCMINPACKLIB=libcminpack.a
  LIBZMQLIB=libzmq.a
  CMINPACKLIB_SHARED=OFF
  RT_LDFLAGS_SIM="$LDFLAGS $RT_LDFLAGS -lstdc++ -lomcgc -lexpat -lm"
  RT_LDFLAGS_SIM_OPTIONAL="$SUNDIALS_LDFLAGS $IPOPT_LDFLAGS $SUITESPARSE_LDFLAGS -llis -lcminpack"
  RT_LDFLAGS="$LDFLAGS $RT_LDFLAGS -lomcgc -lexpat -Wl,-Bstatic -lpthread -Wl,-Bdynamic -static-libgcc -lm"
  RT_LDFLAGS_OPTIONAL="$RT_LDFLAGS_OPTIONAL"
  RT_LDFLAGS_GENERATED_CODE="$LDFLAGS -lOpenModelicaRuntimeC $RT_LDFLAGS"
  RT_LDFLAGS_GENERATED_CODE_SIM="$LDFLAGS -lSimulationRuntimeC -lcdaskr $RT_LDFLAGS_SIM"
  RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU="$LDFLAGS $LD_LAPACK -lm $LD_NOUNDEFINED"
  RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU_STATIC=" -Wl,-Bstatic -lSimulationRuntimeFMI $LDFLAGS $LD_LAPACK -Wl,-Bdynamic -lm $LD_NOUNDEFINED"
  LINK="cp -frl"
  # No RPATH in Windows :(
  RPATH=""
  RPATH_QMAKE=""
  OS_TARGET="windows"
  AR_SH="$AR -ru"
  LDFLAGS_SOCKET=" -lwsock32"
  BOOTSTRAP_STATIC=""
  AC_CHECK_TOOL(WINDRES, windres, [AC_MSG_ERROR([no])])
  CMAKE_EXTRA_DEFINES="-DCMAKE_SYSTEM_NAME=Windows -DCMAKE_RC_COMPILER=$WINDRES"
  CPPFLAGS="$CPPFLAGS -DMSYS2_AUTOCONF=1"
  OMC_LIBS="$OMC_LIBS -lwsock32 -Wl,-Bstatic -lstdc++ -ltre  -lintl -liconv -Wl,-Bdynamic -lshlwapi"
  SUITESPARSE_SHARED=OFF
  CONFIG_OS=Windows_NT
  MINGW_EXTRA_LDFLAGS="-Wl,-Bstatic -lwinpthread -Wl,-Bdynamic"
else
  EXE=""
  STAEXT=".a"
  SHREXT=".so"
  DLLEXT=".so"
  LIBGC="$OMBUILDDIR/lib/$host_short/omc/libomcgc.so"
  LIBSIMULATION=libSimulationRuntimeC.so
  LIBRUNTIME=libOpenModelicaRuntimeC.so
  LIBFMIRUNTIME=libOpenModelicaFMIRuntimeC.so
  LIBFMILIB=libfmilib_shared.so
  FMILIB_SHARED=ON
  LIBCMINPACKLIB=libcminpack.so
  LIBZMQLIB=libzmq.so
  CMINPACKLIB_SHARED=ON
  # For static runtime on Linux:
  # -Wl,-whole-archive -lSimulationRuntimeC -Wl,-no-whole-archive
  RT_LDFLAGS_SIM="$LDFLAGS -Wl,-z,origin -Wl,-rpath,'\$\$ORIGIN' $RT_LDFLAGS $LIBRT -lexpat -lomcgc -lpthread -lm $LIBDL -lstdc++ -rdynamic"
  RT_LDFLAGS_SIM_OPTIONAL="$SUNDIALS_LDFLAGS $IPOPT_LDFLAGS $SUITESPARSE_LDFLAGS -llis -lcdaskr -lcminpack"
  RT_LDFLAGS="$LDFLAGS $RT_LDFLAGS -lomcgc $LIBRT -lpthread -lm $LIBDL -lstdc++ -rdynamic"
  RT_LDFLAGS_OPTIONAL="$RT_LDFLAGS_OPTIONAL"
  # All libraries are dynamically linked; we don't need anything else
  RT_LDFLAGS_GENERATED_CODE="$LDFLAGS -lOpenModelicaRuntimeC $LD_LAPACK -lm -lomcgc -lpthread -rdynamic" # Some of our tests refer to the testsuite itself
  RT_LDFLAGS_GENERATED_CODE_SIM="$LDFLAGS -lSimulationRuntimeC $LD_LAPACK -lm -lomcgc -lpthread -rdynamic$LD_NOUNDEFINED"
  RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU="$LDFLAGS $LD_LAPACK -lm -lpthread -rdynamic $LD_NOUNDEFINED"
  RT_LDFLAGS_GENERATED_CODE_SOURCE_FMU_STATIC=" -Wl,-Bstatic -lSimulationRuntimeFMI $LDFLAGS $LD_LAPACK -Wl,-Bdynamic -lm -lpthread -rdynamic $LD_NOUNDEFINED"
  LINK="cp -frl"
  LDFLAGS="$LDFLAGS -Wl,-rpath-link,$OMBUILDDIR/lib/$host_short/omc"
  RT_LDFLAGS_SHARED="-Wl,-rpath-link,$OMBUILDDIR/lib/$host_short/omc"
  OMCRUNTIME_SHARED_LDFLAGS="$RT_LDFLAGS $LIBLPSOLVE55 -lzmq $LIBUUID"
  RPATH="-Wl,-z,origin -Wl,-rpath,'\$\$ORIGIN/../lib/$host_short/omc' -Wl,-rpath,'\$\$ORIGIN'"
  RPATH_QMAKE="-Wl,-z,origin -Wl,-rpath,\\'\\\$\$ORIGIN/../lib/$host_short/omc\\' -Wl,-rpath,\\'\\\$\$ORIGIN\\'"
  OS_TARGET="linux"
  AR_SH="$AR -ru"
  BOOTSTRAP_STATIC=""
  SUITESPARSE_SHARED=ON
  CONFIG_OS=`echo $host_os | sed s/-gnu//`
fi

AC_ARG_WITH(ENCRYPTION, [  --with-ENCRYPTION                 Compile SEMLA and link omc to it],
[
  if test "$withval" = "yes"; then
    OMENCRYPTION=yes
  else
    OMENCRYPTION=no
  fi
], [
    OMENCRYPTION=no
])


m4_include([common/m4/semver.m4])

SOURCE_REVISION="$SOURCE_REVISION$NON_FREE_VERSION"

AC_MSG_CHECKING([for OpenModelica platform name])
# I don't really agree with the Modelica specification since "Intel 32-bit" is
# very unspecific.
# Also, they forgot about Mac users.
# We will just default to use the $host_cpu-$host_os (treating gnu-linux as linux).
# We then patch it up a bit to look for Modelica/FMU standard locations as well.

if test "$DARWIN" = "1"; then
OPENMODELICA_SPEC_PLATFORM=`echo $host_cpu-darwin | sed "s/i@<:@3456@:>@86/i386/" | tr "@<:@:upper:@:>@ " "@<:@:lower:@:>@-"`
else
OPENMODELICA_SPEC_PLATFORM=`echo $host_cpu-$host_os | sed "s/linux-gnu/linux/" | sed "s/linux-gnu/linux/" | sed "s/i@<:@3456@:>@86/i386/" | tr "@<:@:upper:@:>@ " "@<:@:lower:@:>@-"`
fi

AC_MSG_RESULT([$OPENMODELICA_SPEC_PLATFORM])
AC_MSG_CHECKING([for Modelica platform name])
if test "$OPENMODELICA_SPEC_PLATFORM" = "x86_64-linux" -o "$OPENMODELICA_SPEC_PLATFORM" = "i386-linux"; then
  MODELICA_SPEC_PLATFORM=`echo $OPENMODELICA_SPEC_PLATFORM | sed "s/x86_64-linux/linux64/" | sed "s/i.86-linux/linux32/"`
elif echo "$OPENMODELICA_SPEC_PLATFORM" | grep -q darwin; then
  MODELICA_SPEC_PLATFORM=`echo $OPENMODELICA_SPEC_PLATFORM | sed "s/x86_64-darwin/darwin64/" | sed "s/i.86-darwin/darwin32/"`
else
  MODELICA_SPEC_PLATFORM=$OPENMODELICA_SPEC_PLATFORM
fi
AC_MSG_RESULT([$MODELICA_SPEC_PLATFORM])

CFLAGS="$CFLAGS"

OLD_CXXFLAGS="$CXXFLAGS"
CXXFLAGS="$CFLAGS $CXXFLAGS -Werror"
AC_LANG_PUSH([C++])
AC_TRY_LINK([], [], [CXXFLAGS="$CFLAGS $OLD_CXXFLAGS"], [CXXFLAGS="$OLD_CXXFLAGS"])
AC_LANG_POP([C++])

date=`date "+%Y-%m-%d %H:%M:%S"`

CONFIGURE_ARGS="$ac_configure_args"

GENERATED_AUTOCONF_FILES="Makefile"

AC_OUTPUT(${GENERATED_AUTOCONF_FILES})

echo -e "$FINAL_MESSAGES"

#!/bin/bash

SHORT_OS_STR=$(uname -s)

if [ "${SHORT_OS_STR:0:5}" == "Linux" ]; then

    mkdir -p src/build
    cd src/build

    # XXX: Hack for clang compilation.
    CMAKE_OPTS_EXTRA=''
    if [ -e "$(command -v c++)" ] && c++ -v 2>&1 | grep -q clang; then
      CMAKE_OPTS_EXTRA='-D CMAKE_TOOLCHAIN_PREFIX="llvm-" -D CMAKE_CXX_STANDARD=11' 
    fi

    cmake -G"$CMAKE_GENERATOR" $CMAKE_OPTS_EXTRA \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_SKIP_RPATH:bool=ON \
        -D CMAKE_INSTALL_PREFIX="$PREFIX" \
        -D CMAKE_INSTALL_SYSCONFDIR="$PREFIX/etc" \
        -D CURL_INCLUDE_DIR:PATH="$PREFIX/include" \
        -D CURL_LIBRARY:FILEPATH="$PREFIX/lib/libcurl.so" \
        -D Leptonica_LIB:FILEPATH="$PREFIX/lib/liblept.so" \
        -D Tesseract_INCLUDE_BASEAPI_DIR:PATH="$PREFIX/include" \
        -D Tesseract_LIB:FILEPATH="$PREFIX/lib/libtesseract.so" \
        ..

        # -D log4cplus_INCLUDE_DIR:PATH="$PREFIX/include" \
        # -D log4cplus_LIB:FILEPATH="$PREFIX/lib/liblog4cplus.so" \
        # -D CMAKE_INSTALL_RPATH="$PREFIX/lib" \
        # -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \

    make -j${CPU_COUNT}

    make install
    
    # FYI: See src/bindings/python/CMakeLists.txt; it manually installs into 
    # `${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages`.
    # Here's an attempted work-around for Python > 2.7:
    # if [ "$PY_VER" -gt "2.7" ]; then 
    cd ../bindings/python
    #cd $SRC_DIR/src/bindings/python
    ${PYTHON} setup.py install || exit 1;
    # fi

fi

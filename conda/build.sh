#!/bin/bash

SHORT_OS_STR=$(uname -s)

mkdir -p src/build
cd src/build

# log4cplus
git clone https://github.com/log4cplus/log4cplus.git --branch REL_1_1_3-RC8 --single-branch --recurse-submodules
cd log4cplus
./configure --prefix="$PREFIX"
make
make install
cd ..

# XXX: Hack for clang compilation.
CMAKE_OPTS_EXTRA=''
if [ -e "$(command -v c++)" ] && c++ -v 2>&1 | grep -q clang; then
    CMAKE_OPTS_EXTRA='-D CMAKE_TOOLCHAIN_PREFIX="llvm-" -D CMAKE_CXX_STANDARD=11'
fi

cmake -G"$CMAKE_GENERATOR" $CMAKE_OPTS_EXTRA \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_SKIP_RPATH:bool=ON \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_INSTALL_SYSCONFDIR="$PREFIX/etc" \
    -DENABLE_CONFIG_VERIFICATION=ON \
    -DCURL_INCLUDE_DIR:PATH="$PREFIX/include" \
    -DCURL_LIBRARY:FILEPATH="$PREFIX/lib/libcurl.so" \
    -DLeptonica_LIB:FILEPATH="$PREFIX/lib/liblept.so" \
    -DTesseract_INCLUDE_BASEAPI_DIR:PATH="$PREFIX/include" \
    -DTesseract_LIB:FILEPATH="$PREFIX/lib/libtesseract.so" \
    -Dlog4cplus_INCLUDE_DIR:PATH="$PREFIX/include" \
    -Dlog4cplus_LIB:FILEPATH="$PREFIX/lib/liblog4cplus.so" \
    ..

make -j${CPU_COUNT}
make install

cd ../bindings/python
${PYTHON} setup.py install || exit 1;

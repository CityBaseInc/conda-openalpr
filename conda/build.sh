#!/bin/bash

CMAKE_GENERATOR="Unix Makefiles"
CMAKE_ARCH="-m"$ARCH
SHORT_OS_STR=$(uname -s)

if [ "${SHORT_OS_STR:0:5}" == "Linux" ]; then
    DYNAMIC_EXT="so"
    IS_OSX=0
    mkdir -p src/build
    cd src/build

    # FYI: Might need the following for Ubuntu 16.04 (xenial)
    # sudo apt-get install --reinstall libgnutls-openssl27 libcurl4-gnutls-dev

    # After installing, we might need to set LD_LIBRARY_PATHS when activating
    # the conda env?
    # See https://conda.io/docs/user-guide/tasks/manage-environments.html#macos-and-linux 

    cmake ..  -G"$CMAKE_GENERATOR" \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_SKIP_RPATH:bool=ON \
        -D CMAKE_INSTALL_PREFIX="$PREFIX" \
        -D CMAKE_INSTALL_SYSCONFDIR="$PREFIX/etc" \
        ..

    #-D CMAKE_INSTALL_RPATH="$PREFIX/lib" \
    #-D CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \

    make -j${CPU_COUNT}

    make install
    
    # FYI: See src/bindings/python/CMakeLists.txt; it manually installs into 
    # `${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages`.
    # Here's an attempted work-around for Python > 2.7:
    cd ../bindings/python
    #cd $SRC_DIR/src/bindings/python
    ${PYTHON} setup.py install || exit 1;

fi

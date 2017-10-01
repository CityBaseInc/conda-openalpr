#!/bin/bash

CMAKE_GENERATOR="Unix Makefiles"
CMAKE_ARCH="-m"$ARCH
SHORT_OS_STR=$(uname -s)

if [ "${SHORT_OS_STR:0:5}" == "Linux" ]; then
    DYNAMIC_EXT="so"
    IS_OSX=0
	mkdir -p src/build
	cd src/build

	rm -rf ./CMakeCache.txt ./CMakeFiles/

	# FYI: Might need the following for Ubuntu 16.04 (xenial)
	# sudo apt-get install --reinstall libgnutls-openssl27 libcurl4-gnutls-dev

	# After installing, we might need to set LD_LIBRARY_PATHS when activating
	# the conda env.
	# See https://conda.io/docs/user-guide/tasks/manage-environments.html#macos-and-linux 
	 
	#-D CMAKE_CXX_STANDARD=11
	#-D CURL_LIBRARY=/usr/lib/x86_64-linux-gnu/libcurl.so

	cmake ..  -G"$CMAKE_GENERATOR" \
		-D CMAKE_BUILD_TYPE=RELEASE \
		-D Tesseract_PKGCONF_LIBRARY_DIRS:PATH="$PREFIX/lib" \
		-D Leptonica_LIB:FILEPATH=$PREFIX/lib/liblept.so \
		..

	#-D CMAKE_INSTALL_PREFIX="$PREFIX" \
	#-D CMAKE_INSTALL_RPATH="$PREFIX/lib" \
	#-D CMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
	#-D CMAKE_INSTALL_SYSCONFDIR="$PREFIX" \
	#CURL_INCLUDE_DIR:PATH
	#CURL_LIBRARY:FILEPATH
	#CURL_INCLUDE_DIR:PATH=/usr/include
	#CURL_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libcurl.so
	#JAVA_AWT_INCLUDE_PATH:PATH=/usr/lib/jvm/java-8-openjdk-amd64/include
	#JAVA_AWT_LIBRARY:FILEPATH=/usr/lib/jvm/default-java/jre/lib/amd64/libjawt.so
	#JAVA_INCLUDE_PATH:PATH=/usr/lib/jvm/java-8-openjdk-amd64/include
	#JAVA_INCLUDE_PATH2:PATH=/usr/lib/jvm/java-8-openjdk-amd64/include/linux
	#JAVA_JVM_LIBRARY:FILEPATH=/usr/lib/jvm/default-java/jre/lib/amd64/server/libjvm.so
	#Leptonica_LIB:FILEPATH=/opt/anaconda3/envs/gtt/lib/liblept.so
	#OpenCV_DIR:PATH=/opt/anaconda3/envs/gtt/share/OpenCV
	#Tesseract_INCLUDE_BASEAPI_DIR:PATH=/usr/include
	#Tesseract_INCLUDE_CCMAIN_DIR:PATH=/usr/include/tesseract
	#Tesseract_INCLUDE_CCSTRUCT_DIR:PATH=/usr/include/tesseract
	#Tesseract_INCLUDE_CCUTIL_DIR:PATH=/usr/include/tesseract
	#Tesseract_LIB:FILEPATH=/usr/lib/libtesseract.so
	#log4cplus_INCLUDE_DIR:PATH=/usr/include
	#log4cplus_LIB:FILEPATH=/usr/lib/x86_64-linux-gnu/liblog4cplus.so
	#-DCMAKE_SKIP_RPATH:bool=ON \
	#-DLeptonica_LIB="$PREFIX/lib/liblept.so" \

	make -j${CPU_COUNT}

	make install
fi

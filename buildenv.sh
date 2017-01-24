#!/bin/bash

# we have in our build directory:
# build/
# 	build/
#		eman2.daily
#			cmakecache.txt
# 	co/
#		eman2.daily (eman2 git repo)
#	images
#		eman2.daily
#			packaged binary
# 	local
#		compiled dependencies
# 	src
#		source for dependencies
#	stage
#		eman2.daily
#			EMAN2
#				binary pre-packaging

# in src, we have downloaded the following packages (untarred/unzipped):
FFTW=fftw-3.3.6-pl1
BOOST=boost_1_63_0
FREETYPE=freetype-2.7
JPEG=jpeg-8d
SIP=sip-4.19
CMAKE=cmake-3.7.2
FTGL=ftgl-2.1.3~rc5
PNG=libpng-1.6.28
TIFF=tiff-3.8.2
DB=db-5.3.28
PYQT=PyQt4_gpl_x11-4.12
PYTHON=Python-2.7.8
HDF=hdf5-1.10.0-patch1
QT=qt-everywhere-opensource-src-4.8.7
GSL=gsl-2.3
SSL=openssl-1.0.2j
ZLIB=zlib-1.2.11
FFI=libffi-3.2.1

# save the current environment so we can eventually return to it
CURRENT_PATH=${PATH}
CURRENT_PYTHONPATH=${PYTHONPATH}
CURRENT_LDFLAGS=${LDFLAGS}
CURRENT_LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
CURRENT_CPPFLAGS=${CPPFLAGS}
CURRENT_CFLAGS=${CFLAGS}

BUILD=${HOME}/build
mkdir -p ${BUILD}/local

LOCAL=${BUILD}/local
SRC=${BUILD}/src # Source directory
THREADS=8

# BUILD/INSTALL CMAKE
cd ${SRC}/${CMAKE}
./configure --prefix=${LOCAL}
make -j${THREADS} install

export PATH=${LOCAL}/bin:${PATH}

# BUILD/INSTALL ZLIB
cd ${SRC}/${ZLIB}
./configure --enable-shared --prefix=${LOCAL}
make -j${THREADS} install

# BUILD/INSTALL FFTW
cd ${SRC}/${FFTW}
./configure --enable-static=no --enable-shared=yes --prefix=${LOCAL}
make -j${THREADS} install
./configure --enable-static=no --enable-shared=yes --enable-float --prefix=${LOCAL}
make -j${THREADS} install

# BUILD/INSTALL GSL
cd ${SRC}/${GSL}
./configure --prefix=${LOCAL} --disable-static --enable-shared
make -j${THREADS} install

# BUILD/INSTALL BERKELEY-DB
cd ${SRC}/${BOOST}/build_unix
../dist/configure --prefix=${LOCAL}
make -j${THREADS} install

# BUILD/INSTALL FREETYPE
cd ${SRC}/${FREETYPE}
./configure --prefix=${LOCAL} --enable-shared
make -j${TREADS} install
mv ${LOCAL}/include/freetype2/* ${LOCAL}/include # required for new versions of freetype/ftgl
# ln -s ${LOCAL}/include/freetype2 ${LOCAL}/include/freetype # take care of this in CMake # this doesn't cut it anymore

# BUILD/INSTALL FTGL
cd ${SRC}/${FTGL}
export LDFLAGS="-L${LOCAL}/lib -lGLU -lGL -lglut -lm"
export LD_LIBRARY_PATH="${LOCAL}/lib"
export CPPFLAGS="-I${LOCAL}/include"
export CFLAGS="-I${LOCAL}/include"
./configure --prefix=${LOCAL} --enable-shared
make -j${THREADS} install

# BUILD/INSTALL HDF5
cd ${SRC}/${HDF}
./configure --enable-shared --prefix=${LOCAL}
make -j${TREADS} install

# BUILD/INSTALL PNG
cd ${SRC}/${PNG}
./configure --enable-shared --prefix=${LOCAL}
make -j${TREADS} install

# BUILD/INSTALL TIFF
cd ${SRC}/${TIFF}
./configure --enable-shared --prefix=${LOCAL}
make -j${TREADS} install

# BUILD/INSTALL JPEG
cd ${SRC}/${JPEG}
./configure --enable-shared --prefix=${LOCAL}
make -j${TREADS} install

# BUILD/INSTALL QT4
cd ${SRC}/${QT}
./configure --prefix=${LOCAL} -shared -no-qt3support -no-sql -no-stl -no-xmlpatterns -no-multimedia -no-audio-backend -no-phonon -no-phonon-backend -no-webkit -no-accessibility -no-javascript-jit -no-script -no-scripttools -no-declarative -no-declarative-debug
make install

# BUILD/INSTALL OPENSSL (for python)
cd ${SRC}/${SSL}
./config --prefix=${LOCAL}/ssl shared
make -j${THREADS} install

# BUILD/INSTALL FFI (for python)
cd ${SRC}/${FFI}
./config --prefix=${LOCAL}
make -j${THREADS} install

# BUILD/INSTALL PYTHON
cd ${SRC}/${PYTHON}

# we use a modified version of the Modules/Setup.dist code, following these instructions:
# http://stackoverflow.com/questions/5937337/building-python-with-ssl-support-in-non-standard-location
export LDFLAGS="-L${LOCAL}/lib -L${LOCAL}/lib/openssl"
export LD_LIBRARY_PATH="${LOCAL}/lib"
export CPPFLAGS="-I${LOCAL}/include -I${LOCAL}/ssl"
export CFLAGS="-I${LOCAL}/include -I${LOCAL}/ssl"
./configure --enable-shared --prefix ${LOCAL} --enable-unicode=ucs4
make -j${THREADS} install

export PYTHONPATH=${LOCAL}/lib/python2.7/site-packages

# install pip into EMAN2 python environment
cd ${SRC}
python get-pip.py

# fix https related issues
pip install requests[security] --upgrade
pip install pyopenssl ndg-httpsclient pyasn1

# install EMAN2 python dependencies
pip install ipython pyopengl pyopengl-accelerate readline numpy matplotlib bsddb3 scipy theano

# Install SIP
cd ${SRC}/${SIP}
python configure.py
make -j${THREADS} install

# Install PyQt4
cd ${SRC}/${PYQT}
python ./configure.py --confirm-license -e QtCore -e QtGui -e QtOpenGL
make -j${THREADS} install

# BUILD/INSTALL BOOST
cd ${SRC}/${BOOST}
./bootstrap.sh --prefix=${LOCAL} --with-libraries=python,system,filesystem,thread
./b2 install --prefix=${LOCAL}

# CREATE EXTLIB CONTENTS (ONLY PART OF "LOCAL")

cd ${BUILD}

mkdir -p ${BUILD}/build/eman2.daily
mkdir -p ${BUILD}/co
mkdir -p ${BUILD}/extlib/eman2.daily
mkdir -p ${BUILD}/images
mkdir -p ${BUILD}/stage/eman2.daily

EXTLIB=${BUILD}/extlib/eman2.daily
cp -al ${LOCAL} ${EXTLIB} # hard link contents of local to extlib

cp -al ${LOCAL}/ssl/lib/* ${EXTLIB}/lib
cp -al ${LOCAL}/ssl/lib/pkgconfig/* ${EXTLIB}/lib/pkgconfig
cp -al ${LOCAL}/ssl/bin/* ${EXTLIB}/bin
cp -al ${LOCAL}/ssl/include ${EXTLIB}/include
mkdir ${EXTLIB}/ssl
cp -al ${LOCAL}/ssl/ssl/* ${EXTLIB}/ssl

# look through EXTLIB and prune unnecessary libraries (particularly the Qt shared library objects)
# rm ${EXTLIB}/lib/libQt*
# cp -al ${LOCAL}/lib/libQtCore* ${EXTLIB}/lib
# cp -al ${LOCAL}/lib/libQtGui* ${EXTLIB}/lib
# cp -al ${LOCAL}/lib/libQtOpenGL* ${EXTLIB}/lib
# cp -al ${LOCAL}/lib/libQtSvg* ${EXTLIB}/lib

# rm ${EXTLIB}/bin/cmake
#rm ${EXTLIB}/bin/ a lot of stuff was removed from bin
#rm ${EXTLIB}/include/ a lot of stuff was removed from include, particularly Qt stuff
# Discuss other unnecessary things with Steve. This binary may be slightly larger than the others due to new dependencies.

# ccmake ../co/eman2 # using preconfigured cmake cache to link against contents of extlib.
# Would be better to modify cmake to find things automatically.

# initial build as test with modified version of Ian's build.py script
python build.py checkout build install package --threads 8

# need to copy .config/matplotlibrc for new matplotlib to work properly
# need to update the eman2-installer script?

# reload the previous environment
export PATH=${CURRENT_PATH}
export PYTHONPATH=${CURRENT_PYTHONPATH}
export LDFLAGS=${CURRENT_LDFLAGS}
export LD_LIBRARY_PATH=${CURRENT_LD_LIBRARY_PATH}
export CPPFLAGS=$CURRENT_CPPFLAGS}
export CFLAGS=${CURRENT_CFLAGS}

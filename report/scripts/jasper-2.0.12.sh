#!/bin/bash

#source /opt/intel/bin/compilervars.sh intel64
#source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=jasper
version=2.0.12
install=/opt/libs
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}
wget --quiet http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.12.tar.gz
tar -xvzf jasper-2.0.12.tar.gz
cd jasper-2.0.12
mkdir build-src
cd build-src
cmake3 -G "Unix Makefiles" -H/opt/src/jasper-2.0.12 -B/opt/src/jasper-2.0.12/build-src -DCMAKE_INSTALL_PREFIX=/opt/libs/jasper-2.0.12
make
make install
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## jasper
set version 2.0.12
proc ModulesHelp { } {
puts stderr "This module enables Jasper library"
puts stderr " "
}
module-whatis "Jasper Library"

set prefix /opt/libs/jasper-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#
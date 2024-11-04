#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=gm_et_linux_64
version=4.32.0
install=/opt/tools
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p $prefix
wget --quiet http://topaz.gatech.edu/GeneMark/tmp/GMtool_p3kJb/gm_et_linux_64.tar.gz
tar -xvzf $soft.tar.gz
cd $soft
cp -rf gm_key /home/*/.gm_key
cp ./* ${prefix}
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## GeneMarkET-ES
set version 4.32.0
proc ModulesHelp { } {
puts stderr "This module enables the use of GeneMark ET/ES software"
puts stderr " "
}
module-whatis "GeneMarkET-ES"
set prefix /opt/tools/gm_et_linux_64
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}:${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/GeneMarkET-ES/.modulerc
#%Module
if {![info exists gmes-done]} {
module-version gmes/4.32.0 4.32
module-version gmes/4.32 default
set gmes-done 1
}
#EOF#
#!/bin/bash
. /opt/intel/bin/compilervars.sh intel64
soft=charm-6.7.1
src=/opt/src
prefix=/opt/tools/${soft}
cd $src
mkdir -p $prefix
wget --quiet http://charm.cs.illinois.edu/distrib/charm-6.7.1.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure    --prefix=$prefix
make -j20
make install
mkdir -p /opt/tools/modulefiles/charm

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/charm/6.7.1
#%Module#####################################################################
## Charm++ parallel object-oriented programming language
set version 6.7.1
proc ModulesHelp { } {
puts stderr "This module enables Charm++ programming language."
puts stderr "The environment variables \$PATH,"
puts stderr " \$LD_LIBRARY_PATH, and \$MANPATH accordingly."
puts stderr "This version includes support for MPI."
#puts stderr "Is compiled with CUDA 8.0"
puts stderr " "
}
module-whatis "Charm++ object-oriented programming language"
set prefix /opt/tools/charm-${version}
#if { [module-info mode remove] && !([module-info mode switch1] \
#|| [module-info mode switch3]) } {
#puts stderr "Module [module-info name] must not be unloaded."
#puts stderr "Use \"module switch\" if you need to replace it."
#break
#}
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/

#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/charm/.modulerc
#%Module
if {![info exists charm-done]} {
module-version charm/6.7.1 6.7
module-version mpich/6.7 default
set charm-done 1
}

#EOF#

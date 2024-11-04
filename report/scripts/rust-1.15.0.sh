#!/bin/bash
soft=rust-1.15.0
src=/opt/src
prefix=/opt/compilers/$soft
cd $src
mkdir -p $prefix
wget --quiet https://static.rust-lang.org/dist/rust-1.15.0-x86_64-unknown-linux-gnu.tar.gz
tar -xvzf ${soft}-x86_64-unknown-linux-gnu.tar.gz
cd ${soft}-x86_64-unknown-linux-gnu
./install.sh --prefix=$prefix
mkdir -p /opt/compilers/modulefiles/rust

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/rust/1.15.0
#%Module#####################################################################
## rust
set version 1.15.0
proc ModulesHelp { } {
puts stderr "This module enables the use of rust language compiler."
}
module-whatis "Rust language compiler"
set prefix /opt/compilers/rust-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path ETCPATH ${prefix}/etc
#EOF#
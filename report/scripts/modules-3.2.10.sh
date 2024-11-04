#!/bin/bash

# requiere primero descargar el src por aparte del sitio 
# http://downloads.sourceforge.net/project/modules/Modules/modules-3.2.10/modules-3.2.10.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmodules%2Ffiles%2FModules%2Fmodules-3.2.10%2F&ts=1476913443&use_mirror=ufpr

. /opt/intel/bin/compilervars.sh intel64
soft=modules-3.2.10
src=/opt/src
cd $src
tar -xvzf modules-3.2.10.tar.gz
cd $soft
./configure --with-module-path=/opt/modules --prefix=/opt
make -j20
make install
ln -s /opt/Modules/3.2.10 /opt/Modules/default

/bin/cat <<"#EOF#" > /etc/profile.d/modules.sh
trap "" 1 2 3

MID=/opt/Modules/default/init/

case "$0" in
        -bash|bash|*/bash) test -f $MID/bash && . $MID/bash ;;
           -ksh|ksh|*/ksh) test -f $MID/ksh && . $MID/ksh ;;
              -sh|sh|*/sh) test -f $MID/sh && . $MID/sh ;;
                        *) test -f $MID/sh && . $MID/sh ;;

#default for scripts
esac 

MODULERCFILE=/opt/modulerc
export MODULERCFILE
module add null

trap - 1 2 3

#EOF#


/bin/cat <<"#EOF#" > /etc/profile.d/modules.csh
if ($?tcsh) then
	set modules_shell="tcsh"
else
	set modules_shell="csh"
endif

if ( -f /opt/Modules/default/init/${modules_shell} ) then
   source /opt/Modules/default/init/${modules_shell}
endif

setenv MODULERCFILE /opt/modulerc
module add null

unset modules_shell


#EOF#


/bin/cat <<"#EOF#" > /opt/modulerc
#%Module
append-path MODULEPATH /opt/libs/modulefiles
append-path MODULEPATH /opt/tools/modulefiles
append-path MODULEPATH /opt/compilers/modulefiles
append-path MODULEPATH /opt/python/modulefiles
append-path MODULEPATH /opt/debug/modulefiles

# system-wide pre-loaded standard modules:
set defmodules {}
foreach m $defmodules {
  if {! [ is-loaded $m ] } {
    module load $m
    }
}

#EOF#

printf "Listo. Por favor proceda a ejecutar el siguiente comando\nscp /etc/profile.d/modules.* nodo:/etc/profile.d/\ndonde nodo corresponde a la IP\no nombre del host donde se desea contar con\nmódulos de ambiente."

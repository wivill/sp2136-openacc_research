#!/bin/bash

for j in cadejos-0 cadejos-1 cadejos-2 cadejos-3 cadejos-4 login-0 login-1 login-2 login-3 tule-00 tule-01 tule-02 tule-03 zarate-0a zarate-0b zarate-0c zarate-0d zarate-1a zarate-1b zarate-1c zarate-1d zarate-2a zarate-2b zarate-2c zarate-2d zarate-3a zarate-3b zarate-3c zarate-3d zarate-4a zarate-4b zarate-4c zarate-4d sol3 bigdata-00 bigdata-01 bigdata-00 surtr ; do
	ssh $j exit
	ssh ${j}.cnca exit
done

file=/etc/skel/.ssh/known_hosts

cp -rf ~/.ssh/known_hosts $file

for i in /home/*/.ssh/ ; do
	cp -f $file $i
done

cd /home

for h in * ; do
	chown $h:cluster /home/$h/.ssh/known_hosts
done

cd /root/scripts
#!/bin/bash

if [ "$(ls -A /data/svn)" ]; then 
	echo "svn dir not empty. skip setup"
else
	echo "svn dir empty, setting new svn repo"
	touch /data/svn/passwdfile
	touch /data/svn/accessfile
	svnadmin create /data/svn/test
	chown -R apache:subversion /data/svn
	exit
fi

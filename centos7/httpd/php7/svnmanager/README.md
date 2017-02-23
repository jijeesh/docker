# docker-centos7-svnmanager

login to mysql

create database svn_manager;

GRANT ALL PRIVILEGES ON `svn_manager`.* TO 'svnsqluser'@'172.%' IDENTIFIED BY 'svnsqlpassword' WITH GRANT OPTION;


if any problem find 
just login into the cotainer and run the command name config_svn.sh

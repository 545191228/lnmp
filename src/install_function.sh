#!/bin/bash
##########################################
## LNMP install shell                   ##
## Version:v1.0.0                       ##
## Author:shp                           ##
## Date:2016-06-24                      ##
##########################################

#Default install lnmp
function defaultInstall()
{
    source ${srcDir}/defaultInstall.sh
}

#Custom install lnmp
function customInstall()
{
    if [ "$1" == "" ];then
        echo -e "\n=========================================================================\n"
        echo -e "\nPlease input (nginx|php|mysql|node|redis|xsearch),then start install"
        echo -e "\nThe queue nfs ftp to be installed separately in the package directory"
        echo -e "\n=========================================================================\n"
    fi
    software=''
    read -p "Please Input:" software
    source ${srcDir}/customInstall.sh ${software}
}
#Install init
function install_init()
{
    if ! grep '^COMMON_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        source ${srcDir}/installInit.sh
        readPackageConf
        echo 'COMMON_INSTALL' >> ${insLog}
    fi    

}

#Read versionConf
function readPackageConf()
{
    source ${srcDir}/packageConf.sh
}

#Install nodeJS
function install_node()
{
    if ! grep '^NODE_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        source ${srcDir}/install_node.sh
        echo 'NODE_INSTALL' >> ${insLog}
    fi
}

#Install redis
function install_redis()
{
    if ! grep '^REDIS_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        source ${srcDir}/install_redis.sh
        echo 'REDIS_INSTALL' >> ${insLog}
    fi
}

#Install xsearch
function install_xsearch()
{
    if ! grep '^XSEARCH_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        source ${srcDir}/install_xsearch.sh
        echo 'XSEARCH_INSTALL' >> ${insLog}
    fi
}

#Install mysql
function install_mysql()
{
    if ! grep '^MYSQL_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        source ${srcDir}/install_mysql.sh
        echo 'MYSQL_INSTALL' >> ${insLog}
    fi
}

#Install nginx
function install_nginx()
{
    if ! grep '^NGINX_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        addUser
        source ${srcDir}/install_nginx.sh
        echo 'NGINX_INSTALL' >> ${insLog}
    fi
}

#Install php
function install_php()
{
    if ! grep '^PHP_INSTALL$' ${insLog} > /dev/null 2>&1 ;then
        source ${srcDir}/install_php.sh
        echo 'PHP_INSTALL' >> ${insLog}
    fi
}

# Add user
function addUser()
{
	groupadd www
	useradd www -r -s /sbin/nologin -g www
	usermod -d $web_root www
}

exit_() {
    echo -en "\033[1;40;32m$*\033[0m\n";exit
}


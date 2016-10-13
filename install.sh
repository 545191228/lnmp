#!/bin/bash
#set -x
#set -e
#set -n

##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

lnmp_version="v1.0.0"

for i in $(find conf/ src/ package/ -name *.cnf;find conf/ src/ package/ -name "*.sh";echo install.sh)
do
echo "begin to modify the fileencoding of $i to utf-8"
vi +":set fileencoding=utf-8" +":set fileformat=unix" +":wq" $i
done

clear
echo -e "\n=========================================================================\n"
echo -e "\nLNMP ${lnmp_version} for CentOS/RadHat/Ubuntu Linux OS,written by shp"
echo -e "\nA tool to auto-compile & install Nginx+MySQL+PHP on Linux "
echo -e "\n=========================================================================\n"

#Global variables
readonly curDir="$(cd $(dirname $0) && pwd)"
readonly confDir=${curDir}/conf
readonly srcDir=${curDir}/src
readonly softDir=${curDir}/package

readonly insLog=${curDir}/lnmp.log
readonly insInfo=${curDir}/lnmp.info

#Get the machine info
if [ -n "`cat /etc/redhat-release 2 > /dev/null | grep CentOS`" ];then
    readonly osName=CentOS
#elif [ -n "`cat /etc/issue | grep bian`" ];then
#    readonly osName=Debian
#elif [ -n "`cat /etc/issue | grep Ubuntu`" ];then
#    readonly osName=Ubuntu
#elif [ -n "`cat /etc/redhat-release 2>/dev/null  |grep Red`" ];then
#    readonly osName=RedHat
else
    echo -e "\033[31mDoes not support this OS, Please contact the author! \033[0m"
    kill -9 $$
fi
readonly osVersion=`cat /etc/issue | head -1 | awk '{print $3}'`
readonly cpuType=`uname -p`
readonly lineCount="$( grep 'processor' /proc/cpuinfo | sort -u | wc -l)"
readonly memTotal=`free -m | grep Mem | awk '{print  $2}'` 

if [ "$lineCount" -le 2 ]; then
	lineCount=2
fi

source ${srcDir}/install_function.sh

#Install lnmp
function installLnmp()
{
	installType='n'
	echo "Please select Default or Custom Install"
	echo "Custom Install Please Input y"
	echo "Default Install Please Input n or Press Enter"
	read -p "Please Input [y/n]:" installType
	
	case "$installType" in
	y|Y|Yes|YEs|YES|yes|yES|yEs|YeS|yeS)
	echo "You selected custom install"
	installType="y"
	;;
	n|N|No|NO|no|nO)
	echo "You selected default install"
	installType="n"
	;;
	*)
	echo "INPUT error,will go default install"
	installType="n"
	esac
	
	if [ "${installType}" = 'y' ]; then
		customInstall
	else
		defaultInstall
	fi
}

installLnmp 2>&1 | tee $insLog
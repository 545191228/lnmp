#!/bin/bash
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

lnmp_version="v0.5.0"

clear
echo "========================================================================="
echo "LNMP ${lnmp_version} for CentOS/RadHat/Ubuntu Linux VPS  Written by shp"
echo "========================================================================="
echo "A tool to auto-compile & install Nginx+MySQL+PHP on Linux "
echo "========================================================================="

#Global variables
readonly curDir="$(cd $(dirname $0) && pwd)"
readonly confDir=${curDir}/conf
readonly srcDir=${curDir}/src
readonly softDir=${curDir}/package

#Get the machine info
readonly osName=`cat /etc/issue |head -1|awk '{print $1}'`
readonly osVersion=`cat /etc/issue |head -1|awk '{print $3}'`
readonly cpuType=`uname -p`
readonly lineCount="$( grep 'processor' /proc/cpuinfo | sort -u | wc -l)"
readonly memTotal=`free -m | grep Mem | awk '{print  $2}'` 

if [ "$lineCount" -le 2 ]; then
	lineCount=2
fi

function get_char()
{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

#Default install lnmp
function defaultInstall()
{
	source ${srcDir}/defaultInstall.sh
}

#Custom install lnmp
function customInstall()
{
	source ${srcDir}/customInstall.sh
}

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
	
	echo ""
	echo "Press any key to start...or Press Ctrl+c to cancel"
	char=`get_char`
	
	#if [ "$installType" = 'y' ]; then
		#customInstall
	#else
		defaultInstall
	#fi
}

installLnmp 2>&1 | tee ${curDir}/lnmp.log


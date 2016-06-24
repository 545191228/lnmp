#!/bin/bash
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

#install xunsearch

cd $softDir

if [ -s "xunsearch-full-latest.tar.bz2" ]; then
	echo "xunsearch-full-latest.tar.bz2 [found]"
else
	echo "Error: xunsearch-full-latest.tar.bz2 not found!!download now......"
	wget -c -P ${softDir} http://www.xunsearch.com/download/xunsearch-full-latest.tar.bz2  || exit_ "wget stopped."
fi

echo "Unzip the installation package"
tar jxf xunsearch-full-latest.tar.bz2
echo "unzip over"

cd xunsearch-full-1.4.8
yum install zlib-devel
./setup.sh --prefix=/usr/local/xunsearch
echo "/usr/local/xunsearch/bin/xs-ctl.sh -b inet start" >> /etc/rc.local
chmod +x /etc/rc.d/rc.local
/usr/local/xunsearch/bin/xs-ctl.sh -b inet start

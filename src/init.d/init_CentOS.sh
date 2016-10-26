#!/bin/bash
##########################################
## LNMP install shell                   ##
## Version:v1.0.0                       ##
## Author:shp                           ##
## Date:2016-06-29                      ##
##########################################


#Set timezone
rm -Rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum install -y ntp
ntpdate -u pool.ntp.org
date

#Disable SeLinux
if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi
	
/etc/init.d/iptables restart

# Install needed packages	
yum install -y wget patch make cmake gcc gcc-c++ gcc-g77 flex bison file libtool libtool-libs autoconf automake kernel-devel libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese gettext gettext-devel ncurses-devel gmp-devel pspell-devel unzip libcap re2c enchant enchant-devel libtidy libtidy-devel libicu-devel postgresql-devel logrotate crontabs


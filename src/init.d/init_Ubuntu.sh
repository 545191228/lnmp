#!/bin/bash
##########################################
## LNMP install shell                   ##
## Version:v1.0.0                       ##
## Author:shp                           ##
## Date:2016-06-29                      ##
##########################################


# Set timezone
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Update time
[ -z "`grep 'cn.pool.ntp.org' /var/spool/cron/crontabs/root`" ] && { echo "#55 23 * * * `which ntpdate` -u cn.pool.ntp.org tick.ucla.edu timekeeper.isi.edu tock.gpsclock.com ntp.nasa.gov > /dev/null 2>&1" >> /var/spool/cron/crontabs/root;chmod 600 /var/spool/cron/crontabs/root; }

service cron restart

#Disable SeLinux
if [ -s /etc/selinux/config ]; then
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
fi

#apt-get -y update
#apt-get -y upgrade 
# Install needed packages
# automake zlib* fiex* libmcrypt libmcrypt-dev perl gettext libXpm libicu*  ntp ntpdate bc patch sysstat
apt-get -y install gcc g++ make autoconf libjpeg8 libjpeg8-dev libpng12-0 libpng12-dev libpng3 libfreetype6 libfreetype6-dev libxml2 libxml2-dev zlib1g zlib1g-dev libc6 libc6-dev libglib2.0-0 libglib2.0-dev bzip2 libzip-dev libbz2-dev libbz2-1.0 libXpm-dev libicu-dev libncurses5 libncurses5-dev libaio1 libaio-dev curl libcurl3 libcurl4-openssl-dev e2fsprogs libkrb5-3 libkrb5-dev libltdl-dev libidn11 libidn11-dev openssl libssl-dev libtool libevent-dev re2c libsasl2-dev libxslt1-dev patch vim zip unzip tmux htop wget bc expect rsync git telnet lrzsz chkconfig

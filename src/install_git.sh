#!/bin/sh
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-devel

wget -c -P ${softDir} https://www.kernel.org/pub/software/scm/git/git-2.4.0.tar.gz || exit_ "make wget stoped."

tar zxvf git-2.4.0.tar.gz

cd git-2.4.0

make prefix=/usr/local all || exit_ "make all stoped."
make prefix=/usr/local install || exit_ "make install stoped."

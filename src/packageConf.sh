#!/bin/bash
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

## This is LNMP user configuration.
## You can modify these settings to fit for your need.
## Please read setting instruction carefully before change it.

## Install packages version.

php_big_ver='5.6'
php_ver='5.6.23'

mysql_big_ver='5.6'
mysql_ver='5.6.30'

nginx_ver='1.10.1'

node_ver='v0.12.9'

redis_ver='2.8.17'

php_redis='2.2.5'

xs_ver=''
memcache_ver=''


## some dir config

base_root='/usr/local'
web_data_root='/data'

nginx_base_dir=${base_root}'/nginx'
nginx_conf_dir=${nginx_base_dir}'/conf'
nginx_vhost_dir=${nginx_conf_dir}'/vhosts'

php_base_dir=${base_root}'/php'
php_conf_dir=${php_base_dir}'/etc'
php_ext_dir=${php_base_dir}'/'

mysql_base_dir=${base_root}'/mysql'
mysql_data_dir=${mysql_base_dir}'/data'
mysql_root_pwd='root'

node_base_dir=${base_root}'/node'

redis_base_dir=${base_root}'/redis'

xs_base_dir=${base_root}'/xunsearch'


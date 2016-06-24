#!/bin/bash
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

#install redis

cd $softDir
redis_package="redis-${redis_ver}.tar.gz"

if [ -s "${redis_package}" ]; then
	echo "${redis_package} [found]"
else
	echo "Error: ${redis_package} not found!!download now......"
	wget -c -P ${softDir} http://download.redis.io/releases/${redis_package} || exit_ "wget stopped."
fi

echo "Unzip the installation package"
tar zxf $redis_package
echo "unzip over"

cp -Rf redis-${redis_ver} /usr/local/redis
cd /usr/local/redis
make -j$lineCount MALLOC=libc || exit_ "make stopped."

ln -s /usr/local/redis/src/redis-benchmark /usr/bin/redis-benchmark
ln -s /usr/local/redis/src/redis-check-aof /usr/bin/redis-check-aof
ln -s /usr/local/redis/src/redis-check-dump /usr/bin/redis-check-dump
ln -s /usr/local/redis/src/redis-cli /usr/bin/redis-cli
ln -s /usr/local/redis/src/redis-sentinel /usr/bin/redis-sentinel
ln -s /usr/local/redis/src/redis-server /usr/bin/redis-server

/usr/bin/redis-server &

cd $softDir
# install phpredis 

redis_php_package="phpredis-${php_redis}.tar.gz"

if [ -s "${redis_php_package}" ]; then
	echo "${redis_php_package} [found]"
else
	echo "Error: ${redis_php_package} not found!!download now......"
	wget -c -P ${softDir} http://shp.name/lnmp/${redis_php_package} || exit_ "wget stopped."
fi

tar zxf $redis_php_package
cd phpredis-${php_redis}
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make -j$lineCount || exit_ "make stopped." 
make install || exit_ "make install stopped."

#php_extension_dir=`php -i |grep extension_dir |awk '{print $3}'|head -1`
php_extension_dir=`php-config --extension-dir`

cat >>/usr/local/php/ext/php.ini<<EOF
[REDIS]
extension = ${php_extension_dir}/phpredis.so
EOF



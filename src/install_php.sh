#!bin/bash
##########################################
## LNMP install shell                   ##
## Version:v1.0.0                       ##
## Author:shp                           ##
## Date:2016-06-24                      ##
##########################################

#####
##   --enable-re2c-cgoto   need to use "computed,goto,gcc" extension
##   --with-gd  need to use "libpng,libjpeg"; add extension --with-jpeg-dir --with-png-dir --with-ttf --with-freetype-dir
##   --with-png-dir   need to user  --with-zlib-dir
####

CheckAndDownloadFiles
InstallDependsAndOpt

cd $softDir

php_package=php-${php_ver}.tar.gz

# check install package
if [ -s "${php_package}" ]; then
	echo "${php_package} [found]"
else
	echo "Error: ${php_package} not found!!download now......"
	wget -c -P ${softDir} http://cn2.php.net/distributions/${php_package} || exit_ "wget stopped."
fi

# install
echo "unzip install package"
tar zxf $php_package
echo "unzip end"

cd php-$php_ver

./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --disable-rpath --enable-re2c-cgoto --disable-short-tags --with-libxml-dir --with-openssl --with-bz2 --with-zlib --enable-zip --enable-bcmath --with-zlib-dir --with-gettext --enable-mbstring --with-mcrypt --with-enchant --with-curl --enable-exif --disable-fileinfo --enable-ftp --with-gd --with-jpeg-dir --with-png-dir  --with-freetype-dir --enable-gd-native-ttf --enable-shmop --enable-pcntl --enable-sysvsem --enable-sysvshm --enable-sysvmsg --with-tidy --enable-ftp --with-openssl --with-mhash --enable-sockets --with-xmlrpc --enable-soap --without-pear --enable-mbregex --with-iconv-dir --with-pgsql --with-pod-pgsql --enable-shared

make -j${lineCount} ZEND_EXTRA_LIBS='-liconv' && make install

rm -f /usr/bin/php
ln -s /usr/local/php/bin/php /usr/bin/php
ln -s /usr/local/php/bin/phpize /usr/bin/phpize
ln -s /usr/local/php/sbin/php-fpm /usr/bin/php-fpm

echo "Copy new php configure file."
mkdir -p /usr/local/php/etc
cp php.ini-production /usr/local/php/etc/php.ini

# php confing
echo "Modify php.ini......"
sed -i 's/post_max_size = 8M/post_max_size = 50M/g' /usr/local/php/etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /usr/local/php/etc/php.ini
sed -i 's/;date.timezone =/date.timezone = PRC/g' /usr/local/php/etc/php.ini
sed -i 's/short_open_tag = Off/short_open_tag = On/g' /usr/local/php/etc/php.ini
sed -i 's/; cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sed -i 's/; cgi.fix_pathinfo=0/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/php/etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 300/g' /usr/local/php/etc/php.ini
sed -i 's/register_long_arrays = On/;register_long_arrays = On/g' /usr/local/php/etc/php.ini
sed -i 's/magic_quotes_gpc = On/;magic_quotes_gpc = On/g' /usr/local/php/etc/php.ini
sed -i 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' /usr/local/php/etc/php.ini

cd $softDir

#echo "Install ZendGuardLoader for PHP ${php_ver}"
#if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
  # wget -c http://downloads.zend.com/guard/$zend_var/ZendGuardLoader-$php_zend-linux-glibc23-x86_64.tar.gz
#  tar zxvf ZendGuardLoader-${php_zend}-linux-glibc23-x86_64.tar.gz
#  mkdir -p /usr/local/zend/
#  cp ZendGuardLoader-${php_zend}-linux-glibc23-x86_64/php-$php_big_ver.x/ZendGuardLoader.so /usr/local/zend/
#else
  # wget -c http://downloads.zend.com/guard/$zend_var/ZendGuardLoader-$php_zend-linux-glibc23-i386.tar.gz
#  tar zxvf ZendGuardLoader-${php_zend}-linux-glibc23-i386.tar.gz
#  mkdir -p /usr/local/zend/
#  cp ZendGuardLoader-${php_zend}-linux-glibc23-i386/php-$php_big_ver.x/ZendGuardLoader.so /usr/local/zend/
#fi

#echo "Write ZendGuardLoader to php.ini......"
#cat >>/usr/local/php/etc/php.ini<<EOF
#;eaccelerator

#;ionCube

#[Zend Optimizer] 
#zend_extension=/usr/local/zend/ZendGuardLoader.so
#EOF

echo "Copy php-fpm configure file......"
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
sed -i 's/;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/g' /usr/local/php/etc/php-fpm.conf

echo "Copy php-fpm init.d file......"
cp $softDir/php-${php_ver}/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm


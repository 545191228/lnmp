#!bin/bash
##########################################
## LNMP install shell                   ##
## Version:v1.0.0                       ##
## Author:shp                           ##
## Date:2016-06-24                      ##
##########################################

#install nginx init

cd $softDir


#http://nginx.org/download/nginx-${nginx_ver}.tar.gz
if [ -s pcre-8.35.tar.gz ]; then
  echo "pcre-8.35.tar.gz [found]"
  else
  echo "Error: pcre-8.35.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://shp.name/lnmp/pcre-8.35.tar.gz || exit_ "wget pcre stoped."
fi

if [ -s openssl-1.0.1t.tar.gz ]; then
  echo "openssl-1.0.1t.tar.gz [found]"
  else
  echo "Error: openssl-1.0.1t.tar.gz not found!!!download now......"
  wget -c -P ${softDir} https://www.openssl.org/source/openssl-1.0.1t.tar.gz || exit_ "wget openssl stoped."
fi

if [ -s zlib-1.2.8.tar.gz ]; then
  echo "zlib-1.2.8.tar.gz [found]"
  else
  echo "Error: zlib-1.2.8.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://zlib.net/zlib-1.2.8.tar.gz || exit_ "wget openssl stoped."
fi

if [ -s nginx-${nginx_ver}.tar.gz ]; then
  echo "nginx-${nginx_ver}.tar.gz [found]"
  else
  echo "Error: nginx-${nginx_ver}.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://nginx.org/download/nginx-${nginx_ver}.tar.gz || exit_ "wget nginx stoped."
fi

tar zxf openssl-1.0.1t.tar.gz
mv openssl-1.0.1t /usr/local/openssl

tar zxf zlib-1.2.8.tar.gz
mv zlib-1.2.8 /usr/local/zlib

tar zxvf pcre-8.35.tar.gz
mv pcre-8.35 /usr/local/pcre

cd /usr/local/pcre
./configure || exit_ "configure stoped."
make -j${lineCount} || exit_ "make stoped."
make install || exit_ "make install stoped."

cd $softDir

ldconfig

tar zxvf nginx-${nginx_ver}.tar.gz
cd nginx-${nginx_ver}/
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-file-aio --with-http_realip_module --with-openssl=/usr/local/openssl --with-zlib=/usr/local/zlib --with-pcre=/usr/local/pcre || exit_ "configure stoped."
make -j${lineCount} || exit_ "make stoped."
make install || exit_ "make install stoped."
cd ../

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

rm -f /usr/local/nginx/conf/nginx.conf

cp $confDir/nginx.conf /usr/local/nginx/conf/nginx.conf

cd $softDir
mkdir -p ${web_root}/wwwroot/default/www
chmod +w ${web_root}/wwwroot/default/www
mkdir -p ${web_root}/wwwroot/default/logs
chmod 777 ${web_root}/wwwroot/default/logs
mkdir -p /usr/local/nginx/conf/vhost

chown -R www:www $web_root/wwwroot/default

cp $softDir/code/init.d.nginx /etc/init.d/nginx
chmod +x /etc/init.d/nginx

mkdir -p /var/run/nginx
chmod 777 /var/run/nginx

/etc/init.d/nginx start
/etc/init.d/nginx stop

touch /usr/local/nginx/conf/vhost/default.conf
cat >>/usr/local/nginx/conf/vhost/default.conf<<EOF
server {
    listen              80;
    server_name        shop;
    root               ${web_root}/wwwroot/default/www;
    aio threads;
    if (!-e $request_filename)
    {
        rewrite ^/(shop|admin|circle|microshop|cms)/(.*)html$ /$1/index.php?$2;

    }
    location ~ /(cache|upload|sql_back|resource|templates)/.*\.php$
    {
        deny all;
    }
    location ~ .*\.(log|sql|sh|ini|bak|gz)$
    {
        deny all;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|zip|exe|txt|ico|rar|htm|html)$
    {
        expires 30d;
    }
    location ~ .*\.(swf|mp3|wmv|wma|mp4|mpg|flv)$
    {
        expires 30d;
    }
    location ~ .*\.(js|css)?$
    {
        expires 30h;
    }

    location ~ \.php$ {
        try_files $uri =404;
        access_log  ${web_root}/wwwroot/default/logs/access.log  main buffer=16k;
        error_log  ${web_root}/wwwroot/default/logs/error.log error;
        fastcgi_pass 127.0.0.1:9000;
        include fastcgi.conf;
        fastcgi_param PATH_INFO $request_uri;
    }

}
EOF


cat >> ${insInfo} <<EOF
=============== mysql install information =====================
安装版本:
mysql-${mysql_ver}
安装目录:
/usr/local/mysql
配置文件路径:
/etc/my.cnf
数据目录：
${mysql_data_dir}
控制命令:
service mysql {start|stop|force-quit|restart|reload|status}
EOF
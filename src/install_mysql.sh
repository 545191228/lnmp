#!bin/bash
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

#mysql install

cd $softDir

mysql_package="mysql-${mysql_ver}.tar.gz"

if [ -s "${mysql_package}" ]; then
	echo "${mysql_package} [found]"
else
	echo "Error: ${mysql_package} not found!!download now......"
	wget -c -P ${softDir} http://cdn.mysql.com/Downloads/MySQL-${mysql_big_ver}/${mysql_package} || exit_ "make wget stoped."
fi

tar zxf ${mysql_package}
cd mysql-${mysql_ver}
echo "============================Install MySQL ${mysql_ver}=================================="
groupadd mysql
useradd -s /sbin/nologin -M -g mysql mysql

rm -f /etc/my.cnf
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=$mysql_data_dir -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306 -DSYSCONFDIR=/etc -DWITH_SSL=system -DINSTALL_SHAREDIR=share || exit_ "cmake stoped."
make -j $lineCount || exit_ "make stoped."
make install || exit_ "make install stoped."

mkdir -p ${mysql_data_dir}
chown -R mysql:mysql ${mysql_data_dir}

cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf
sed "/# basedir = ...../i\ basedir = /usr/local/mysql" -i /etc/my.cnf
sed "/# datadir = ...../i\ datadir = ${mysql_data_dir}\ndefault-storage-engine=INNODB" -i /etc/my.cnf
sed -i 's:#innodb:innodb:g' /etc/my.cnf

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=${mysql_data_dir} --user=mysql


cp -f /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
chmod +x /etc/init.d/mysql

cat > /etc/profile<<EOF
export PATH=$PATH:/usr/local/mysql/bin
EOF

. /etc/profile

cat > /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib
/usr/local/lib
EOF
ldconfig

ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql

if [ -d "/proc/vz" ];then
ulimit -s unlimited
fi
/etc/init.d/mysql start

ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe

/usr/local/mysql/bin/mysqladmin -u root password ${mysql_root_pwd}

cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set password=password('$mysql_root_pwd') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and password='';
drop database test;
DROP USER ''@'%';
flush privileges;
EOF

/usr/local/mysql/bin/mysql -u root -p${mysql_root_pwd} -h localhost < /tmp/mysql_sec_script

rm -f /tmp/mysql_sec_script

/etc/init.d/mysql restart

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

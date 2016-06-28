#!/bin/bash
##########################################
## LNMP install shell                   ##
## Version:v1.0.0                       ##
## Author:shp                           ##
## Date:2016-06-29                      ##
##########################################

source ${srcDir}/init.d/init_${osName}.sh


#check install packages
function CheckAndDownloadFiles()
{

echo "============================check files=================================="

cd $softDir

if [ -s libiconv-1.14.tar.gz ]; then
  echo "libiconv-1.14.tar.gz [found]"
  else
  echo "Error: libiconv-1.14.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://shp.name/lnmp/libiconv-1.14.tar.gz
  mv -f libiconv-1.14.tar.gz
fi

if [ -s libmcrypt-2.5.8.tar.gz ]; then
  echo "libmcrypt-2.5.8.tar.gz [found]"
  else
  echo "Error: libmcrypt-2.5.8.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://shp.name/lnmp/libmcrypt-2.5.8.tar.gz
fi

if [ -s mhash-0.9.9.9.tar.gz ]; then
  echo "mhash-0.9.9.9.tar.gz [found]"
  else
  echo "Error: mhash-0.9.9.9.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://shp.name/lnmp/mhash-0.9.9.9.tar.gz
fi

if [ -s mcrypt-2.6.8.tar.gz ]; then
  echo "mcrypt-2.6.8.tar.gz [found]"
  else
  echo "Error: mcrypt-2.6.8.tar.gz not found!!!download now......"
  wget -c -P ${softDir} http://shp.name/lnmp/mcrypt-2.6.8.tar.gz
fi

echo "============================check files=================================="
}

#install mast packages
function InstallDependsAndOpt()
{
cd $softDir

tar zxvf libiconv-1.14.tar.gz
cd libiconv-1.14/
./configure
make -j${lineCount} && make install
cd ../

cd $softDir
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8/
./configure
make -j${lineCount} && make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make -j${lineCount} && make install
cd ../../

cd $softDir
tar zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure
make -j${lineCount} && make install
cd ../

ln -s /usr/local/lib/lib* /usr/lib/

cd $softDir
tar zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
./configure
make -j${lineCount} && make install
cd ../

if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
    ln -s /usr/lib64/libpng.* /usr/lib/
    ln -s /usr/lib64/libjpeg.* /usr/lib/
fi

ulimit -v unlimited

if [ ! `grep -l "/lib"    '/etc/ld.so.conf'` ]; then
    echo "/lib" >> /etc/ld.so.conf
fi

if [ ! `grep -l '/usr/lib'    '/etc/ld.so.conf'` ]; then
    echo "/usr/lib" >> /etc/ld.so.conf
fi

if [ -d "/usr/lib64" ] && [ ! `grep -l '/usr/lib64'    '/etc/ld.so.conf'` ]; then
    echo "/usr/lib64" >> /etc/ld.so.conf
fi

if [ ! `grep -l '/usr/local/lib'    '/etc/ld.so.conf'` ]; then
    echo "/usr/local/lib" >> /etc/ld.so.conf
fi

ldconfig

cat >>/etc/security/limits.conf<<eof
* soft nproc 65535
* hard nproc 65535
* soft nofile 65535
* hard nofile 65535
eof

cat >>/etc/sysctl.conf<<eof
fs.file-max=65535
eof
}

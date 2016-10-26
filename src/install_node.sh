#!/bin/bash
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

#install NodeJS

cd $softDir
node_package="node-${node_ver}.tar.gz"

if [ -s "${node_package}" ]; then
	echo "${node_package} [found]"
else
	echo "Error: ${node_package} not found!!download now......"
	wget -c -P ${softDir} http://nodejs.org/dist/${node_ver}/${node_package} || exit_ "wget stopped."
fi

echo "Unzip the installation package"
tar zxf ${node_package}
echo "unzip over"
cd node-${node_ver}

echo "Compile the installation file and install"
configure --prefix=/usr/local/node
make -j$lineCount || exit_ "make stopped."
make install || exit_ "make install stopped."
echo "NodeJS success installed"

ln -s /usr/local/node/bin/* /usr/bin/

npm install -g pm2

cat >> ${insInfo} <<EOF
=============== node install information =====================
安装版本:
node-${node_ver}
安装目录:
/usr/local/node
控制命令:
service pm2-init.sh {start|stop|force-quit|restart|reload|status}
EOF

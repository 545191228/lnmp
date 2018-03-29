#!/bin/bash

# NFS服务端安装

# CentOS 6.5以上 
yum -y install rpcbind nfs-utils

# CentOS 6.5以下 
#yum -y install nfs-utils portmap nfs4-acl-tools


# Debian下,kernel-server相当于server，common是client
#sudo apt-get install nfs-kernel-server nfs-common portmap

# 创建共享目录
mkdir -p /data/www/wwwroot/default/data
chmod -R 777 /data/www/wwwroot/default/data

#配置目录、权限等
vim /etc/exports
/data/www/wwwroot/default/data *(rw,sync)


#启动，Debian
#sudo /etc/init.d/portmap restart
#sudo /etc/init.d/nfs-kernel-server restart


#启动，CentOS
service rpcbind restart
service nfs restart

#更新了/etc/exports后，使用如下命令刷新：
sudo exportfs -r


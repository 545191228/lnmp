#!/bin/bash

# NFS客户端安装

# CentOS 6.5以上 
yum -y install rpcbind

# CentOS 6.5以下 
#yum -y install portmap

#挂载到本地/mnt/nfs
mkdir /data/www/wwwroot/default/data
chmod 777 /data/www/wwwroot/default/data
sudo mount -t nfs 10.61.1.31:/data/www/wwwroot/default/data /data/www/wwwroot/default/data

#卸载，必须mount的shell进程退出后才能执行
sudo umount -f /data/www/wwwroot/default/data


# mount -t nfs 10.129.11.14:/data/www/wwwroot/default/data /data/www/wwwroot/default/data -o proto=tcp -o nolock
# sudo mount -t nfs 10.129.11.14:/data/wwwroot/hcwytj/data/cache /data/www/wwwroot/default/data/cache -o proto=tcp -o nolock
# vi /etc/fstab 
# 添加
# 10.129.11.14:/data/wwwroot/hcwytj/data/session /data/www/wwwroot/default/data/session nfs default 0 0
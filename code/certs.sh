#!/bin/bash
mkdir -p /etc/pki/tls/certs 2>/dev/null
if [ -e "/etc/pki/tls/certs/server.pem" ];then
    exit 0
else
    umask 77
    openssl req -utf8 -newkey rsa:2048 -keyout /etc/pki/tls/certs/server.key -nodes -x509 -days 1825 -out /etc/pki/tls/certs/server.crt -set_serial 0 -subj "/C=CN/ST=Beijing/L=Beijing/O=Ismole Inc/CN=$HOSTNAME"
    cat /etc/pki/tls/certs/server.key >  /etc/pki/tls/certs/server.pem
    echo ""                           >> /etc/pki/tls/certs/server.pem
    cat /etc/pki/tls/certs/server.crt >> /etc/pki/tls/certs/server.pem
fi

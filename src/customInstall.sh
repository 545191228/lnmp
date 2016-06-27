#!/bin/bash
##########################################
## LNMP install shell	  				##
## Version:v1.0.0			  		  	##
## Author:shp				  			##
## Date:2016-06-24	                  	##
##########################################

#custom install

install_init

while [ $# -ne 0 ]
do
    eval install_$1
    echo $1
    shift
done

echo "Installation completed."
echo "The following is the installation information:"
cat ${INST_INFO}
exit
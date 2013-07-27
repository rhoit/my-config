#!/bin/bash

echo "Changing user httpd dir"
sed -i 's/public_html/Pubilc\/httpd/' /etc/httpd/conf/extra/httpd-userdir.conf

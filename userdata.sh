#!/bin/bash
apt update -y
apt install apache2 -y
echo "I am $server_name" > /var/www/html/index.html
systemctl restart apache2

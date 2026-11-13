#!/bin/bash

apt update -y
apt install apache2 -y

echo "<h1>${project_name}</h1>" > /var/www/html/index.html

systemctl start apache2
systemctl enable apache2
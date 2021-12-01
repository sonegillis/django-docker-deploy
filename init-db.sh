#!/bin/bash
echo $1
echo $2
echo $3
echo $4
service mysql start
mysql -u root -p"$1" -e "CREATE USER '$2' IDENTIFIED BY '$3';"
mysql -u root -p"$1" -e "CREATE DATABASE $4;"
mysql -u root -p"$1" -e "GRANT ALL PRIVILEGES ON $4.* TO '$2';"
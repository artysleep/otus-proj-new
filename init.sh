#!bin/bash

sed '/MAIN_HOST_IP/,/DNS_IP/d' .env > .env2
echo MAIN_HOST_IP=$(hostname -i | awk '{print $1}') >> .env2
echo "DNS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')" >> .env2
rm -f .env
mv .env2 .env

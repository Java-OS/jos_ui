#!/bin/bash 

ETHERNET=$(ip route show | grep default | awk '{print $5}') 
ETHERNET_IP_ADDRESS=$(ifconfig wlan0 | grep netmask | awk '{print $2}')
podman run -it --rm --name=jos_ui -p 8080:80 -e X-SERVER-IP-ADDRESS=$ETHERNET_IP_ADDRESS -v $PWD/build/web:/usr/share/nginx/html nginx:latest 

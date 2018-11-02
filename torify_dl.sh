#! /bin/bash

#sudo nano /etc/tor/torrc 
#SocksPort 9050
#ControlPort 9051
#CookieAuthentication 0

sudo systemctl restart tor.service
tor --verify-config
wget http://checkip.dyndns.org -O - -o /dev/null | cut -d : -f 2 | cut -d \< -f 1
torify wget http://checkip.dyndns.org -O - -o /dev/null | cut -d : -f 2 | cut -d \< -f 1
sleep 10s

torify wget -nd -H -p -A .jpg,.jpeg,.png,.gif,.webm,.mp4 -rc -P CDN -e robots=off https://SITE
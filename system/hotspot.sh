#! /bin/sh
# to test
nmcli con add type wifi ifname wlo1 con-name HOTSPOT autoconnect yes ssid YOURSSID
nmcli con modify HOTSPOT 802-11-wireless.mode ap ipv4.method shared
nmcli con modify HOTSPOT wifi-sec.key-mgmt wpa-psk
nmcli con modify HOTSPOT wifi-sec.psk "verystrongpassword"
nmcli con up HOTSPOT

#! /bin/sh

clear
echo "started - $(date)"

short_loop () {
    sleep 5m
    mpv /usr/share/sounds/gnome/default/alerts/drip.ogg >> /dev/null 2>&1
    echo "take a break - look away - 30 sec"
    sleep 30s
    mpv /usr/share/sounds/gnome/default/alerts/sonar.ogg >> /dev/null 2>&1
    echo "go back to work"
}

while true
do
    # 1° short loop
    short_loop
    # 2° short loop
    short_loop
    # 3° short loop
    short_loop
    # 4° short loop
    short_loop
    # long loop
    sleep 5m
    mpv /usr/share/sounds/gnome/default/alerts/glass.ogg >> /dev/null 2>&1
    echo "take a long break - stretch - 5 min"
    sleep 5m
    mpv /usr/share/sounds/gnome/default/alerts/sonar.ogg >> /dev/null 2>&1
    echo "go back to work"
done


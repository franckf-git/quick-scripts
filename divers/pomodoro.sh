#! /bin/sh

clear
echo "started - $(date)"

short_loop () {
    sleep 5m
    mpv /usr/share/sounds/freedesktop/stereo/message.oga >> /dev/null 2>&1
    echo "take a break - look away - 30 sec"
    notify-send "take a break - look away - 30 sec"
    sleep 30s
    mpv /usr/share/sounds/freedesktop/stereo/power-unplug.oga >> /dev/null 2>&1
    echo "go back to work"
    notify-send "go back to work"
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
    mpv /usr/share/sounds/freedesktop/stereo/complete.oga >> /dev/null 2>&1
    echo "take a long break - stretch - 5 min"
    notify-send "take a long break - stretch - 5 min"
    sleep 5m
    mpv /usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga >> /dev/null 2>&1
    echo "go back to work"
    notify-send "go back to work"
done


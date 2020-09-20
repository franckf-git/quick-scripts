#! /bin/sh

# faire une pause toutes les 20 min

while true
do
    sleep 20m && i3-msg 'workspace "---PAUSE---"'
done

# TODO rajouter une interraction pour raz le timer

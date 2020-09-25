#! /bin/sh

# faire une pause toutes les 20 min

while true
do
    sleep 20m && echo -e " \n \n---PAUSE---\n \n " | dmenu -l 5
done

# TODO rajouter une interraction pour raz le timer

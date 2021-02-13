#! /bin/bash
#change wallpaper in i3 every 30 min
#add wallpaper in the .themes folder

while true
   do

       NBRFILES=$(ls ~/.themes/*.png  ~/.themes/*.jpg | wc -w )
       NOMBRE=$(echo $RANDOM % $NBRFILES +1 | bc)
       FICHIER=$(ls ~/.themes/*.png  ~/.themes/*.jpg | head -n $NOMBRE | tail -n 1)
       feh --bg-scale $FICHIER
       sleep 30m

done

exit $?

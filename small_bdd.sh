#!/bin/bash
# menu.sh
# Base de données d'adresse.

clear # Efface l'écran.

echo "          Liste de Contacts"
echo "          -----------------"
echo "Choisissez une des personnes suivantes:" 
echo
echo "[E]vans, Roland"
echo "[J]ones, Mildred"
echo "[S]mith, Julie"
echo "[Z]ane, Morris"
echo

read person

case "$person" in
# Notez que la variable est entre guillemets.

  "E" | "e" )
  # Accepte les entrées en majuscule ou minuscule.
  echo
  echo "Roland Evans"
  echo "4321 Floppy Dr."
  echo "Hardscrabble, CO 80753"
  echo "(303) 734-9874"
  echo "(303) 734-9892 fax"
  echo "revans@zzy.net"
  echo "Business partner & old friend"
  ;;
  # Notez le double point-virgule pour terminer chaque option.

  "J" | "j" )
  echo
  echo "Mildred Jones"
  echo "249 E. 7th St., Apt. 19"
  echo "New York, NY 10009"
  echo "(212) 533-2814"
  echo "(212) 533-9972 fax"
  echo "milliej@loisaida.com"
  echo "Ex-girlfriend"
  echo "Birthday: Feb. 11"
  ;;

# Ajoutez de l'info pour Smith & Zane plus tard.

          * )
   # Option par défaut.   
   # Entrée vide (en appuyant uniquement sur la touche RETURN) vient ici aussi.
   echo
   echo "Pas encore dans la base de données."
  ;;

esac

echo
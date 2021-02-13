#!/bin/bash
# file-info.sh

FICHIERS="/usr/sbin/accept
/usr/sbin/pwck
/usr/sbin/chroot
/usr/bin/fauxfichier
/sbin/badblocks
/sbin/ypbind"   # Liste de fichiers qui vous intéressent.
                # Nous avons ajouté un fichier fantaisiste, /usr/bin/fauxfichier.

echo

for fichier in $FICHIERS
do

  if [ ! -e "$fichier" ]       # Vérifie que le fichier existe.
  then
    echo "$fichier n'existe pas."; echo
    continue                # Au suivant.
  fi

  ls -l $fichier | awk '{ print $9 "         taille: " $5 }' # Affiche 2 champs.
  whatis `basename $fichier`   # Informations sur le fichier.
  #  Remarque : pour que la commande ci-dessus puisse fonctionner. 
  #+ la base de données whatis doit avoir été d'abord configurée.
  #  Pour cela, en tant que root, lancez /usr/bin/makewhatis.
  echo
done  

exit 0
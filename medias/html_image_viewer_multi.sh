#! /bin/sh

# nettoyege des noms

for i in $(ls)
  do
  mv $i $(echo $i | iconv --from-code=UTF-8 --to-code=ASCII//TRANSLIT)
done

prename 'y/A-Z\ /a-z-/' *
prename 's/\[//g' *
prename 's/[^a-z0-9-.]/-/g' *
prename 's/ryozanpaku-//g' *
prename 's/ajia-no-scantrad-//' *
prename 's/ajia-rs--//' *
prename 's/mns-tnt--//' *
prename 's/mns-rs--//' *
prename 's/rs--//' *
prename 's/mns--//' *
prename 's/shp--//g' *
prename 's/koneko-scantrad-//g' *
prename 's/mns-ps--//g' *
prename 's/schlag--//g' *
prename 's/monster-no-scantrad-//' *

# sortir les fichiers

for j in $(ls); do cd $j && for k in $(ls); do mv $k ../"$j"_"$k" ; done && cd .. ; done

# creation du html

echo '
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>'lecture'</title>
    <style type="text/css">
  body {
    background-color: DarkSlateGrey;
  }
  img {
    display: block;
    margin-left: auto;
    margin-right: auto;
    height: 100%;
    width: 75%;
  }
    </style>
  </head>
  <body>
    <div>
' > lecture.html

for l in $(ls | grep -E "*\.[a-zA-Z]{1,}")
  do
    echo '<img src="'$l'">' >> lecture.html
done

echo '
    </div>
  </body>
</html>
' >> lecture.html

exit $?
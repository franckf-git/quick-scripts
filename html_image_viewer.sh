#! /bin/bash
# generate a html file to view images in a folder

if [ -z "$1" ]
  then
echo "Usage: add the path as argument"
  else

#find the name of the folder
FOLDER=$(echo "$1" | rev | cut -d"/" -f 1 | rev)

echo '
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>'$FOLDER'</title>
    <style type="text/css">
  body {
    background-color: DarkSlateGrey;
  }
  img {
    display: block;
    margin-left: auto;
    margin-right: auto;
    height: 100%;
    width: 100%;
  }
    </style>
  </head>
  <body>
    <div>
' > $FOLDER.html

for i in $(ls $1)
  do
    echo '
           <img src="'$1/$i'">
' >> $FOLDER.html
done

echo '
    </div>
  </body>
</html>
' >> $FOLDER.html

fi
exit $?


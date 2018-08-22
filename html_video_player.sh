#! /bin/bash
# generate a html file to play the videos in a folder

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
  h1 {
    color: Snow;
  }
  video {
    display: block;
    margin-left: auto;
    margin-right: auto;
    height: 60%;
    width: 60%;
  }
    </style>
  </head>
  <body>
' > $FOLDER.html

for i in $(ls $1)
  do
    echo '
        <div>
        <h1>'$i'</h1>
        <video controls="controls" src="'$1/$i'">
        <br />
        </div>
' >> $FOLDER.html
done

echo '
  </body>
</html>
' >> $FOLDER.html

fi
exit $?

#! /bin/bash

# Transforme le markdown en html avec bootstrap
# usage : markdown_to_html.sh FICHIER.md > PAGE.html

# On va chercher notre style bootstrap
wget https://framagit.org/efydd/web_static/-/archive/master/web_static-master.zip
unzip web_static-master.zip
mv web_static-master/bootstrap_4-1-3/ .

# On recupere le nom du fichier sans l extension pour l utiliser en titre
TITRE=$(basename $1 | sed 's/.md//g' )

# On affiche d abord une entete html
echo "
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="bootstrap_4-1-3/bootstrap.min.css" rel="stylesheet">
  <script src="bootstrap_4-1-3/jquery-3.3.1.slim.min.js"></script>
  <script src="bootstrap_4-1-3/popper.min.js"></script>
  <script src="bootstrap_4-1-3/bootstrap.min.js"></script>
  <title>$TITRE</title>
</head>
<body>
<div class="container">
"

# On fait la conversion md to html

echo "$(cat $1 |

sed -r 's/^# (.*)/<h1>\1<\/h1>/g' |                 #entete1 
sed -r 's/^## (.*)/<h2>\1<\/h2>/g' |                #entete2
sed -r 's/^### (.*)/<h3>\1<\/h3>/g' |               #entete3
sed -r 's/^#### (.*)/<h4>\1<\/h4>/g' |              #entete4
sed -r 's/^##### (.*)/<h5>\1<\/h5>/g' |             #entete5
sed -r 's/^###### (.*)/<h6>\1<\/h6>/g' |            #entete6

sed -r 's/^---*$/<hr>/g' |                          #ligne
sed -r 's/^\*\*\**$/<hr>/g' |                       #ligne
sed -r 's/^___*$/<hr>/g' |                          #ligne

sed -r 's/\*\*\*(.*)\*\*\*/<i><b>\1<\/b><\/i>/g' |  #gras et italic
sed -r 's/\_\_\_(.*)\_\_\_/<i><b>\1<\/b><\/i>/g' |  #gras et italic
sed -r 's/\*\*(.*)\*\*/<b>\1<\/b>/g' |              #gras
sed -r 's/\_\_(.*)\_\_/<b>\1<\/b>/g' |              #gras
sed -r 's/\*(.*)\*/<i>\1<\/i>/g' |                  #italic
sed -r 's/\_(.*)\_/<i>\1<\/i>/g' |                  #italic

sed -r 's/^!\[(.*)\]\((.*)\)/<img src="\2" alt="\1">/g' |    #image
sed -r 's/\[(.*)\]\((.*)\)/<a href="\2">\1<\/a>/g' |         #url

sed -r 's/`(.*)`/<pre><code>\1<\/code><\/pre>/g' |           #code
sed -r 's/^    (.*)/<pre><code>\1<\/code><\/pre>/g' |        #code

sed -r 's/^>> (.*)/<q> \1 <\/q>/g' |                         #petite citation
sed -r 's/^> (.*)/<blockquote> \1 <\/blockquote>/g' |        #citation

sed -r 's/\[x\] (.*)/<input type="checkbox" checked> \1/g' | #cocher
sed -r 's/\[ \] (.*)/<input type="checkbox"> \1/g' |         #acocher

sed -r 's/^- (.*)/<ul>\n<li>\1<\/li>\n<\/ul>/g' |                #liste
sed -r 's/^\* (.*)/<ul>\n<li>\1<\/li>\n<\/ul>/g' |               #liste
#sed -r 's/^[0-9]\) (.*)/<ol><li>\1<\/li><\/ol>/g' |          #liste ordonnee
#sed -r 's/^[0-9]. (.*)/<ol><li>\1<\/li><\/ol>/g' |           #liste ordonnee


sed -r 's/$/<\/br>/g' |                                    #retour a ligne
sed -r 's/(.*>)<\/br>$/\1/g'                               #retour a ligne
)"

# On cloture le html
echo "
</div>
</body>
</html>
"

exit $?

#! /bin/sh
for i in $(cat readme.md) ; do echo "* [$(curl -s $i | grep '<title>' | sed -e 's/<title>//g' | sed -e 's/<\/title>//g' | sed -e 's/\t//g')]($i)" ; done

#! /bin/sh

for alphabet in {a..z}
do
    mkdir $alphabet
    for element in $( ls | egrep "^$alphabet")
    do
        mv $element $alphabet/
    done
done

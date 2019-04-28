#!/bin/bash
mkdir result
liste=$(ls | grep .png)
for i in $liste
do
name=result"/$i"
#convert $i -background none -chop 0x178 $name
convert $i -background none -splice 0x178 $name
done

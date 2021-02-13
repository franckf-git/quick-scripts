#!/bin/bash
#localisation d ip
#+formatage IP PAYS
for i in $(cat ip_test.txt)
do
        {
                geoiplookup $i | head -n 1 | sed 's/GeoIP Country Edition: /'"$i "'/g'
        } >> bad.log
done

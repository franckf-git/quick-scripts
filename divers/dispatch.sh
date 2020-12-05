#! /bin/bash
# script for rtfm repo

mkdir short_version

for i in $(ls)
do
    echo "$i"
    for j in {1..50}
    do
        echo "$i"_"$j"
        awk '/_____________________________________________________________________________________/,/back to top/{if(++m==1)n++;if(n=='$j')print;if(/back to top/)m=0}' $i > short_version/$(echo "$i" | sed 's/.md//g')_$(awk '/_____________________________________________________________________________________/,/back to top/{if(++m==1)n++;if(n=='$j')print;if(/back to top/)m=0}' "$i" | sed -n '2 p' | sed 's/\ /_/g; s/\///g; s/(//g; s/)//g').md
    done

done

exit $?

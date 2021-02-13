#!/bin/bash

# array of binary digits 0-9
binary=("0000" "0001" "0010" "0011" "0100" "0101" "0110" "0111" "1000" "1001")

# store time variables
hr=$(date '+%H')
min=$(date '+%M')

# convert each digit to binary 
for i in hr min
do
    col[${#col[*]}]=${binary[${!i:0:1}]}
    col[${#col[*]}]=${binary[${!i:1:1}]}
done

# create grid
for i in {0..3}
do
    for j in {0..3}; do output="$output${col[j]:i:1} "; done
    output="$output\n"
done

echo -e $output

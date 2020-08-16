#!/bin/bash

# 24 hour format
militaryTime=false

# colors
clearColor='\033[0m' # do not change 
onColor='\033[31m'
offColor=$clearColor

# symbols
onSymbol='o'
offSymbol='.'

# array of binary digits 0-9
binary=("0000" "0001" "0010" "0011" "0100" "0101" "0110" "0111" "1000" "1001")

# store time variables
if ( $militaryTime ); then hr=$(date '+%H'); else hr=$(date '+%I'); fi
min=$(date '+%M')
sec=$(date '+%S')

# convert each digit to binary 
for i in hr min sec
do
    col[${#col[*]}]=${binary[${!i:0:1}]}
    col[${#col[*]}]=${binary[${!i:1:1}]}
done

# create grid
for i in {0..3}
do
    for j in {0..5}; do output="$output${col[j]:i:1} "; done
    output="$output\n"
done

# change symbols and colors
output=$(sed s/'0 '/$(printf "$offColor"$offSymbol"$clearColor")' '/g <<< $output)
output=$(sed s/'1 '/$(printf "$onColor"$onSymbol"$clearColor")' '/g <<< $output)
echo -e $output # print

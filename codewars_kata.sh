###>>>https://www.codewars.com/kata/bash-basics-while-loop
#!/bin/bash
countToTwenty() {
  for i in {1..20}
    do
      echo "Count: $i"
  done
}
countToTwenty

###>>>https://www.codewars.com/kata/classic-hello-world/train/shell
#!/bin/bash
function Solution
{
    function main
    {
        echo "Hello World!"
    }
    main
}
Solution

###>>>https://www.codewars.com/kata/keep-hydrated-1/train/shell
#!/bin/bash
time=$1
echo "$1/2" | bc

###>>>https://www.codewars.com/kata/keep-up-the-hoop/train/shell
#!/bin/bash
n=$1
if [ "$1" -ge 10 ]
	then
        echo "Great, now move on to tricks"
    else
        echo "Keep at it until you get it"
fi

###>>>https://www.codewars.com/kata/jennys-secret-message/train/shell
#!/bin/bash
if [ "$1" = "Johnny" ]
    then
        echo "Hello. my Love!"
    else
        echo "Hello, $1!"
fi

###>>>https://www.codewars.com/kata/string-repeat
#!/bin/bash
repeat=$1
string=$2
printf "$2"'%.s' $(eval "echo {1.."$(($1))"}")
printf "\n"

###>>>https://www.codewars.com/kata/even-or-odd
#!/bin/bash
if [ $(let "TOTAL = "$1" % 2" ; echo $TOTAL) -eq "0" ]
    then 
        echo "Even"
    else
        echo "Odd"
fi

###>>>https://www.codewars.com/kata/volume-of-a-cuboid
#!/bin/bash
length=$1
width=$2
height=$3
echo $1*$2*$3 | bc

###>>>https://www.codewars.com/kata/remove-string-spaces
#!/bin/bash
var="$1"
echo $1 | sed "s/ //g"

###>>>https://www.codewars.com/kata/remove-first-and-last-character
#!/bin/bash
function removeChar() {
    echo $1 | cut -c 2- | rev |  cut -c 2- | rev
}
removeChar $1

###>>>https://www.codewars.com/kata/multiply
#!/bin/bash -e
a=$1
b=$2
echo $((a*b))

###>>>https://www.codewars.com/kata/return-the-latest-modified-file
#!/bin/bash
ls -t | head -n 1

###>>>https://www.codewars.com/kata/reverser/train/shell
#!/bin/bash
echo "$1" | rev | bc
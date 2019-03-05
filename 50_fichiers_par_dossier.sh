#! /bin/bash
# usage bash 50_fichiers_par_dossier DOSSIER

NOMBREFICHIER=$(ls $1 | wc -l)

SOUSDOSSIERS=$(echo $NOMBREFICHIER / 50 + 1 | bc)

for ((i=1;i<=$SOUSDOSSIERS;i++))
    do
        mkdir $1_$i
        
        for j in $(ls $1 | head -n 50)
            do
            mv $1/$j $1_$i/
            done
    done
exit $?

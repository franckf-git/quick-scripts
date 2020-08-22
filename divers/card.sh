#!/bin/bash

Suites="Carreau
Pique
Coeur
Trefle"

Denominations="2
3
4
5
6
7
8
9
10
Valet
Dame
Roi
As"

suite=($Suites)                # Lire dans une variable de type tableau.
denomination=($Denominations)

num_suites=${#suite[*]}        # Compter le nombre d'éléments.
num_denominations=${#denomination[*]}

echo -n "${denomination[$((RANDOM%num_denominations))]} of "
echo ${suite[$((RANDOM%num_suites))]}

exit 0
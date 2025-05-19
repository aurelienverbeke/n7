#!/bin/sh
echo "\nFichier initial"
cat exemple.txt
echo "\nAffichage des lignes contenant des nombres entiers naturels :"
egrep -e " ([1-9][0-9]*|0)$" exemple.txt
echo "\nAffichage des lignes contenant des nombres entiers relatifs :"
egrep -e " (\+|-)[1-9][0-9]*$" exemple.txt
echo "\nAffichage des lignes contenant des nombres décimaux :"
egrep -e " -?[0-9]+\.[0-9]+((e|E)-?[0-9]+)?$" exemple.txt
echo "\nAffichage des lignes contenant des nombres rationnels :"
egrep -e " -?[0-9]+/[1-9][0-9]*$" exemple.txt
echo "\nAffichage des lignes contenant des nombres complexes rationnels :"
egrep -e " ((-?[0-9]+/[1-9][0-9]*)|(-?[0-9]+/[1-9][0-9]*i)|(-?[0-9]+/[1-9][0-9]*(\+|-)[0-9]+/[1-9][0-9]*i))$" exemple.txt

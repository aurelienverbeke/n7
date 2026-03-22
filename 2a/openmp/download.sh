#/usr/bin/bash

rsync --rsh='ssh -F none' -a --include='*.svg' --include='*.csv' --exclude='*' ${1}@turpanlogin.calmip.univ-toulouse.fr:${USER}/openmp/ .

gnuplot -p < plots.gp

#!/bin/bash

gcc 2darray-cycbound.c -lm


awk '{print $2,$3}' coordinates30000-2.2.dat > coordinates.dat
./a.out coordinates.dat > list.dat

starte=`grep -e "clusters" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`
awk 'NR<'${starte}'{print}' list.dat > matrix.dat

cut -d " " -f2- matrix.dat | awk 'NR>1{if (NR<'${starte}'-1) print}' > matrix1.dat


gnuplot -p << EOF

set term png
set output 'heatmap.png'

set pm3d map
set palette rgbformula 21,22.23

YTICS="`awk 'BEGIN{getline}{printf "%s ",$1}' matrix.dat`"
XTICS="`head -1 matrix.dat`"

#set xrange[-1:10]
set for [i=1:words(XTICS)] xtics ( word(XTICS,i) i-1.5 )
set for [i=1:words(YTICS)] ytics ( word(YTICS,i) i-1.5 )

#set pm3d interpolate 2,2
plot "matrix1.dat" matrix with image 
replot

EOF

#matrix1.dat

#splot "<awk '{${1}=\"\"}1' matrix.dat | sed '1 d'" matrix 
#set pm3d interpolate 2,2

#!/bin/bash

file=coordinates4.0
#gcc 2darray.c -lm
g++ -std=c++11 heatmap_cluster.cpp


awk '{print $2,$3}' $file.dat > coordinates.dat

./a.out coordinates.dat 1 > list.dat

startmatrix=`grep -e "start_matrix" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`
endmatrix=`grep -e "end_matrix" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`

#awk 'NR<'${startmatrix}'{print}' list.dat > matrix.dat
awk 'NR>'${startmatrix}'{if(NR<'${endmatrix}') print}' list.dat > matrix.dat

#awk '{if(NR>$'${endmatrix}') print}' list.dat >listdata.dat
awk 'NR>'${endmatrix}'{ print}' list.dat >listdata.dat

cut -d " " -f2- matrix.dat | awk 'NR>1{if (NR<'${endmatrix}'-2) print}' > matrix1.dat


gnuplot -p << EOF

set term png
set output 'heatmap$gamma.png'

set pm3d map
set palette rgbformula 21,22.23

#YTICS="`awk 'BEGIN{getline}{printf "%s ",$1}' matrix.dat`"
#XTICS="`head -1 matrix.dat`"

#forについて：読みこむのは最初の/n個まで
#ラベルの値、置き換える(defaultの)数値
#word(xtics,i) :xticsのi番目の値

#set for [i=0:(words(XTICS)-1)/10] xtics ( word(XTICS,10*i+1) 10*i-1.5 )
#set for [i=0:(words(YTICS)-1)/10] ytics ( word(YTICS,10*i+1) 10*i-1.5 )

#set pm3d interpolate 2,2
plot "matrix1.dat" matrix with image 
replot

EOF


#splot "<awk '{${1}=\"\"}1' matrix.dat | sed '1 d'" matrix 
#set pm3d interpolate 2,2

#!/bin/bash

#heatmap='./heatmap.sh'
#echo $heatmap

gamma=2.0
file=coordinates2.0
#gcc 2darray.c -lm

#<<COMMENTOUT
g++ -std=c++11 heatmap_cluster.cpp


awk '{print $2,$3}' $file.dat > coordinates.dat

./a.out coordinates.dat 1 > list.dat

startmatrix=`grep -e "start_matrix" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`
endmatrix=`grep -e "end_matrix" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`

#awk 'NR<'${startmatrix}'{print}' list.dat > matrix.dat
awk 'NR>'${startmatrix}'{if(NR<'${endmatrix}') print}' list.dat > matrix.dat

#awk '{if(NR>$'${endmatrix}') print}' list.dat >listdata.dat
awk 'NR>'${endmatrix}'{ print}' list.dat > $file-pdf1.dat

cut -d " " -f2- matrix.dat | awk 'NR>1{if (NR<'${endmatrix}'-2) print}' > matrix1.dat


gnuplot -p << EOF

set term png
set output 'heatmap$gamma.png'

set pm3d map
set palette rgbformula 21,22.23
set xrange[0:]
set yrange[0:]

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

bin=1
awk ' BEGIN{MIN=0}{
        BIN=sprintf("%d", $1*(1/BINSIZE))+0;
        DATA[BIN]++;
        #if((!MIN)||(MIN>BIN)) MIN=BIN;
	if(MIN>BIN) MIN=BIN;
	if((!MAX)||(MAX<BIN)) MAX=BIN;
 }
END {
        for(BIN=0; BIN<=MAX; BIN++)
	  printf("%d %d %lf\n",BIN*BINSIZE,DATA[BIN], sqrt(BIN*BINSIZE));
}' BINSIZE=$bin $file-pdf1.dat > $file-pdf2.dat

awk 'NR>1{print}' $file-pdf2.dat > $file-pdf.dat

#COMMENTOUT

gnuplot -p << EOF

set term png
set title "Firm distribution in Mesh(50,50) gamma$gamma"
set output "mesh$file.png"

set xlabel "Number of Firms"
set ylabel "Frequency"

set log xy
set xrange[0.5:]
set yrange[0.5:]

#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 8*10**4*exp(-1.3*x)
p "$file-pdf.dat" u 1:2:3 w yerrorbars, 10000*x**-2.7
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 10000*x**-2.7
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 692*x**-1.1#
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 3900*x**-1.6#gamma 2.5
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 6900*x**-1.8#gamma2.3
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 346011*exp(-2.6*x) 
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 692*x**-1.1

replot

EOF

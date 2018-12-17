#!/bin/bash

#heatmap='./heatmap.sh'
#echo $heatmap

gamma=2.5
file=coordinates2.5
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

set term png font "ヒラギノ丸ゴ ProN W4,10"

set pm3d map
set palette rgbformula 21,22.23

set palette defined (0 "white", 1 "blue" , 2 "purple" ,3 "blue", 4 "black")
#set palette defined (0 "white", 1 "blue" , 2 "red", 3 "black")

set logscale cb

set xrange[0:]
set yrange[0:]

#YTICS="`awk 'BEGIN{getline}{printf "%s ",$1}' matrix.dat`"
#XTICS="`head -1 matrix.dat`"

#forについて：読みこむのは最初の/n個まで
#ラベルの値、置き換える(defaultの)数値
#word(xtics,i) :xticsのi番目の値

#set for [i=0:(words(XTICS)-1)/10] xtics ( word(XTICS,10*i+1) 10*i-1.5 )

set title "Node Distribution γ=$gamma" 
set title font ",18"

#set xtics("0" 0 , "2000" 100, "4000" 200, "6000" 300, "8000" 400, "10000" 499, "12000" 600)
#set ytics("0" 0 , "2000" 100, "4000" 200, "6000" 300, "8000" 400, "10000" 499, "12000" 600)

set xtics("0" 0, "2000" 50, "4000" 100, "6000" 150, "8000" 200, "10000" 249)
set ytics("0" 0, "2000" 50, "4000" 100, "6000" 150, "8000" 200, "10000" 249)

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
	  printf("%d %d %lf\n",BIN*BINSIZE,DATA[BIN], sqrt(DATA[BIN]));
}' BINSIZE=$bin $file-pdf1.dat > $file-pdf2.dat


#sum1=`awk 'BEGIN{sum=0}{if(NR>1) sum+=$2}END{print sum}' $file-pdf2.dat `
#awk 'NR>1{print $1, $2/'${sum1}', $3}' $file-pdf2.dat > $file-pdf.dat

#awk 'NR>1{print}' $file-pdf2.dat > $file-pdf.dat

#<<COMMENTOUT
#awk 'NR>1{print}' $file-pdf2.dat > $file-pdf3.dat
awk 'NR>1{print}' $file-pdf2.dat > $file-pdf3.dat

awk 'NR<10 {print}' $file-pdf3.dat > $file-pdf4.dat

awk ' BEGIN{MIN=0}
{if(NR>=10 && NR <60){
	BIN=sprintf("%d", $1*(1/BINSIZE))+0;
        
	DATA[BIN]+=$2;
	DATAnum[BIN]++;

	#if($2!=0){DATAnum[BIN]++;}
	
	DATALAST[BIN]=$1;
        
	if((!MIN) || MIN>BIN) MIN=BIN;
	if((!MAX)||(MAX<BIN)) MAX=BIN;
}
#else print
}
END {
	#printf("MAX = %d MIN = %d\n", MAX,MIN);
	#for(i=0;i<30;i++) print $1,$2,$3;
	
	for(BIN=MIN; BIN<=MAX; BIN++) {
	  if(DATAnum[BIN]!=0){
	  printf("%lf %lf %lf\n",(BIN*BINSIZE+DATALAST[BIN])/2-0.5,DATA[BIN]/DATAnum[BIN], sqrt(DATA[BIN])/DATAnum[BIN]);}

	  #printf("%lf %lf %lf\n",(BIN*BINSIZE+DATALAST[BIN])/2-0.5,DATA[BIN]/BINSIZE, sqrt(DATA[BIN])/DATAnum[BIN]);
  }
}' BINSIZE=10 $file-pdf3.dat > $file-pdf5.dat
#wCOMMENTOUT

awk ' BEGIN{MIN=0}
{if(NR>=60){
	BIN=sprintf("%d", $1*(1/BINSIZE))+0;
        
	DATA[BIN]+=$2;
	DATAnum[BIN]++;	
	#if($2!=0){DATAnum[BIN]++;}
	DATALAST[BIN]=$1;
        
	if((!MIN) || MIN>BIN) MIN=BIN;
	if((!MAX)||(MAX<BIN)) MAX=BIN;
}
#else print
}
END {
	#printf("MAX = %d MIN = %d\n", MAX,MIN);
	#for(i=0;i<30;i++) print $1,$2,$3;
	
	for(BIN=MIN; BIN<=MAX; BIN++) {
	  if(DATAnum[BIN]!=0){
	  printf("%lf %lf %lf\n",(BIN*BINSIZE+DATALAST[BIN])/2-0.5,DATA[BIN]/DATAnum[BIN], sqrt(DATA[BIN])/DATAnum[BIN]);}

	  #printf("%lf %lf %lf\n",(BIN*BINSIZE+DATALAST[BIN])/2-0.5,DATA[BIN]/BINSIZE, sqrt(DATA[BIN])/DATAnum[BIN]);
  }
}' BINSIZE=50 $file-pdf3.dat > $file-pdf6.dat

cat $file-pdf4.dat $file-pdf5.dat $file-pdf6.dat > $file-pdf.dat

#awk 'NR>4{sum=0}{sum+='

#COMMENTOUT

gnuplot -p << EOF

set term png

set encoding utf8

#set term png font "Ryumin-Light-EUC-H,10"
set term png font "ヒラギノ丸ゴ ProN W4,10"

#set terminal postscript enhanced color "Ryumin-Light-EUC-H" 10
set title font ",18"
set xlabel font ",18"
set ylabel font ",18"
set key font ",18"

set lmargin 12

set title "Mesh density distribution γ=$gamma"
set output "mesh$file.png"

set xlabel "Number of Firms in Mesh (40×40)"
set ylabel "Frequency"

set log xy
set xrange[0.5:]
set yrange[0.1:]

#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 8*10**4*exp(-1.3*x)
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 10000*x**-3.0

#p "$file-pdf.dat" u 1:2:3 w yerrorbars title "gamma $gamma", 20000*x**-3.0 title "∝ x^{-3}"
#p "$file-pdf.dat" u 1:2:3 w yerrorbars title "Data:γ=$gamma", 20000*x**-2.7 title "Fit: ∝x^{-2.7}"
p "$file-pdf.dat" u 1:2:3 w yerrorbars title "Data:γ=$gamma", 5000*x**-1.8 title "Fit: ∝x^{-1.8}" #gamma2.5

#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 692*x**-1.1#
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 3900*x**-1.6 #gamma 2.5
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 3900*x**-3 #gamma 2.5
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 6900*x**-1.8#gamma2.3
#p "$file-pdf.dat" u 1:2:3 w yerrorbars #, 346011*exp(-2.6*x) 

replot

EOF

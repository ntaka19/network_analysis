#!/bin/bash

#system size
xy=10000

#volume exclusion
MIN=1
mesh=50

#cluster, pdf and heatmap
BINSIZE=200
threshold=1

g++ -std=c++11 -fopenmp -o growth.out main.cpp addNode/addNode.cpp random/getrand.cpp -lm
g++ -std=c++11 -o heatmap.out heatmap/heatmap_cluster.cpp -lm

for beta in 0.0 0.5 1.0 1.5 2.0 2.5 3.0
do

#rm -r beta$beta
mkdir -p beta$beta

for seed in {1..9} #0 #1 2 3 4 5 6 7 8 9
do
  rm -r beta$beta/seed$seed
  mkdir -p seed$seed

for points in 30000
do

for gamma in 0.0 -0.5 -1.0 -1.5 -2.0 -2.5 -3.0 #2.5 3.0 3.5 4.0 4.5 5.0 #0.0 0.5 1.0 1.5
do

mkdir -p seed$seed/gamma$gamma
  
#0.5以上でadd, 0.5-0.2 でremove, 0.2以下でmerger
./growth.out $points $beta $gamma $seed > log$gamma.dat

#####INDEG OUTDEG CDF####
mkdir -p seed$seed/gamma$gamma/cdf

grep "pow" log$gamma.dat > degdist_exponent$gamma.dat
mv degdist_exponent$gamma.dat seed$seed/gamma$gamma/cdf

start_deg=`grep -n "start_kin_kout" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
end_deg=`grep -n "start_kin_kout" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`

awk 'NR>'${start_deg}'{ if(NR< '${end_deg}') {print $1,$2}}' log$gamma.dat > kinout$gamma.dat

mv kinout$gamma.dat seed$seed/gamma$gamma/cdf


startedge=`grep -n "start_edge_points" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
endedge=`grep -n "end_edge_points" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`

echo $startedge
echo $endedge

awk 'NR>'${startedge}'{ if(NR< '${endedge}') {print $1,$2}}' log$gamma.dat > edgelist$gamma.dat
awk '{D[$1]+=1}END{for (i in D) print i,D[i]}' edgelist$gamma.dat| sort -k2gr > outdegree$gamma.dat
awk '{S[$2]+=1}END{for (i in S) print i,S[i]}' edgelist$gamma.dat| sort -k2gr > indegree$gamma.dat

sum_in=`wc -l indegree$gamma.dat | awk '{print $1}'`
sum_out=`wc -l outdegree$gamma.dat | awk '{print $1}'`

awk '{print $2,NR/'${sum_in}'}' indegree$gamma.dat > indeg_cdf$gamma.dat
awk '{print $2,NR/'${sum_out}'}' outdegree$gamma.dat > outdeg_cdf$gamma.dat

gnuplot -p << EOF

#set term postscript enhanced color

set terminal postscript eps color enhanced "Arial,18"
set encoding utf8
set title font ",18"
set xlabel font ",18"
set ylabel font ",18"
set key font ",14"

set title "Node Degree Distribution ({/Symbol b}=$beta,{/Symbol g}=$gamma)"
set output 'cdf$gamma.eps'

set label 1 at graph 0.4,0.4 "{/Symbol \265} x^{-2.0}" font ",20"

set lmargin 14

set ylabel "CDF"
set xlabel "DEGREE"

set yrange[:1]
#set xrange[:300]

set log xy
#"Degree^{-2.0}"
g(x,min,max)=( (x>=min && x<=max)? 1.0 : (1/0) )

plot x**-2.0*g(x,5,50) w lines dt 2 title "", "indeg_cdf$gamma.dat" w l title "INDEG {/Symbol b}=$beta ,{/Symbol g}=$gamma" ,"outdeg_cdf$gamma.dat" w l title "OUTDEG {/Symbol b}=$beta ,{/Symbol g}=$gamma"
replot

EOF


mv edgelist$gamma.dat cdf$gamma.eps indegree$gamma.dat indeg_cdf$gamma.dat outdegree$gamma.dat outdeg_cdf$gamma.dat seed$seed/gamma$gamma/cdf

######GEO DISTANCE DISTRIBUTION ######
mkdir -p seed$seed/gamma$gamma/geodist

awk 'NR>'${startedge}'{ if(NR< '${endedge}') {print $3}}' log$gamma.dat > geodist$gamma.dat

awk ' BEGIN{MIN=0}{
        BIN=sprintf("%d", $1*(1/BINSIZE))+0;
        DATA[BIN]++;
        #if((!MIN)||(MIN>BIN)) MIN=BIN;
	if(MIN>BIN) MIN=BIN;
	if((!MAX)||(MAX<BIN)) MAX=BIN;
 }
END {
        for(BIN=0; BIN<=MAX; BIN++)
           #     printf("%+2.5f-%+2.5f\t%d\n", (BIN*BINSIZE), (BIN*BINSIZE)+(BINSIZE-0.00001), DATA[BIN]);
	   printf("%d %d\n",BIN*BINSIZE,DATA[BIN]);
}' BINSIZE=100 geodist$gamma.dat > geodist_pdf$gamma.dat


gnuplot -p << EOF
set terminal postscript eps color enhanced "Arial,18"
set encoding utf8
set title font ",18"
set xlabel font ",18"
set ylabel font ",18"
set key font ",14"

set title "Euclid Distance Distribution ({/Symbol b}=$beta,{/Symbol g}=$gamma)"
set ylabel "Number of Edges"
set xlabel "Euclid Distance"
#set log xy

#set output 'geodist_pdf$gamma.png'
set output 'geodist_pdf$gamma.eps'

plot "geodist_pdf$gamma.dat" w boxes
replot

EOF


###CDF of Euclid distance###
sumg=`wc -l geodist$gamma.dat | awk '{print $1}'`

#sum=`awk 'BEGIN{sum=0}{sum+=$1}END{print sum}' geodist$gamma.dat`
sort -k1gr geodist$gamma.dat > geodist1$gamma.dat
awk '{print $1,NR/'${sumg}'}' geodist1$gamma.dat > geodist_cdf$gamma.dat

gnuplot -p << EOF

set terminal postscript eps enhanced color "Arial,18"
set encoding utf8
set xlabel font ",18"
set ylabel font ",18"
set key font ",14"

set title "Euclid Distance Distribution (CDF) ({/Symbol b}=$beta,{/Symbol g}=$gamma)"
set ylabel "CDF"
set xlabel "Euclid Distance"

set yrange[:2]
#set xrange[1:]
set log xy

#set output 'geodist_cdf$gamma.png'
set output 'geodist_cdf$gamma.eps'

plot "geodist_cdf$gamma.dat" w l title "{/Symbol b}=$beta, {/Symbol g}=$gamma"
replot

EOF


#mv geodist_pdf$gamma.dat geodist$gamma.dat geodist1$gamma.dat geodist_cdf$gamma.dat geodist_pdf$gamma.png geodist_cdf$gamma.png seed$seed/gamma$gamma/geodist
mv geodist_pdf$gamma.dat geodist$gamma.dat geodist1$gamma.dat geodist_cdf$gamma.dat geodist_pdf$gamma.eps geodist_cdf$gamma.eps seed$seed/gamma$gamma/geodist

######PLOT COORDINATES#####

mkdir -p seed$seed/gamma$gamma/coordinates
startcoor=`grep -n "start_coordinates" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
endcoor=`grep -n "end_coordinates" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`


awk 'NR>'${startcoor}'{if(NR<'${endcoor}') print $1,$2,$3}' log$gamma.dat > coordinates$gamma.dat

#gradation file
awk 'BEGIN{count=500;col=0.1}{if(NR<count){print $2,$3,col;}else{count+=500;col+=0.1}}' coordinates$gamma.dat > coor$gamma.dat


gnuplot -p << EOF
 set terminal postscript eps enhanced color "Arial,18"
 set encoding utf8
 set xlabel font ",18"
 set ylabel font ",18"
 set key font ",14"

 set xrange[0:$xy]
 set yrange[0:$xy]

 set title "points:$points ({/Symbol b}=$beta, {/Symbol g}=$gamma)"

 set palette model RGB defined (0'dark-goldenrod',1'light-red',2'red',3'dark-red',4'black')

 set output 'coordinates$gamma.eps'
 plot "coor$gamma.dat" with points palette pointsize 0.2
 pause -1
EOF


####line between connected coordinates###
<< COMMENTOUT
startavgdeg=`grep -n "start_avg_deg" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
endavgdeg=`grep -n "end_avg_deg" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
awk 'NR>'${startavgdeg}'{if(NR<'${endavgdeg}') print $1,$2,$3}' log$gamma.dat > avgdeg$gamma.dat
mv avgdeg$gamma.dat seed$seed/gamma$gamma
COMMENTOUT

startline=`grep -n "start_line" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
endline=`grep -n "end_line" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`


awk 'NR>'${startline}'{if(NR<'${endline}') print $1,$2,$3}' log$gamma.dat > node-lines$gamma.dat


gnuplot -p << EOF
 #set term png
 set terminal postscript eps color enhanced "Arial,18"
 set encoding utf8
 set title font ",18"
 set xlabel font ",18"
 set ylabel font ",18"
 set key font ",14"
 set output 'node-lines$gamma.eps'

 set title font ",18"
 #set font xlabel ",18"
 #set font ylabel ",18"

 set xrange[0:$xy]
 set yrange[0:$xy]

 set title "Line between nodes gamma$gamma"

 plot "node-lines$gamma.dat" with lp ps 0.2
 pause -1
EOF


mv node-lines$gamma.dat seed$seed/gamma$gamma/coordinates
mv node-lines$gamma.eps seed$seed/gamma$gamma/coordinates



####NODE AGE DISTRIBUTION#####
<< COMMENTOUT
mkdir -p seed$seed/gamma$gamma/node_age

startnodeage=`grep -n "start_nodeage" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
endnodeage=`grep -n "end_nodeage" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`


awk 'NR>'${startnodeage}'{if(NR<'${endnodeage}') print}' log$gamma.dat | awk '{print $1}'> node_age$gamma.dat

awk '{i=1}{print $1,i}' node_age$gamma.dat > nodeage.dat

awk ' BEGIN{MIN=0}{
        BIN=sprintf("%d", $1*(1/BINSIZE))+0;
        DATA[BIN]++;
        #if((!MIN)||(MIN>BIN)) MIN=BIN;
	if(MIN>BIN) MIN=BIN;
	if((!MAX)||(MAX<BIN)) MAX=BIN;
 }
END {
        for(BIN=0; BIN<=MAX; BIN++)
           #     printf("%+2.5f-%+2.5f\t%d\n", (BIN*BINSIZE), (BIN*BINSIZE)+(BINSIZE-0.00001), DATA[BIN]);
	   printf("%d %d\n",BIN*BINSIZE,DATA[BIN]);
}' BINSIZE=$BINSIZE  nodeage.dat | sort -k1g > node_age_pdf$gamma.dat

gnuplot -p << EOF

set term png
set title "Node age gamma=$gamma, seed=$seed"
set output 'node_age_pdf$gamma.png'

set yrange[1:]
set log y
plot "node_age_pdf$gamma.dat" w l ,70*exp(-x/2*1000)
replot

EOF

rm nodeage.dat
mv node_age_pdf$gamma.dat node_age$gamma.dat node_age_pdf$gamma.png seed$seed/gamma$gamma/node_age

COMMENTOUT



#####FRACTAL ANALYSIS######
mkdir -p seed$seed/gamma$gamma/fractal

startfrac=`grep -n "start_fractal" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
endfrac=`grep -n "end_fractal" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`

awk 'NR>'${startfrac}'{if(NR<'${endfrac}') print}' log$gamma.dat | awk '{print $2,$4}'> frac$gamma.dat

gnuplot -p << EOF

set terminal postscript eps enhanced color "Arial,18"
set encoding utf8
set key font ",14"
set lmargin 12
set title "Fractal Analysis {/Symbol b}=$beta, {/Symbol g}=$gamma"

set log xy

set xlabel "Distance from Center"
set ylabel "Number of nodes within distance"

set xrange[1:5000]
set yrange[0.5:$points]

set output 'frac$gamma.eps'

plot "frac$gamma.dat" w l
replot

EOF
#mv frac$gamma.dat frac$gamma.png seed$seed/gamma$gamma/fractal
mv frac$gamma.dat frac$gamma.eps seed$seed/gamma$gamma/fractal

#####DENSITY ANALYSIS#####

mkdir -p seed$seed/gamma$gamma/density
startdens=`grep -n "start_density" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`
enddens=`grep -n "end_density" log$gamma.dat | sed "s/:/ /g" |awk '{print $1}'`

awk 'NR>'${startdens}'{if(NR<'${enddens}') print}' log$gamma.dat | awk '{print $2,$8}'> density$gamma.dat

gnuplot -p << EOF


#set term png
set terminal postscript eps enhanced color "Arial,18"
set encoding utf8
set key font ",14"
set lmargin 12

set log xy
set title "Density ({/Symbol b}=$beta,{/Symbol g}=$gamma)"
set xlabel "Distance from Center"
set ylabel "Density"
#set output 'density$gamma.png'
set output 'density$gamma.eps'


plot "density$gamma.dat" w l
replot

EOF

#mv density$gamma.dat density$gamma.png seed$seed/gamma$gamma/density
mv density$gamma.dat density$gamma.eps seed$seed/gamma$gamma/density



#####HEATMAP#####
mkdir -p seed$seed/gamma$gamma/heatmap
awk '{print $2,$3}' coordinates$gamma.dat > coordinates.dat

./heatmap.out coordinates.dat 1 > list.dat

rm coordinates.dat

startmatrix=`grep -e "start_matrix" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`
endmatrix=`grep -e "end_matrix" -n list.dat| sed "s/:/ /g" |awk '{print $1}'`

#awk 'NR<'${startmatrix}'{print}' list.dat > matrix.dat
awk 'NR>'${startmatrix}'{if(NR<'${endmatrix}') print}' list.dat > matrix.dat

cut -d " " -f2- matrix.dat | awk 'NR>1{if (NR<'${endmatrix}'-2) print}' > matrix1.dat

gnuplot -p << EOF
set terminal postscript eps enhanced color "Arial,18"
set encoding utf8
set key font ",14"
set lmargin 12

set output 'heatmap_beta$beta.eps'

set pm3d map
set palette rgbformula 21,22.23

set palette defined (0 "white", 1 "blue" , 2 "red" , 4 "black")
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

set title "Node Distribution ({/Symbol b}=$beta,{/Symbol g}=$gamma)"
set title font ",18"

#set xtics("0" 0 , "2000" 100, "4000" 200, "6000" 300, "8000" 400, "10000" 499, "12000" 600)
#set ytics("0" 0 , "2000" 100, "4000" 200, "6000" 300, "8000" 400, "10000" 499, "12000" 600)

set xtics("0" 0, "2000" 40, "4000" 80, "6000" 120, "8000" 160, "10000" 199)
set ytics("0" 0, "2000" 40, "4000" 80, "6000" 120, "8000" 160, "10000" 199)
#set ytics("0" 0, "2000" 50, "4000" 100, "6000" 150, "8000" 200, "10000" 249)

#set pm3d interpolate 2,2
plot "matrix1.dat" matrix with image
replot

EOF

rm matrix1.dat matrix.dat
mv heatmap_beta$beta.eps seed$seed/gamma$gamma/heatmap


#####MESH FREQ DISTRIBUTION####


file=coordinates$gamma
awk 'NR>'${endmatrix}'{ print}' list.dat > $file-pdf1.dat

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

set terminal postscript eps color enhanced "Arial,18"
set encoding utf8
set title font ",18"
set xlabel font ",18"
set ylabel font ",18"
set key font ",14"
set encoding utf8

set lmargin 12

set title "Mesh Density Distribution ({/Symbol b}=$beta {/Symbol g}=$gamma)"
#set output "mesh$file.png"
set output "mesh$file.eps"


set xlabel "Number of Firms in Mesh ($mesh×$mesh)"
set ylabel "Frequency"

set log xy
set xrange[0.5:]
set yrange[0.1:]

p "$file-pdf.dat" u 1:2:3 w yerrorbars

replot

EOF

rm $file-pdf1.dat $file-pdf2.dat $file-pdf3.dat $file-pdf4.dat $file-pdf5.dat $file-pdf6.dat list.dat
#mv mesh$file.png $file-pdf.dat seed$seed/gamma$gamma/density
mv mesh$file.eps $file-pdf.dat seed$seed/gamma$gamma/density


#####END######

mv log$gamma.dat seed$seed/gamma$gamma

mv coordinates$gamma.eps coordinates$gamma.dat coor$gamma.dat seed$seed/gamma$gamma/coordinates


done
done

mv seed$seed beta$beta
done
done

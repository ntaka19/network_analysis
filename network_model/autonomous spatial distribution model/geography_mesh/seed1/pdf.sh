file=coordinates1.0
gamma=1.0

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


gnuplot -p << EOF

set term png
set title "Firm distribution in Mesh(20x20) gamma$gamma"
set output "mesh$file.png"

set xlabel "Number of Firms"
set ylabel "Frequency"
set xrange[0.5:6]
set log y


#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 10**6*exp(-3*x) #gamma3.0
p "$file-pdf.dat" u 1:2:3 w yerrorbars, 10**6*exp(-3*x) #gamma3.0
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 40**3*x**-8.0 #gamma1.0
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 30**3*x**-3.0 #gamma2.0
#p "$file-pdf.dat" u 1:2:3 w yerrorbars, 10**3*x**-1.3 #gamma3.0
replot

EOF

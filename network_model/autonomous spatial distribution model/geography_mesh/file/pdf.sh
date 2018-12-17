file=listdata
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
}' BINSIZE=$bin $file.dat > $file-pdf1.dat

awk 'NR>1{print}' $file-pdf1.dat > $file-pdf.dat


#gnuplot
#p "listdata-pdf.dat" using 1:2:3 with yerrorbars, 10**5*x**-4




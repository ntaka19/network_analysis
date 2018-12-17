

awk ' BEGIN{MIN=0}{
        BIN=sprintf("%d", $1*(1/BINSIZE))+0;
        DATA[BIN]++;
        if((!MIN)||(MIN>BIN)) MIN=BIN;
	#if(MIN>BIN) MIN=BIN;
	if((!MAX)||(MAX<BIN)) MAX=BIN;
 }
END {
        for(BIN=0; BIN<=MAX; BIN++)
           #     printf("%+2.5f-%+2.5f\t%d\n", (BIN*BINSIZE), (BIN*BINSIZE)+(BINSIZE-0.00001), DATA[BIN]);
	   printf("%d %d\n",BIN*BINSIZE,DATA[BIN]);
}' BINSIZE=10 tt.dat >ttpdf.dat

#geodist$gamma.dat > geodist_pdf$gamma.dat


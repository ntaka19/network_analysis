
#<< COMMENTOUT
for((i=0;i<9;i++))
do
for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0 4.0 5.0
do

awk '{print $1}' ../log$i/gamma$gamma/cdf/indeg_cdf$gamma.dat > indeg_cdf$i-$gamma.dat
awk '{print $1}' ../log$i/gamma$gamma/cdf/outdeg_cdf$gamma.dat > outdeg_cdf$i-$gamma.dat

#rm indeg_cdf$gamma.dat
#rm outdeg_cdf$gamma.dat

done
done

#COMMENTOUT


for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0 4.0 5.0
do
  cat indeg_cdf*-$gamma.dat |sort -k1gr > indegAvg_$gamma.dat  
  cat outdeg_cdf*-$gamma.dat |sort -k1gr > outdegAvg_$gamma.dat 
   
  wc_in=`wc -l indegAvg_$gamma.dat | awk '{print $1}'`
  wc_out=`wc -l outdegAvg_$gamma.dat | awk '{print $1}'`

  
  awk '{print $1,NR/'${wc_in}'}' indegAvg_$gamma.dat > indegCDF_ens$gamma.dat
  awk '{print $1,NR/'${wc_out}'}' outdegAvg_$gamma.dat > outdegCDF_ens$gamma.dat
  
done



for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0
do
gnuplot -p << EOF

  set title "Degree CDF (gamma=$gamma)"
  set ylabel "Probability"
  set xlabel "Degree"
  set log xy

  set term png
  set output 'cdf_ensemble$gamma.png'

  #plot "indegCDF_ens0.0.dat" w l, "outdegCDF_ens0.0.dat" w l, x**-2
  plot "indegCDF_ens$gamma.dat" w l, "outdegCDF_ens$gamma.dat" w l, x**-2
  replot
  
EOF
done

#COMMENTOUT

gnuplot -p << EOF

  set title "In-degree CDF"
  set ylabel "Probability"
  set xlabel "In-degree"
  set log xy

  set term png
  set output 'cdf_ensembleINDEGREE.png'

  p "indegCDF_ens0.0.dat" w l, "indegCDF_ens1.0.dat" w l, "indegCDF_ens2.0.dat" w l,"indegCDF_ens3.0.dat" w l,x**-2

  replot
EOF

gnuplot -p << EOF

  set title "Out-degree CDF"
  set ylabel "Probability"
  set xlabel "Out-degree"
  set log xy

  set term png
  set output 'cdf_ensembleOUTDEGREE.png'

  p "outdegCDF_ens0.0.dat" w l, "outdegCDF_ens1.0.dat" w l,"outdegCDF_ens2.0.dat" w l, "outdegCDF_ens3.0.dat" w l, x**-2

  replot
EOF


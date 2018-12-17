#a*x**b,fit range [10:1000]
#fit [10:1000] a*x**b "ensemble_dim1.0.dat" via a,b
#gamma 
#0.0 
a0=0.00122156; b0=1.99636
#0.5 
a1=0.00153113; b1=1.98395
#1.0 
a2=0.00348835; b2=1.89412 
#1.5 
a3=0.0426744; b3=1.60284 
#2.0 
a4=7.08889 ; b4=0.971944
#2.5 
a5=101.583 ;b5=0.654705
#3.0 
a6=496.381; b6=0.490911


#gamma=2.0

gamma=2.0
#for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0
#do
gnuplot -p <<EOF

set term png
set output "ensemble_dim$gamma.png"

set log xy
set title "Distance-count gamma$gamma"
set xrange[0.5:]
set yrange[0.5:]
set xlabel "Distance from center"
set ylabel "Number of points"

#p "ensemble_dim$gamma.dat" w l, $a0*x**$b0
#p "ensemble_dim$gamma.dat" w l, $a1*x**$b1
#p "ensemble_dim$gamma.dat" w l, $a2*x**$b2
#p "ensemble_dim$gamma.dat" w l, x**2,$a3*x**$b3
p "ensemble_dim$gamma.dat" w l, x**2,$a4*x**$b4
#p "ensemble_dim$gamma.dat" w l, x**2,$a5*x**$b5
#p "ensemble_dim$gamma.dat" w l, x**2,$a6*x**$b6

replot

EOF
#done

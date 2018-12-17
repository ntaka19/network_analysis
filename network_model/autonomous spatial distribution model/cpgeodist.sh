
<<COMMENTOUT
for gamma in 0.0 -0.5 -1.0 -1.5 -2.0 -2.5 -3.0
do
for beta in 3.0 2.5 2.0 1.5 1.0 0.5 0.0
do

mkdir -p geodist/beta$beta  
cp beta$beta/seed0/gamma$gamma/geodist/geodist_cdf$gamma.dat geodist/beta$beta/.
cp beta$beta/seed0/gamma$gamma/geodist/geodist_pdf$gamma.dat geodist/beta$beta/.

#ensembleを挟みたい、、。

done
done

COMMENTOUT


for beta in 3.0 2.5 2.0 1.5 1.0 0.5 0.0
do

cd geodist/beta$beta

#<<COMMENTOUT
gnuplot -p << EOF

#set term postscript enhanced color

set terminal postscript eps color enhanced "Arial,18"
set encoding utf8
set title font ",18"
set xlabel font ",18"
set ylabel font ",18"
set key font ",14"

set title "Euclid Distance Distribution ({/Symbol b}=$beta)"
set output 'geodist_cdf_beta$beta.eps'

#set label 1 at graph 0.4,0.4 "{/Symbol \265} x^{-2.0}" font ",20"

set lmargin 14

set ylabel "CDF"
set xlabel "Euclid Distance"

#set yrange[:1]
set xrange[0.1:10000]

set log xy

g(x,min,max)=( (x>=min && x<=max)? 1.0 : (1/0) )

plot "geodist_cdf0.0.dat"  w l title "{/Symbol g}=0.0" , \
"geodist_cdf-0.5.dat"  w l title "{/Symbol g}=-0.5" ,\
"geodist_cdf-1.0.dat"  w l title "{/Symbol g}=-1.0" ,\
"geodist_cdf-1.5.dat"  w l title "{/Symbol g}=-1.5" ,\
"geodist_cdf-2.0.dat"  w l title "{/Symbol g}=-2.0" ,\
"geodist_cdf-2.5.dat"  w l title "{/Symbol g}=-2.5" ,\
"geodist_cdf-3.0.dat"  w l title "{/Symbol g}=-3.0" 


replot

EOF


gnuplot -p << EOF

#set term postscript enhanced color

set terminal postscript eps color enhanced "Arial,18"
set encoding utf8
set title font ",18"
set xlabel font ",18"
set ylabel font ",18"
set key font ",14"

set title "Euclid Distance Distribution ({/Symbol b}=$beta)"
set output 'geodist_pdf_beta$beta.eps'

#set label 1 at graph 0.4,0.4 "{/Symbol \265} x^{-2.0}" font ",20"

set lmargin 14

set ylabel "CDF"
set xlabel "Euclid Distance"

#set yrange[:1]
#set xrange[0.1:10000]

#set log xy

g(x,min,max)=( (x>=min && x<=max)? 1.0 : (1/0) )

plot "geodist_pdf0.0.dat"  w l title "{/Symbol g}=0.0" , \
"geodist_pdf-0.5.dat"  w l title "{/Symbol g}=-0.5" ,\
"geodist_pdf-1.0.dat"  w l title "{/Symbol g}=-1.0" ,\
"geodist_pdf-1.5.dat"  w l title "{/Symbol g}=-1.5" ,\
"geodist_pdf-2.0.dat"  w l title "{/Symbol g}=-2.0" ,\
"geodist_pdf-2.5.dat"  w l title "{/Symbol g}=-2.5" ,\
"geodist_pdf-3.0.dat"  w l title "{/Symbol g}=-3.0" 


replot

EOF




cp geodist_cdf_beta$beta.eps ../../../../soturon/diagram/asdn/geodist
cp geodist_pdf_beta$beta.eps ../../../../soturon/diagram/asdn/geodist

cd ../../

done

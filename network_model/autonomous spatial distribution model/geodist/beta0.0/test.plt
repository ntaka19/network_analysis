
g(x,min,max)=( (x>=min && x<=max)? 1.0 : (1/0) )


set log xy
set xrange[1:]
plot "geodist_pdf0.0.dat"  title "{/Symbol g}=0.0" , \
"geodist_pdf-0.5.dat" title "{/Symbol g}=-0.5" ,\
"geodist_pdf-1.0.dat" title "{/Symbol g}=-1.0" ,\
"geodist_pdf-1.5.dat" title "{/Symbol g}=-1.5" ,\
"geodist_pdf-2.0.dat" title "{/Symbol g}=-2.0" ,\
"geodist_pdf-2.5.dat" title "{/Symbol g}=-2.5" ,\
"geodist_pdf-3.0.dat"  title "{/Symbol g}=-3.0" ,\
10**6*x**-1*g(x,1,10000) with lines dt (10,5) ,\
10**6*x**-1.5*g(x,1,10000) with lines dt (10,5) ,\
10**8*x**-2*g(x,1,10000) with lines dt (10,5)



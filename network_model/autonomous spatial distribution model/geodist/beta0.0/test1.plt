
g(x,min,max)=( (x>=min && x<=max)? 1.0 : (1/0) )


set log xy
plot "geodist_cdf0.0.dat"  w l title "{/Symbol g}=0.0" , \
"geodist_cdf-0.5.dat"  w l title "{/Symbol g}=-0.5" ,\
"geodist_cdf-1.0.dat"  w l title "{/Symbol g}=-1.0" ,\
"geodist_cdf-1.5.dat"  w l title "{/Symbol g}=-1.5" ,\
"geodist_cdf-2.0.dat"  w l title "{/Symbol g}=-2.0" ,\
"geodist_cdf-2.5.dat"  w l title "{/Symbol g}=-2.5" ,\
"geodist_cdf-3.0.dat"  w l title "{/Symbol g}=-3.0" ,\
#10**6*x**-1*g(x,1,10000) with lines dt (10,5) ,\
#10**6*x**-1.5*g(x,1,10000) with lines dt (10,5) ,\
#10**8*x**-2*g(x,1,10000) with lines dt (10,5)



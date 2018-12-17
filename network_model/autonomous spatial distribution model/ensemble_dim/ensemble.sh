#<< COMMENTOUT

for((i=0;i<10;i++))
do
for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0
do
cp ../log$i/gamma$gamma/fractal/frac$gamma.dat .

awk '{print $2}' frac$gamma.dat > frac$i-$gamma.dat

done
done

for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0
do
  paste frac*-$gamma.dat > fracdim$gamma.dat
done

#COMMENTOUT


rm test*.dat 
rm ensemble_dim*.dat

for gamma in 0.0 0.5 1.0 1.5 2.0 2.5 3.0
do
  awk '{sum=0}{for (i=1;i<=500;i++){
   sum+=$i;   
  }print sum/10}
  ' fracdim$gamma.dat | awk '{print (NR-1)*10,$1}' > ensemble_dim$gamma.dat

done 

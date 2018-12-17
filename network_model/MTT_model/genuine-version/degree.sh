#!/bin/bash

#out degree
#echo "outdegree"
#awk '{D[$1]+=1}END{for(i in D){print i,D[i]}}' list.dat | sort -gr > outdegfb.dat

#echo "indegree"
#awk '{D[$2]+=1}END{for(i in D){print i,D[i]}}' list.dat

#無向グラフに関する次数測定
awk '{D[$1]+=1;S[$2]+=1}END{for(i in S) print i,(D[i]+S[i]); for (i in D) print i,(D[i]+S[i])}' list.dat | sort -gr | uniq | sort -k2gr > degree.dat 

sum=`wc -l degree.dat | awk '{print $1}'`
awk '{print $2,NR/'${sum}'}' degree.dat > cdf.dat

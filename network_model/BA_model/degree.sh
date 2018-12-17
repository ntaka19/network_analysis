#!/bin/bash

#out degree
echo "outdegree"
awk '{D[$1]+=1}END{for(i in D){print i,D[i]}}' list.dat | sort -gr > outdegfb.dat

#echo "indegree"
#awk '{D[$2]+=1}END{for(i in D){print i,D[i]}}' list.dat


#無向グラフに関する次数測定
awk '{D[$1]+=1;S[$2]+=1}END{for(i in S) print i,(D[i]+S[i])/2; for (i in D) print i,(D[i]+S[i])/2}' list.dat | sort -gr | uniq  

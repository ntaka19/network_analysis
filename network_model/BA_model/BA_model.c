#include <stdio.h> 
#include <stdlib.h> 

int function(int N, int m0, int m){
  int edge_num=m*(N-m)+m*(m-1)/2;
  int k[N];
  int E[2*edge_num];
  int i,j,ve,found,done[m];
  int M = 0;

  //create initial complete graph
  for (i=0;i<m0;i++){
    k[i] = m0-1;
    for (j=0;j<i;j++){
      E[2*M]=i; E[2*M+1]=j;
      M++;
    }
  }
  for (i=m0;i<N;i++){
    k[i] = 0;
    while(k[i]<m){
      
      //ここで優先的接続が行われている。
      do{ve = E[rand()%(2*M)]; }while(ve==i);
      found = 0;

      for(j=0;j<k[i];j++){if(done[j]==ve){found=1;}}
      if (found==0){
	done[k[i]]=ve;
	E[2*M]=i; k[i]++;
	E[2*M+1]=ve; k[ve]++;
	M++;
	}
     }
  }
  
  //printf("vertex1,vertex2\n");
  for (int i=0; i<=edge_num-1;i++){
    printf("%d %d\n", E[2*i],E[2*i+1]);
  }
} 

int main(){
  function(1000,10,8);
}

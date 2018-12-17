#include <stdio.h> 
#include <stdlib.h> 

int function(int N,int m0, int m,int T){
  int edge_num=m*(N-m)+m*(m-1)/2;
  int E[2*edge_num];
  int A[2*edge_num];
  
  int i,ve,j,done[m],found; 
  double prob,ri;
  int delete;

  int k[N]; 
  int M = 0;
  int q;
  int tmp,p,sum; 
  srand(12);
  int count =0;



  //完全グラフの作成  
  for (i=0;i<m0;i++){
    k[i]= m0-1;

    for(j=0;j<i;j++){
      E[2*M]=i;E[2*M+1]=j;
      M++;
    }
  } printf("i=%d,M=%d\n",i,M);
  
  //printf("%d\n",E[2*M-2]);
  /*for(int i=0;i<10;i++){
  delete=(int)rand()%(E[2*M-2]+1);
  printf("%d\n",delete);
  }*/
  //delete=(int)rand()%(E[2*M-2]+1);
  
  
  delete = 0;
  printf("delete=%d\n",delete);
  printf("E[2M-1]=%d\n",E[2*M-1]);

  for(int i=0;i<2*M;i++){
    if(E[i]==delete){
      k[i]=0;
      E[i]=-1;

      if(i%2==0){
	  E[i+1]=-1; k[i+1]--;
      }
      else{
	  E[i-1]=-1; k[i-1]--;
      }
    }
 }
 
//結果出力  
 printf("\n最終結果:\n");
 for(int i=0;i<M;i++){
    if(E[2*i]!=-1 && E[2*i+1]!=-1){
      printf("%d %d\n", E[2*i],E[2*i+1]);
    }
  }
/*  
 int s = 0;
 for(int i=0;i<M;i++){
    if(E[2*i]!=-1 && E[2*i+1]!=-1){
      A[2*s]=E[2*i];A[2*s+1]=E[2*i+1];
      s++;
    }
  }
  
  for(int i=0;i<2*s-1;i++){
      printf("%d %d\n", A[2*i],A[2*i+1]);
    }
    */
}

int main(){
  function(5,3,2,1); //N,m,m0,T //M means max number of nodes
}


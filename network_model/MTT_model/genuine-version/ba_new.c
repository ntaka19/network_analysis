#include <stdio.h> 
#include <stdlib.h> 
#define N 200000


int function(int T, int m0, int m){
  int edge_num=m*(N-m)+m*(m-1)/2;
  int k[N];
  int E[2*edge_num];
  int i,j,ve,found,done[m];
  int p,sum;
  int M = 0;
  int tmp;
  double ri; 
  srand(2); //乱数の種類

  //完全グラフを先に作る。
  for (i=0;i<m0;i++){
    k[i] = m0-1;
    for (j=0;j<i;j++){
      E[2*M]=i; E[2*M+1]=j;
      M++;
    }
  }


    //初期化
    sum = (m0-1)*m0; 
    i=m0;
    
    for (int t=0;t<T;t++){
      k[i] = 0;

      while(k[i]<m){
	//ここで優先的接続が行う。
       ri = sum*(double)rand()/RAND_MAX;
	
	p=0; 
	tmp=k[0];
	while(tmp<ri){
	  p++;
	  tmp+=k[p];//ここにある倍数をかけることで、割合を変更することが可能？
	} ve = p;

	found = 0;

	for(j=0;j<k[i];j++){if(done[j]==ve){found=1;}}
	if (found==0){
	  done[k[i]]=ve;
	  E[2*M]=i; k[i]++;
	  E[2*M+1]=ve; k[ve]++;
	  M++;
	  sum+=2;
	}	
      }i++;
  }





  for (int i=0; i<M;i++){
    printf("%d %d\n", E[2*i],E[2*i+1]);
  }
}
int main(){
  function(2,3,2);
}

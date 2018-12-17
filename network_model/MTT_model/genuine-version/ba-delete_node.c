#include <stdio.h> 
#include <stdlib.h> 
#define N 200000


int function(int T,double P, int m0, int m){
  int edge_num=m*(N-m)+m*(m-1)/2;
  //int k[N];
  //int E[2*edge_num];
  int *k,*E;
  k = (int *)calloc(N,sizeof(int));
  E = (int *)calloc(2*edge_num,sizeof(int));

  int i,j,ve,found,done[m];
  int p,sum;
  int M = 0;
  int tmp,delete,count;
  double ri,prob; 
  srand(2); //乱数の種類

  //完全グラフを先に作る。
  for (i=0;i<m0;i++){
    k[i] = m0-1;
    for (j=0;j<i;j++){
      E[2*M]=i; E[2*M+1]=j;
      M++;
    }
  }


   ////初期化////
    sum = (m0-1)*m0; 
    i=m0;
    
  //T時間の間で削除あるいは、ノードの優先的接続//
  for (int t=0;t<T;t++){
     
    prob = (double)rand()/RAND_MAX;
    count=0;
    for(int q=0;q<N;q++){
      if(k[q]>0) {count++;}
      }
    //printf("count=%d\n",count);
    if(count==0){break;}
  

      
    if(prob>=P){
      k[i] = 0;

      while(k[i]<m){
	//ここで優先的接続が行う。
       do{ri = sum*(double)rand()/RAND_MAX;
	
	p=0; 
	tmp=k[0];
	
	while(tmp<ri){
	  p++;
	  tmp+=k[p];//ここにある倍数をかけることで、割合を変更することが可能？
	} ve = p;}while(ve==i);//自分自身をつなげてはいけない。

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

  //削除のケース//
    else{
      do{delete=(int)rand()%(t+1);}while(k[delete]<=0);
      //printf("delete=%d\n",delete);
      
      for(int q=0;q<2*M;q++){
	if(E[q]==delete){
	  k[delete]=0;

	  if(q%2==0){
	    k[E[q+1]]-=1;
	    E[q+1]=-1;
	  }
	  else{
	    k[E[q-1]]-=1;
	    E[q-1]=-1;
	  }
	  E[q]=-1;
	  sum-=m;
	  }
	}
     }
 }
  




//最終的な出力///
  for (int i=0; i<M;i++){
    if(E[2*i]>-1 && E[2*i+1]>-1){
    printf("%d %d\n", E[2*i],E[2*i+1]);
    }
  }
}
int main(){
  function(10000,0.0,5,4); //T,P(>=Pでノード追加),m0(初期ノード数),m(枝の数)
}

#include <stdio.h> 
#include <stdlib.h> 

void add(int *k,int *E,int q, int m,int M);
void rmove(int *k,int *E,int q, int m,int M);

int function(int N,int m0, int m){
  int i,j,T; 
  double prob;
  int k[N];
  int M = 0;
  int q;
  int sum; 
  
  int E[2*m*(N-m)+m*(m-1)]; 
  srand(2);

  //完全グラフの作成  
  for (i=0;i<m0;i++){
    k[i]= m0-1;
    for(j=0;j<i;j++){
      E[2*M]=i;E[2*M+1]=j;
      M++;
    }
  } 

  for (i=0;i<T;i++){
    prob = rand()/RAND_MAX;
    q = i+m0; 

    if(prob>0.5){
      add(k,E,q,m,M);
    }else{
      //rmove(k,E,q,m,M);
      return;
    }
  }
}

void add(int *k, int *E, int q,int m,int M){
   k[q]=0;  
   while(k[q]<m){
   //ここで優先的接続が行う。
   double ri = sum*(double)rand()/RAND_MAX;
      
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
	//これでどこに接続したか追うことができる
	//printf("%d\n",p);
    }
  }
}

void rmove(int *k, int *E,int q, int m,int M){
  return;
}


int main(){
  function(4,4,2);
}


#include <stdio.h> 
#include <stdlib.h> 

void add(int *k,int *E,int q, int m,int M);
void rmove(int *k,int *E,int q, int m,int M);

int function(int N,int m0,int m,int T){
  //初期設定
  int edge_num=m*(N-m)+m*(m-1)/2;
  int E[2*edge_num];
  int i,ve,j,done[m],found; 
  double prob,ri;
  int delete;

  int k[N];
  int M = 0;
  int q;
  int tmp,p,sum; 
  srand(10);

  //完全グラフの作成  
  for (i=0;i<m0;i++){
    k[i]= m0-1;
    for(j=0;j<i;j++){
      E[2*M]=i;E[2*M+1]=j;
      M++;
    }
  } 

  sum=(m0-1)*m0;
  printf("%d\n",i);//この段階でi=m0になっている。 
  
  //Tは試行回数である。
  for(int t=0;t<T;t++){
   //確率を見つける。それによって操作が変わる。
   prob = (double)rand()/RAND_MAX; printf("prob=%lf\n",prob); 
   //一つ点を付け加え、つなげるi=m0からスタート。
   if(prob>0.5){
     if(i>=m0){
      printf("added node %d\n\n",i);  
    
      k[i] = 0;
      while(k[i]<m){
	ri = sum*(double)rand()/RAND_MAX;
	p =0;
	tmp=k[0];
	while(tmp<ri){
	  p++;
	  tmp+=k[p];
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
      }	
     }i++; //ここで次のノードに標準を表す。
    }
    
   else{//ノード削除
    
    do{
    delete =rand()%i; //0から数えて何番目のノードを削除するか。
    }while(k[delete]==0);
    printf("i=%d,delete = %d\n\n",i,delete);    
    
    for(int j=0;j<N;j++){
      if(E[j]==delete){
	k[delete]=0;

	if(j%2==0){
	  k[E[j+1]]--;
	  E[j]=-1;
	  E[j+1]=-1;

	}else{
	  k[E[j-1]]--;
	  E[j]=-1;
	  E[j-1]=-1;
	}
      }
      sum -= 2;
    }
   }
  }
  

  printf("\n最終結果:\n");
  for(int i=0;i<M;i++){
    if(E[2*i]!=-1 && E[2*i+1]!=-1){
    printf("%d %d\n", E[2*i],E[2*i+1]);
    }
  }
}

int main(){
  function(10,3,2,2); //N,m,m0,T //M means max number of nodes
}


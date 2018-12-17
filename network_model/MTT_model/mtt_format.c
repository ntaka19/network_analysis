//ノードの追加(優先的接続)と消滅を入れた成長モデル

#include <stdio.h> 
#include <stdlib.h> 
#define N 20000 //maxiumum number of nodes


int function(int m0, int m,int T){
  int edge_num=m*(N-m)+m*(m-1)/2;
  //int E[2*edge_num];
  int A[2*edge_num];
  int i,ve,j,done[m],found; 
  double prob,ri;
  
  //deleteに関する部分
  int delete;
  int *k,*E;
  k = (int *)calloc(N,sizeof(int));
  E = (int *)calloc(2*edge_num,sizeof(int));
 // int k[N]={0};

  int M = 0;
  int q;
  int tmp,p,sum; //sumは次数の合計
  srand(8);
  int count =0;
  

  //完全グラフの作成  
  for (i=0;i<m0;i++){
    k[i]= m0-1;
      for(j=0;j<i;j++){
        E[2*M]=i;E[2*M+1]=j;
	M++;
      }
    } 
      //printf("start:i=%d,M=%d\n\n",i,M);
      sum=(m0-1)*m0;

   for(int t=0;t<T;t++){
      //printf("t=%d\n",t);
      
      //初期設定
      //存在しているノードの数を数える。
      count=0; 
      for(int i=0;i<N;i++){
	  if(k[i]>0){
	    //printf("k[%d]=%d\n",i,k[i]);
	    count +=1;
	  }
	}
      if(count==0){
	break;
      }
      //次数の合計を数える。
      /*for(int i=0;i<N;i++){
	(k[i]>0){
	  sum+=k[i];
	}
      }*/

 
     prob = (double)rand()/RAND_MAX; 
     //printf("prob=%lf\n",prob); 
     if(prob>=0){
	//printf("added node %d\n",i);  
	k[i] = 0;
	
	while(k[i]<m){
	  do{
	  ri = sum*(double)rand()/RAND_MAX;
	  
	  p =0;
	  tmp=k[0]; //edit
	  while(tmp<ri){
	    p++;
	    if(k[p]>-1){
	      tmp+=k[p];
	    }
	  }ve=p;}while(ve==i);//自分自身につないではいけない。 
	  found = 0;
	
	for(j=0;j<k[i];j++){if(done[j]==ve){found=1;}}
	  if (found==0){
	    done[k[i]]=ve;
	    E[2*M]=i; k[i]++;
	    E[2*M+1]=ve; k[ve]++;
	    M++;
	    sum+=m;//ノードを一つ追加すると、合計の次数はm個増える
	  }
	}i++;
       } 
  //ここで次のノードに標準を表す。
  
 else{ 
  //tは一番最新のノード番号に対応している
  //0からtまでの中で、存在する(k[]>0)ノードを削除する
  //printf("t=%d\n",t);
  do {delete=(int)rand()%(t+1);}while(k[delete]<=0);
  //printf("delete=%d\n",delete);
  //printf("E[2M-1]=%d\n",E[2*M-1]);

  for(int q=0;q<2*M;q++){
    if(E[q]==delete){
      k[delete]=0;
      
      if(q%2 ==0){
	  k[E[q+1]]-=1;
	  //printf("k[%d]=%d\n",E[q+1],k[E[q+1]]);
	  E[q+1]=-1;
      }
      else{
	  k[E[q-1]]-=1;
	  //printf("k[%d]=%d\n",E[q-1],k[E[q-1]]);
	  E[q-1]=-1;
      }
      
      E[q]=-1;
      sum-=m;//ノードを一つ削除すると、合計の次数がm本減る。
    }
  }
 }

//一度目の実行の状態表示
    //printf("///1ループ後の状態///\n");
    count =0;

    //printf("///k[ノード番号]=次数///\n");
    for(int i=0;i<N;i++){
	  if(k[i]>0){
	   // printf("k[%d]=%d\n",i,k[i]);
	    count +=1;
	  }
	}
    
    //printf("///存在するノード数(count)///\n");
    //printf("count=%d,M=%d\n",count,M);
    //printf("///隣接リスト///\n");
    /*for(int i=0;i<M;i++){
	if(E[2*i]!=-1 && E[2*i+1]!=-1){
	  printf("%d %d\n", E[2*i],E[2*i+1]);
	}
      }printf("\n");*/
    }


    //最終結果出力  
  //   printf("最終結果:\n\n");

     for(int i=0;i<M;i++){
	if(E[2*i]>-1 && E[2*i+1]>-1){
	  printf("%d %d\n",E[2*i],E[2*i+1]);
	}
      }
}
int main(){
  function(5,4,10000); //m0,m,T //m0>m
}


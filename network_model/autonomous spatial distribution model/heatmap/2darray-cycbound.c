#include <stdio.h> 
#include<stdlib.h>
#include<math.h>
#include "mesh.h"
#define sys_size 1000 //xy座標の長さ
#define file_size 30000 //頂点数
#define cell 10 
//メッシュに区切った時の正方形の面積

void solve(double **matcopy,int freq);
void dfs(int x,int y, int freq,double **matcopy,double *clustersize,int res, struct Mesh **mesh,int *num);

int main(int argc,char **argv){
  //int **own; 
  FILE *FP;
  
  double **mat;
  double **matcopy;

  mat = calloc(sys_size, sizeof(double*));
  matcopy=calloc(sys_size,sizeof(double*));
  
  for (int i=0;i<sys_size;i++){
    mat[i] = (double *)calloc(sys_size, sizeof(double));
    matcopy[i] = (double *)calloc(sys_size, sizeof(double));
  }

  
  double *u1,*v1;
  u1 = calloc(file_size, sizeof(double*));
  v1 = calloc(file_size, sizeof(double*));
  
  double u,v;
  int num=0;
 
  if((FP=fopen(argv[1],"r"))==NULL){
    printf("error\n");
    exit(1);
  }
  
  int i=0;
  while(fscanf(FP,"%lf %lf",&u,&v)!=EOF){
    u1[i]=u;
    v1[i]=v;
    i++;
    num++;
    }

  for (int i=0;i<num;i++){
    mat[(int)floor(u1[i]/cell)][(int)floor(v1[i]/cell)]+=1;
    matcopy[(int)floor(u1[i]/cell)][(int)floor(v1[i]/cell)]+=1;
  }
 
 for (int i=0;i<=(int)sys_size/cell;i++){//(int)sys_size/cell;j++){ 
  printf(" %d ",(int)i*cell);
  }printf("\n");
 
 for (int j=0;j<(int)sys_size/cell;j++){//(int)sys_size/cell;j++){ 
  printf("%d ",(int)j*cell);
  for (int i=0;i<(int)sys_size/cell;i++){
    printf("%lf ",mat[i][j]);
    }printf("\n");
  }
  printf("%d\n",sys_size);

  //ここでクラスタの計算を行う
  int freq = 100; //連結とみなすクラスターサイズの最小値を指定
  solve(matcopy,freq); 

  //例えば2毎に区切りたいのであれば、floor(u1/2)
  free(u1);
  free(v1);
  free(mat);
  free(matcopy);
  free(FP);
}


void dfs(int x, int y,int freq, double **matcopy,double *clustersize,int res,struct Mesh **mesh,int *num){
 matcopy[x][y]=-1;

 for (int dx=-1;dx<=1;dx++){
  for(int dy=-1;dy<=1;dy++){
    int nx = x+dx, ny= y+dy;
    
    if(nx<0){
      nx = sys_size/cell+nx;
    }if(ny<0){
      ny = sys_size/cell+ny;
    }if(nx>=sys_size/cell){
      nx = nx-sys_size/cell;
    }if(ny>=sys_size/cell){
      ny = ny-sys_size/cell;
    }

    if(matcopy[nx][ny]>freq){//&& matcopy[nx][ny]>-1){
      clustersize[res] +=1; 
      *num +=1; 	
      mesh[res][*num].x = nx*cell;
      mesh[res][*num].y = ny*cell;
      dfs(nx,ny,freq,matcopy,clustersize,res,mesh,num);
    }
  }
 }
 return;
}

void solve(double** matcopy,int freq){
  int res = 0;
  int *num;
  int nump = 0;
  num = &nump; 

  double *clustersize;
  clustersize = (double *)calloc(sys_size, sizeof(double));
  
   //一つのclusterの座標を見つける。
  struct Mesh **mesh;

  mesh = calloc(file_size,sizeof(double));
  for (int i=0;i<sys_size;i++){
    mesh[i]=(struct Mesh*)calloc(sys_size,sizeof(struct Mesh));
  }


  for(int i=0;i<sys_size/cell; i++){
    for (int j=0; j<sys_size/cell; j++){
      if(matcopy[i][j]>freq){
	clustersize[res]+=1;

	mesh[res][*num].x = i*cell;
	mesh[res][*num].y = j*cell;	
	
	dfs(i,j,freq,matcopy,clustersize,res,mesh,num);
	
	res+=1; //次のクラスタ
	*num = 0;//reset num
      }
    }
  }
  printf("clusters\n");
  printf("freq: %d cluster_num: %d\n\n",freq,res);
   
  for (int i=0;i<res;i++){
    printf("cluster%d size: %lf\n",i,clustersize[i]);
    printf("mesh coordinates\n"); 
    for (int j=0;j<clustersize[i];j++){
     printf("%lf %lf\n",mesh[i][j].x,mesh[i][j].y);
    }
    printf("\n");
}
 
 //mesh[res][i] はクラスタ番号resのi番目の要素を示す。
 //クラスタサイズ分iはあるはず。
 /*
 int i=0; 
 while (mesh[0][i].x!=0 && mesh[0][i].x!=0){ 
  printf("%lf %lf\n",mesh[0][i].x,mesh[0][i].y);
  i++;
 }*/

  free(clustersize);
}




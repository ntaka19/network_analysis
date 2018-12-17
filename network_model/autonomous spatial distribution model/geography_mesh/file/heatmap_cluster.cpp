#include<cmath>
#include<iostream>
#include<cstdlib>
#include<cstdio>
#include<vector>
#include<cstring>
#include<fstream>
#include<map>
#include<string>
#include<random>
#include<algorithm>

#include "ClusterElm.h"

#define sys_size 10000 //xy座標の長さ
#define file_size 30000 //頂点数
#define cell 20 

using namespace std;
//メッシュに区切った時の正方形の面積

void solve(vector<vector<double>>& matcopy,int freq);
void dfs(int x,int y, int freq,vector<vector<double>> &matcopy,int res, vector<ClusterElm>& clusterelm,int *num);

int main(int argc,char **argv){
  
  int num=0;
  int i=0;
  double ltext,rtext;
  
  int freq = atoi(argv[2]);

  vector<double> u1; //u1(file_size);
  vector<double> v1; //v1(file_size);

  string reading_line_buffer;
  ifstream reading_file;

  reading_file.open(argv[1]);
  //reading_file.open("coordinates.dat");

  if(reading_file.fail()){
    cerr<<"File do not exist\n";
    exit(0);
  }
  
  while(true){ 
    //sscanf(str.data(),"%s %s",rtext.c_str(),ltext.c_str());
    reading_file >> ltext >> rtext;
    if(reading_file.eof()) break;
    u1.push_back(ltext);
    v1.push_back(rtext);
    i++;
    num++;

  }
 
  vector< vector<double> > mat (sys_size,vector<double>(sys_size)); 
  vector< vector<double> > matcopy (sys_size,vector<double>(sys_size)); 
   
  for (int i=0;i<num;i++){
    mat[(int)floor((u1[i])/cell)][(int)floor((v1[i])/cell)]+=1;
    //matcopy[(int)floor(u1[i]/cell)][(int)floor(v1[i]/cell)]+=1;
  }

  /////MATRIX OUTPUT/////
  printf("start_matrix\n"); 

  for (int i=0;i<=(int)sys_size/cell;i++){//(int)sys_size/cell;j++){ 
   printf("%.3lf ",(double)(i*cell));
  }printf("\n");
 
  for (int j=0;j<(int)sys_size/cell;j++){//(int)sys_size/cell;j++){ 
    printf("%.3lf ",(double)(j*cell));
  
    for (int i=0;i<(int)sys_size/cell;i++){
      printf("%lf ",mat[i][j]);
    }printf("\n");
  
  }
  printf("%d\n",sys_size);

  printf("end_matrix\n"); 
 /////CLUSTER FUNCTION///// 
  //solve(matcopy,freq); 
  vector<int> listfreq;

  for(int i=0; i<(int)sys_size/cell; i++){
    for(int j=0;j<(int)sys_size/cell; j++){
      listfreq.push_back(mat[i][j]);
      //printf("%d\n",mat[i][j]);
    }
  }
  
  sort(listfreq.begin(), listfreq.end(),greater<int>());
  for(int i=0;i<(int)listfreq.size(); i++){
    cout << listfreq[i] << endl; 
  }

}


void dfs(int x, int y,int freq, vector<vector<double>>& matcopy,int res,vector<vector <ClusterElm> >& clusterelm,int *num){
 matcopy[x][y]=-1; //見終わった後

 //縦横の接続
 for (int dx=-1;dx<=1;dx++){
    int nx = x+dx;
    int ny = y;
    if(0<=nx && nx<sys_size/cell && 0<=ny && ny<sys_size/cell && matcopy[nx][ny]>=freq){
      
      ClusterElm new_cluster_elm;
      clusterelm[res].push_back(new_cluster_elm);

      *num +=1; 	
      clusterelm[res][*num].x = nx*cell;
      clusterelm[res][*num].y = ny*cell;
      dfs(nx,ny,freq,matcopy,res,clusterelm,num);
    }
  }

  for(int dy=-1;dy<=1;dy++){
    int ny= y+dy;
    int nx = x;
    if(0<=nx && nx<sys_size/cell && 0<=ny && ny<sys_size/cell && matcopy[nx][ny]>=freq){
      
      ClusterElm new_cluster_elm;
      clusterelm[res].push_back(new_cluster_elm);

      *num +=1; 	
      clusterelm[res][*num].x = nx*cell;
      clusterelm[res][*num].y = ny*cell;
      dfs(nx,ny,freq,matcopy,res,clusterelm,num);
    }
  }

 return;
}

void solve(vector<vector<double>>& matcopy,int freq){
  int res = 0;
  int *num;
  int nump = 0;
  num = &nump; 

  double *clustersize;
  clustersize = (double *)calloc(sys_size, sizeof(double));
  //vector<int> clustersize[sys_size];

   //一つのclusterの座標を見つける。
  vector< vector<ClusterElm> > clusterelm;

  /*
  for (int i=0;i<sys_size;i++){
    mesh[i]=(struct ClusterElm*)calloc(sys_size,sizeof(struct ClusterElm));
  }*/

  for(int i=0;i<sys_size/cell; i++){
    for (int j=0; j<sys_size/cell; j++){
      if(matcopy[i][j]>=freq){
	
	vector<ClusterElm> new_cluster;
	clusterelm.push_back(new_cluster);	
	ClusterElm new_cluster_elm;
	clusterelm[res].push_back(new_cluster_elm);
	
	clusterelm[res][*num].x = i*cell;
	clusterelm[res][*num].y = j*cell;	
	
	dfs(i,j,freq,matcopy,res,clusterelm,num);
	
	res+=1; //次のクラスタ
	
	*num = 0;//reset num
      }
    }
  }
  printf("clusters\n");
  printf("freq: %d cluster_num: %d\n\n",freq,res);
   
  
  for (int i=0;i<res;i++){
    printf("cluster%d size: %d\n",i,(int)clusterelm[i].size());
    printf("clusterelm coordinates\n"); 
    
    for (int j=0;j<(int)clusterelm[i].size();j++){
     printf("%lf %lf\n",clusterelm[i][j].x,clusterelm[i][j].y);
    }
    printf("\n");
  }
}




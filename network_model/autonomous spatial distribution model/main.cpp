#include "addNode/addNode.h"
#include "removeNode/removeNode.h"

#include "random/getrand.h"
//#include "removeNode.h"
////#include "dSFMT.h"
#include "node.h"
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

#define N 500000 
#define X 10000//2D boundary
#define Y 10000

#define MIN 1

using namespace std;

//m_in: number of inlink per node
//m_out: number of outlink per node


void func(int T, int m0, double beta, double gamma,double K, double C);

int main(int argc, char **argv){
 
  int m0 = 2 ; //initial node number

  int trial = atoi(argv[1])-m0; 
  double beta = atof(argv[2]);
  double gamma = atof(argv[3])*-1; //dist pref
  
  int seed = atoi(argv[4]);
  setseed(seed);

  double K,C;
  double ep = pow(2,0.5)*X;
  double sp = MIN;

  if(beta==2){
    K = 1/(1+log(ep)+log(sp)); 
    C = K/MIN;
  }
  else {
    K = (2-beta)/((1-beta)*pow(sp,2-beta)+pow(ep,2-beta));
    C = K*pow(MIN,1-beta);
  }

    func(trial, m0,beta,gamma,K,C);

}

void density(int center,vector<Node>& node, int T){
  int count = 0;
  int scale = 50;
  double dist;
  double density[(int) X/2];
  
  for(int r=scale; r<X/2; r+=scale){
    count = 0;
    for(int i=0;i<(int)node.size(); i++){
      dist=(double)pow(node[center].x-node[i].x,2)+(double)pow(node[center].y-node[i].y,2);
      if(pow(r-scale,2)<=dist && dist<pow(r,2)){count+=1;}
    }

    density[r/scale]=count/(scale*(2*r-scale)*M_PI);
    printf("donut-range: %d - %d count= %d density= %lf\n",r-scale,r,count,density[r/scale]);
  }
}

//fractal dimension from the center node.
void fractal_dim(int center, vector<Node>& node, int T){
    int count = 0;
  //int num[(int)X/2];
    int rate=10;

    vector<int> num((int)X/(2*rate));
    vector<double> dimension((int)X/(2*rate));
    double dist,r;

    for(int r=0;r<(int)X/2;r+=rate) {
        count=0;
        for(int i=0; i<(int)node.size(); i++) {
            dist = (node[center].x - node[i].x) * (node[center].x - node[i].x) +
                   (node[center].y - node[i].y) * (node[center].y - node[i].y);
            if (dist < pow(r, 2)) {
                count += 1;
            }
        }
      //numの添字0,1,2,3...
        num[(r/rate)] = count;
        printf("r= %d count= %d\n",r,count);
    }
}

//逆関数法によりrを出力
double geodist0(double sp, double ep, double beta, double K,double C){
  double R;
  double uni;

  uni = getRand(0,1);

  if(beta == 1){
      uni = getRand(0,1);
      R = X*pow(2,0.5)*uni;
  }

  else if(beta==2){
    if(uni<C*MIN){
      R = uni/C;
    }
    else{
      R = exp(uni/K-1+log(MIN));
    }
  }

  else{
    if(uni<C*MIN){
      R = uni/C;  
    }
    else{
      R = pow((2-beta)*uni/K-(1-beta)*pow(MIN,2-beta),1/(2-beta));
    }
  }

  return R;
}

bool hantei0(vector<Node>& node){
  
  double a = node[node.size()-1].x;
  double b = node[node.size()-1].y;

  //体積排除と領域外の場合は領域外のメッセージを採用する
  if(pow(a-X/2,2)+pow(b-Y/2,2)> pow(X/2,2)){return false;}
    else {return true;}
}

//反復処理

void func(int T, int m0, double beta, double gamma, double K, double C){

  vector<int> E(N);
  vector<Node> node;

  int ip, *i_pt; i_pt = &ip;
  
  int *sumin, *sumout;
  int sum_in, sum_out;
  sumin = &sum_in; sumout = &sum_out;

  int M;
  int *M_pt;
  M_pt = &M; *M_pt = 0;

  double theta,r,uni;

  //初期化
  //リングのグラフ。平面は
  
  Node newnode1={0,0,0,0,0,0};
  node.push_back(newnode1);
  node[0].num=0;
  node[0].kin=1;
  node[0].kout=1;
  
  E[0]=0;E[1]=1;

    node[0].x=X/2;
    node[0].y=Y/2;

/*
 for(int j=1;j<m0-1;j++){
  Node newnode={j,0,0,0,0,0};
  node.push_back(newnode);

  E[2*j]=j;
  E[2*j+1]=j+1;
  node[j].kout=1;
  node[j].kin=1;

  do{
    r = geodist0(MIN,pow(2,0.5)*X,beta,K,C);

    uni =getRand(0,1);
    theta = 2*M_PI *uni; 

    node[j].x = node[0].x+r*cos(theta);
    node[j].y= node[0].y+r*sin(theta);

  }while(!hantei0(node));
 }*/

  Node newnode={m0-1,0,0,0,0,0};
  node.push_back(newnode);

  E[2*m0-2]=m0-1;
  
  E[2*m0-1]=0;
  node[m0-1].kout=1;
  node[m0-1].kin=1;
  do{
    r = geodist0(MIN,pow(2,0.5)*X,beta,K,C);

    uni =getRand(0,1);
    theta = 2*M_PI *uni;

    node[m0-1].x = node[0].x+r*cos(theta);
    node[m0-1].y= node[0].y+r*sin(theta);

  }while(!hantei0(node));

  *M_pt = m0; //number of edges
  *sumin = m0; //total sumin
  *sumout = m0; //total sumout
  *i_pt = m0;

  for (int t=0; t<T; t++){

      /*
    #pragma omp parallel for
    for(int i=0;i<node.size();i++){
      node[i].age +=1;
    }*/
    
    Node newnode = {*i_pt,0,0,0,0,0};
    node.push_back(newnode);

    ////ADD NODE////
    addNode(node, E, M_pt, beta, gamma, K, C);
    *i_pt += 1;

  }
  
  //////ANALYSIS///

  printf("start_fractal\n");
  fractal_dim(0,node,T);
  printf("end_fractal\n");

  printf("start_density\n");
  density(0,node,T);
  printf("end_density\n");


  ////OUTPUT////

    //numとnode番号の対応付け
    //単純にに大きさで可能。map
    vector<double> geo_dist(2*(*M_pt));
    map<int,int> num2i;

    for(int i=0;i<(int)node.size();i++) {
        num2i[node[i].num] = i;
    }

    printf("\nstart_edge_points\n");
    for (int i=0; i<*M_pt;i++){
      geo_dist[i]=pow(pow(node[num2i[E[2*i]]].x-node[num2i[E[2*i+1]]].x,2)+pow(node[num2i[E[2*i]]].y-node[num2i[E[2*i+1]]].y,2),0.5);
      printf("%d %d %lf\n", E[2*i],E[2*i+1], geo_dist[i]);
   }
    printf("end_edge_points\n");
    

  printf("\nstart_coordinates\n");
    for (int s=0;s<(int)node.size();s++){
    printf("%d %lf %lf\n",s,node[s].x,node[s].y); //the coordinates of node s
   }
  printf("end_coordinates\n");

    //draw line between connected points
  printf("start_line\n");
  for(int i=0; i< *M_pt ; i++){
    printf("%lf %lf\n",node[E[2*i]].x, node[E[2*i]].y);
    printf("%lf %lf\n",node[E[2*i+1]].x, node[E[2*i+1]].y);
    printf("\n");
  }
  printf("end_line");

 /*
  printf("start_nodeage\n");
    for(int i=0;i<(int)node.size();i++){
      printf("%d\n",node[i].age);
    }
  printf("end_nodeage\n");*/


    double sum_i=0;
    double sum_o=0;

    double kmin=10;

    int count=0;
    double pow_exp_in, pow_exp_out;

    printf("start_kin_kout\n");
    for(int i=0;i<T;i++){
        printf("%d %d", node[i].kin, node[i].kout);
    }
    printf("end_kin_kout\n");



    for(int i=0;i<T;i++){
        if(node[i].kin>=kmin ){
            sum_i+=log(node[i].kin/(kmin-0.5));
            count+=1;
        }
    }
    pow_exp_in=1+count/sum_i;
    printf("pow_exp_in = %lf std= %lf count= %d\n", pow_exp_in, (pow_exp_in-1)/pow(count,0.5), count);

    count=0;
    for(int i=0;i<T;i++){
        if(node[i].kout>=kmin ){
            sum_o+=log(node[i].kout/(kmin-0.5));
            count+=1;
        }
    }
    pow_exp_out=1+count/sum_o;
    printf("pow_exp_out = %lf std= %lf count= %d \n ", pow_exp_out, (pow_exp_out-1)/pow(count,0.5),count);

    /*
    printf("start_kin");
    for(int i=0;i<T;i++){
        if(kincount[i]>0){
            printf("%d %d\n", i, kincount[i]);
        }
    }
    printf("end_kin freq\n");


    printf("start_kout\n");
    for(int i=0;i<T;i++){
        if(koutcount[i]>0){
            printf("%d %d\n", i,koutcount[i]);
        }
    }

    printf("end_kout freq\n");
     */

}

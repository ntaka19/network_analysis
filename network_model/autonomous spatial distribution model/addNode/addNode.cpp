#include "addNode.h"
#include"../random/getrand.h"

//#include "removeNode.h"
#include "../node.h"
#include"../random/getrand.h"

#include<math.h>
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
#include<omp.h>

#define X 10000//2D boundary
#define Y 10000

//体積排除の最少体積
#define MIN 1


using namespace std;

bool hantei(vector<Node>& node){

    double a = node[node.size()-1].x;
    double b = node[node.size()-1].y;
    //体積排除と領域外の場合は領域外のメッセージを採用する
    if(pow(a-X/2,2)+pow(b-Y/2,2)> pow(X/2,2)){return false;}
    else {return true;}
}


double geodist(double sp, double ep, double beta, double K,double C){
    double R;
    double uni;

    uni=getRand(0,1);

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

double geodist_exp(double rc, double ep){

}


void connectNode(vector<Node>& node,vector<int>& E, int *M_pt, double gamma,int type){
    double *node_dist;
    double uni,tmp,rand;
    double k_distsum=0;
    double dist;
    int ve,adj;

    node_dist= new double[(int)node.size()]();

    double a=node[(int)node.size()-1].x;
    double b=node[(int)node.size()-1].y;

    #pragma omp parallel for
    for(int i=0; i<(int)node.size()-1; i++){
       dist= pow(node[i].x-a,2)+pow(node[i].y-b,2);
       node_dist[i]=pow(dist,-gamma/2);
    }

    uni=getRand(0,1);

    if(type==0){
        for (int i=0;i<(int)node.size()-1; i++){
            k_distsum+=(double)node[i].kout*node_dist[i];

        }
        node[(int)node.size()-1].kin=0;

        tmp=0;
        rand=k_distsum*uni;
        for(int p=0; p<(int)node.size()-1;p++){
            tmp+=(double)node[p].kout*node_dist[p];
            if(tmp>rand){
                ve=node[p].num;
                adj=p;
                break;
            }
        }

        E[2*(*M_pt)]=ve;
        E[2*(*M_pt)+1]=((int)node.size()-1);

        node[adj].kout+=1;
        node[node.size()-1].kin+=1;
        *M_pt+=1;


    }
    else{
        for (int i=0;i<(int)node.size()-1; i++){
            k_distsum+=(double)node[i].kin*node_dist[i];

        }
        node[(int)node.size()-1].kout=0;

        tmp=0;
        rand=k_distsum*uni;
        for(int p=0; p<(int)node.size()-1;p++){
            tmp+=(double)node[p].kin*node_dist[p];
            if(tmp>rand){
                ve=node[p].num;
                adj=p;
                break;
            }
        }

        E[2*(*M_pt)]=((int)node.size()-1);
        E[2*(*M_pt)+1]=ve;

        node[adj].kin+=1;
        node[node.size()-1].kout+=1;
        *M_pt+=1;
    }

    delete node_dist;
}


void addNode(vector<Node>& node, vector<int>& E, int *M_pt, double beta, double gamma, double K, double C){

    double r;
    double uni;

    double sp = MIN;
    double ep = X*pow(2,0.5);
    double theta;

    int select;

    do {
        select=getIntRand(0,(int)node.size()-2);

        r = geodist(sp ,ep, beta, K, C);
        uni = getRand(0, 1);
        theta = 2 * M_PI * uni;
        node[node.size() - 1].x = node[select].x + r*cos(theta);
        node[node.size() - 1].y = node[select].y + r*sin(theta);
    }while(!hantei(node));

    double prob;
    prob=getRand(0,1);

    if(prob>0.5){
        connectNode(node, E, M_pt,gamma, 1);
        connectNode(node, E, M_pt,gamma, 0);
    }
    else{
        connectNode(node, E, M_pt,gamma, 0);
        connectNode(node, E, M_pt,gamma, 1);
    }

}

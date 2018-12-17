#include<iostream>
#include<algorithm>
#include<cstdlib>
#include<cstdio>
#include<vector>
#include<cstring>
#include<fstream>
#include<random>

#include"../random/getrand.h"
#include"../node.h"
#define N 500000

/*specification
 *
 * E contains node number in order such that:
 * E[2*i] links with E[2*i+1]
 *
 * deletion of node is basically deletion of the edges. 
 *
 * リンクが存在しないままノードののみが存在するケースがありうる。
*/

using namespace std;

void removeNode(vector<Node>& node,vector<int>& E, int *sumin, int *sumout, int *M_pt,int *i_pt){
  /*
  random_device rd;
  mt19937 mt(rd());
  uniform_int_distribution<int> ransu(0,node.size()-1);
 */

  vector<int> mark(N);
 
  int delpos = getIntRand(0,node.size()-1);
  
  int delNum = node[delpos].num;
  printf("remove node %d val%d\n",delpos,delNum);
  int j=0;

  //delete するnodeの番号の添字を保存//
  for (int i=0;i<2*(*M_pt);i++){  
    if(E[i]==delNum) {
      
      mark[j]=i;
      
      j+=1;
      if(i%2==0){
	mark[j]=i+1;	
	
	for(int j=0;j<node.size();j++){
	  if (node[j].num==E[i+1]){node[j].kin-=1;break;}
	}
      }
      else{
	mark[j]=i-1;
	for(int j=0;j<node.size();j++){
	  if (node[j].num==E[i-1]){node[j].kout-=1;break;}
	}
      }
      j+=1;
    }
  } 

  mark.resize(j);
  sort(mark.rbegin(),mark.rend());
  

   for(int i=0;i<(int)mark.size();i++){
    E.erase(E.begin()+mark[i]);

  }
  *sumin-= (node[delpos].kin+node[delpos].kout);
  *sumout-= (node[delpos].kin+node[delpos].kout);
  
  //printf("marked %d (edge %d)\n",(int)mark.size(), (int)mark.size()/2);
  *M_pt -= (int)(mark.size())/2; //edgeを一つ消す
 
  //nodeの削除 
  //printf("delete coff %d,node %d, nodekin %d, nodekout%d\n",delpos,node[delpos].num,node[delpos].kin,node[delpos].kout);

 /*BEFORE
  *  
 printf("before\n"); 
  for (int i=0; i<node.size();i++){
    printf("%d ",node[i].num);
  } printf("\n");
*/
 node.erase(node.begin() + delpos);

 /*AFTER
 printf("after\n"); 
  for (int i=0; i<node.size();i++){
    printf("%d ",node[i].num);
  } printf("\n");
  
  printf("existing nodes %d\n",(int)node.size());
*/
  }

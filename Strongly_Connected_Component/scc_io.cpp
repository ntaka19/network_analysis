#include<iostream>
#include<cstdlib>
#include<cstdio>
#include<vector>
#include<cstring>
#include<fstream>

#define MAX_V 10000 

using namespace std;
int V;

vector<int> G[MAX_V]; //グラフの隣接リストを表現
vector<int> rG[MAX_V]; //辺の向きを逆にしたグラフ
vector<int> vs; //帰りがけ順の並び. backtrackするごとに入れる。
bool used[MAX_V]; //すでに調べたか
int cmp[MAX_V]; //属する強連結成分のトポロジカル順序

void add_edge(int from,int to);
void rdfs(int v, int k);
int scc();

int main(){
  
  //cout << "ifstream" << endl;
  //ifstream ifs("edgelist0.dat");
  ifstream ifs("data.txt");
  string str;

  if(ifs.fail()){
    cerr<<"File do not exist\n";
    exit(0);
  }

  int a,b; //max is the largest node number
  int max = 0;
  while(getline(ifs,str)){
    sscanf(str.data(), "%d %d", &a, &b);
    add_edge(a,b);
    
    if(a>b && a>max){
      max = a;
    }else if(b>=a && b>max){
     max = b;
    }

    cout << a << " " << b << endl;
  }

  V = max+1;
  printf("largest node number = %d\n",max);
  printf("scc = %d\n",scc());  
}

//辺の向きを順方向と逆方向で入れる。
void add_edge(int from,int to){
  G[from].push_back(to);
  rG[to].push_back(from);
}

void dfs(int v){
  used[v] = true;
  for(int i = 0;i < G[v].size(); i++){
    if(!used[G[v][i]]) dfs(G[v][i]);

  }
  vs.push_back(v);
}

void rdfs(int v, int k){
  used[v] = true;
  cmp[v] = k;
  for(int i=0;i<rG[v].size(); i++){
    if(!used[rG[v][i]]) rdfs(rG[v][i],k);
  }
}

int scc(){
  memset(used,0,sizeof(used));
  vs.clear();
  for(int v=0;v<V;v++){
    if(!used[v]) dfs(v);
  } 
  memset(used,0,sizeof(used));
  int k = 0;

  int j;
  for(int i=vs.size()-1; i >= 0; i--){
    if(!used[vs[i]]) rdfs(vs[i],k++);
  }
  return k; //number of scc's
  //to print specific scc. specify topological order.  
}

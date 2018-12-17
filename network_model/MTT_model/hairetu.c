#include <stdio.h>
#include <stdlib.h> 

void waru2(int *p);

int main(void){
  int i;
  int dt[]={20,10,4,35,66,-1};
  waru2(dt); //配列の先頭要素のアドレスを渡す

  for(i=0;dt[i]!=-1;i++){
    printf("%d ",dt[i]);
  }
  printf("\n");
  return 0;
}

void waru2(int *p) //配列dtのアドレスをポインタに入れる。
{
  while(*p!=-1){
    *p = *p/2; //ポインタの中身を2で割る。間接演算子
    ++p;
  }
}

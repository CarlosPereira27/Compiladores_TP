#ifndef _TABELA_DE_SIMBOLOS_
#define _TABELA_DE_SIMBOLOS_

#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>

#define SIZE_SIMBOL 200
#define SIZE_TABLE 4000

enum CATEGORIA{ VAR, FUNC };

typedef struct {
  char cadeia[SIZE_SIMBOL];
  int token;
  int categoria;
  char tipo[SIZE_SIMBOL];
  char valor[SIZE_SIMBOL];
  int escopo;
} Item;

typedef struct {
  Item *array;
  size_t used;
  size_t size;
} Array;

typedef struct No {
  Array array;
  struct No *prox;  
} Pilha;


void initArray(Array*, size_t);
int insertArray(Array*, Item);
void freeArray(Array*);
void insertArrayItem(Array*, Item);
Item* buscaArray(Array*, char*);
int removeArray(Array*, char*);
void printArray(Array*);
Item getItem(char*, int, int,char*, char*, int);


#endif /*_TABELA_DE_SIMBOLOS_*/

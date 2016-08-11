#ifndef _TABELA_DE_SIMBOLOS_
#define _TABELA_DE_SIMBOLOS_

#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>

#define SIZE_SIMBOL 200
#define SIZE_TABLE 4000

enum CATEGORIA{ VAR, ARRAY, FUNC, PARAM, PARAM_ARRAY };

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


void initArray(Array*, size_t);
void freeArray(Array*);
int insertArray(Array*, Item);
Item* buscaArray(Array*, char*);
Item* buscaArrayByPosition(Array*, int);
Item* buscaArrayYacc(Array *a, int posicao, int escopo);
Item* buscaArrayByCadeiaEEscopo(Array *a, char* cadeia, int escopo);
int removeArray(Array*, char*);
void printArray(Array*);
Item getItem(char*, int, int,char*, char*, int);
Item getItemLex(char* cadeia, int token);
int equalsItem(Item* item1, Item* item2);
int getIndiceArray(Array *a, Item* item);


#endif /*_TABELA_DE_SIMBOLOS_*/

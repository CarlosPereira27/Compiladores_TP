#ifndef TABELA_DE_SIMBOLOS
#define TABELA_DE_SIMBOLOS

#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>
//#include "../y.tab.h"

#define SIZE_SIMBOL 200
#define SIZE_TABLE 4000

/*enum TOKEN{ INT, FLOAT, CHAR, STRUCT, VOID, IF, ELSE, ATRIBUICAO, WHILE, RETURN, IDENT, ABRE_CHAVE, 
			FECHA_CHAVE, ABRE_COLCHETE, FECHA_COLCHETE, ABRE_PARENTESES, FECHA_PARENTESES, PONTO_VIRGULA, 
			VIRGULA, NUM_INT, NUM, RELOP, LT, LE, EQ, NE, GT, GE, SOMA, SUBTRACAO, MULT, DIV };*/	

enum CATEGORIA{ VAR, FUNC };

char tabelaSimbolos[SIZE_TABLE][SIZE_SIMBOL];

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



//char tabelaSimbolosIdent[SIZE_TABLE][SIZE_SIMBOL];
//int tabelaSimbolosNum_int[SIZE_TABLE];
//float tabelaSimbolosNum[SIZE_TABLE];
//int tabelaSimbolosNumQtdCaracteres[SIZE_TABLE];
//int yylval;


//int colCount = 1;
//int lineCount = 1;
//
//int simbolosCount = 0;
//int simbolosIdentCount = 0;
//int simbolosNum_intCount = 0;
//int simbolosNumCount = 0;

//void atualizarLineEColCount(char*);
//int installIdent(char*);
//int installNum_int(int);
//int installNum(float, int);
//int tamanhoToken(int token);
//int getLineCount();
//int getColCount();


#endif /*TABELA_DE_SIMBOLOS*/

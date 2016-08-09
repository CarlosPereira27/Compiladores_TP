#ifndef TABELA_DE_SIMBOLOS
#define TABELA_DE_SIMBOLOS

#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>
#include "../y.tab.h"

#define SIZE_SIMBOL 200
#define SIZE_TABLE 4000

/*enum TOKEN{ INT, FLOAT, CHAR, STRUCT, VOID, IF, ELSE, ATRIBUICAO, WHILE, RETURN, IDENT, ABRE_CHAVE, 
			FECHA_CHAVE, ABRE_COLCHETE, FECHA_COLCHETE, ABRE_PARENTESES, FECHA_PARENTESES, PONTO_VIRGULA, 
			VIRGULA, NUM_INT, NUM, RELOP, LT, LE, EQ, NE, GT, GE, SOMA, SUBTRACAO, MULT, DIV };*/	


char tabelaSimbolos[SIZE_TABLE][SIZE_SIMBOL];

//char tabelaSimbolosIdent[SIZE_TABLE][SIZE_SIMBOL];
//int tabelaSimbolosNum_int[SIZE_TABLE];
//float tabelaSimbolosNum[SIZE_TABLE];
//int tabelaSimbolosNumQtdCaracteres[SIZE_TABLE];
//int yylval;


int colCount = 1;
int lineCount = 1;

int simbolosCount = 0;
//int simbolosIdentCount = 0;
//int simbolosNum_intCount = 0;
//int simbolosNumCount = 0;

void atualizarLineEColCount(char*);
//int installIdent(char*);
//int installNum_int(int);
//int installNum(float, int);
//int tamanhoToken(int token);
//int getLineCount();
//int getColCount();


#endif /*TABELA_DE_SIMBOLOS*/

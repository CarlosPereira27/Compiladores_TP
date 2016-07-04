%{
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>
//#include "tabelaDeSimbolos/TabelaDeSimbolos.h"
#include "strings/erros_sintaticos.h"

int yylex(void);
void yyerror(char *);
%}

%token INT FLOAT CHAR STRUCT VOID IF ELSE ATRIBUICAO WHILE RETURN IDENT ABRE_CHAVE FECHA_CHAVE ABRE_COLCHETE FECHA_COLCHETE ABRE_PARENTESES FECHA_PARENTESES PONTO_VIRGULA VIRGULA NUM_INT NUM RELOP LT LE EQ NE GT GE SOMA SUBTRACAO MULT DIV

%nonassoc THEN
%nonassoc ELSE

%%

programa:
	declaracao_lista { printf("é um programa\n"); }
	;

declaracao_lista:
	declaracao declaracao_seq
	| declaracao	{ printf("declaracao_lista\n"); }
	;

declaracao_seq:
	declaracao
	| declaracao_seq declaracao
	;

declaracao:
	var_declaracao	{ printf("declaracao\n"); }
	| fun_declaracao
	;

var_declaracao:
	tipo_especificador IDENT PONTO_VIRGULA	{ printf("var_declaracao\n"); }
	| tipo_especificador IDENT ABRE_COLCHETE NUM_INT FECHA_COLCHETE var_dimensao PONTO_VIRGULA
	| tipo_especificador IDENT ABRE_COLCHETE NUM_INT FECHA_COLCHETE PONTO_VIRGULA
	;

var_dimensao:
	ABRE_COLCHETE NUM_INT FECHA_COLCHETE
	| var_dimensao ABRE_COLCHETE NUM_INT FECHA_COLCHETE
	;

tipo_especificador:
	INT	{ printf("tipo_especificador\n"); }
	| FLOAT
	| CHAR
	| VOID
	| STRUCT IDENT ABRE_CHAVE atributos_declaracao FECHA_CHAVE
	;

atributos_declaracao:
	var_declaracao
	| var_declaracao var_declaracao_seq
	;

var_declaracao_seq:
	var_declaracao
	| var_declaracao_seq var_declaracao
	;

fun_declaracao:
	tipo_especificador IDENT ABRE_PARENTESES params FECHA_PARENTESES composto_decl
	;

params:
	param_lista | VOID
	;

param_lista:
	param
	| param param_seq
	;

param_seq:
	VIRGULA param
	| param_seq VIRGULA param
	;

param:
	tipo_especificador IDENT
	| tipo_especificador IDENT ABRE_COLCHETE FECHA_COLCHETE
	;

composto_decl:
	ABRE_CHAVE local_declaracoes comando_lista FECHA_CHAVE
	| ABRE_CHAVE comando_lista FECHA_CHAVE
	| ABRE_CHAVE local_declaracoes FECHA_CHAVE
	| ABRE_CHAVE FECHA_CHAVE
	;

local_declaracoes:
	var_declaracao
	| local_declaracoes var_declaracao
	;

comando_lista:
	comando
	| comando_lista comando
	;

comando:
	expressao_decl
	| composto_decl
	| selecao_decl
	| iteracao_decl
	| retorno_decl
	;

expressao_decl:
	expressao PONTO_VIRGULA
	| PONTO_VIRGULA
	;

selecao_decl:
	IF ABRE_PARENTESES expressao FECHA_PARENTESES comando			%prec THEN
	| IF ABRE_PARENTESES expressao FECHA_PARENTESES comando ELSE comando
	;
	
iteracao_decl:
	WHILE ABRE_PARENTESES expressao FECHA_PARENTESES comando
	;

retorno_decl:
	RETURN PONTO_VIRGULA
	| RETURN expressao PONTO_VIRGULA
	;

expressao:
	var ATRIBUICAO expressao
	| expressao_simples
	;

var:
	IDENT
	| IDENT ABRE_COLCHETE expressao FECHA_COLCHETE
	| IDENT ABRE_COLCHETE expressao FECHA_COLCHETE var_seq
	;

var_seq:
	ABRE_COLCHETE expressao FECHA_COLCHETE
	| var_seq ABRE_COLCHETE expressao FECHA_COLCHETE
	;

expressao_simples:
	expressao_soma RELOP expressao_soma
	| expressao_soma
	;

expressao_soma:
	termo
	| termo expressao_soma_seq
	;

soma:
	SOMA
	| SUBTRACAO
	;

expressao_soma_seq:
	soma termo
	| expressao_soma_seq soma termo
	;

termo:
	fator 
	| fator termo_seq
	;

termo_seq:
	mult fator
	| termo_seq mult fator
	;

mult:
	MULT
	| DIV
	;

fator:
	ABRE_PARENTESES expressao FECHA_PARENTESES
	| var
	| ativacao
	| NUM
	| NUM_INT
	;

ativacao:
	IDENT ABRE_PARENTESES arg_lista FECHA_PARENTESES
	| IDENT ABRE_PARENTESES FECHA_PARENTESES
	;

arg_lista:
	expressao
	| expressao expressao_seq
	;

expressao_seq:
	VIRGULA expressao
	| expressao_seq VIRGULA expressao
	;

%%

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
 	yyparse();
	return 0;
}


	
	

%{
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>
#include "tabelaDeSimbolos/TabelaDeSimbolos.h"
#include "strings/erros_sintaticos.h"

Array a;

int yylex(void);
void yyerror(char *);
int escopo = 0;
extern int colCount;
extern int lineCount;
Item* buscaEscopoDescendente(int posicao);
void declaracaoAnaliseSemantica(int tipo, int var, int categoria);
int getIndexType(int position);
void elementoAnaliseSemantica(int var, int categoria);

%}

%token INT FLOAT CHAR STRUCT VOID IF ELSE ATRIBUICAO WHILE RETURN IDENT ABRE_CHAVE FECHA_CHAVE 
       ABRE_COLCHETE FECHA_COLCHETE ABRE_PARENTESES FECHA_PARENTESES PONTO_VIRGULA VIRGULA 
       NUM_INT NUM RELOP LT LE EQ NE GT GE SOMA SUBTRACAO MULT DIV

%nonassoc THEN
%nonassoc ELSE

%start programa

%%

programa:
	declaracao_lista
	;

declaracao_lista:
	declaracao declaracao_seq {printf("Decalaracao lista\n");}
	| declaracao {printf("Decalaracao simples\n");}
	;

declaracao_seq:
	declaracao
	| declaracao_seq declaracao
	;

declaracao:
	var_declaracao {printf("var declaracao\n");}
	| fun_declaracao {printf("fun declaracao\n");}
	;

var_declaracao:
	tipo_especificador IDENT PONTO_VIRGULA 
        { declaracaoAnaliseSemantica($1, $2, VAR);
       // printf("tipo ident ;%d\n",$1);
}
	| tipo_especificador IDENT ABRE_COLCHETE NUM_INT FECHA_COLCHETE 
            var_dimensao PONTO_VIRGULA
        { declaracaoAnaliseSemantica($1, $2, ARRAY);
            //printf("tipo ident ;%d\n",$1);
}

	| tipo_especificador IDENT ABRE_COLCHETE NUM_INT FECHA_COLCHETE 
            PONTO_VIRGULA
        { declaracaoAnaliseSemantica($1, $2, ARRAY);
            //printf("tipo ident ;%d\n",$1);
}


/*
//Erros var_declaracao
	| error IDENT 
	{yyerrok, yyclearin, printf("Tipo especificador não é reconhecido :%s, %d, %d\n",
	 getValorLexicoDoToken($1), getLineCount() , 	getColCount()-getTamanhoLexicoDoToken($1));}

	| error PONTO_VIRGULA {yyerrok, yyclearin, printf("Contrução invalida tipo especificador ou identificador não é reconhecido  : %s, %d, %d\n", getValorLexicoDoToken($1), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
	| error FECHA_COLCHETE {yyerrok, yyclearin, printf("Esperado uma declaracao antes de fechar o colchete  : %s, %d, %d\n", getValorLexicoDoToken($1), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
//	| error ';'{yyerrok, yyclearin,printf("tipo especificador não é reconhecido");}
	;
*/
	;

var_dimensao:
	ABRE_COLCHETE NUM_INT FECHA_COLCHETE
	| var_dimensao ABRE_COLCHETE NUM_INT FECHA_COLCHETE
	;

tipo_especificador:
	INT {$$ = $1;}
	| FLOAT {$$ = $1;}
	| CHAR	{$$ = $1;}
	| VOID	{$$ = $1;}
	| STRUCT IDENT ABRE_CHAVE atributos_declaracao FECHA_CHAVE {$$ = $2;}

/*
	| STRUCT error ABRE_CHAVE {yyerrok, yyclearin, printf("erro esperado um ident antes de abrir chaves : %s, %d, %d\n", getValorLexicoDoToken($2), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
	| error atributos_declaracao{yyerrok, yyclearin, printf("erro esperado um abre chaves antes dos atributos de declaracao : %s, %d, %d\n", getValorLexicoDoToken($1), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
	| error FECHA_CHAVE {yyerrok, yyclearin, printf("erro esperado uma declaracao antes de fechar chaves : %s, %d, %d\n", getValorLexicoDoToken($1), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
*/
	
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
	{ declaracaoAnaliseSemantica($1, $2, FUNC); }

/*
	| error ABRE_PARENTESES {yyerrok, yyclearin, printf("erro esperado um tipo especificador ou identificador antes de abrir parenteses : %s, %d, %d\n", getValorLexicoDoToken($1), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
	| error FECHA_PARENTESES {yyerrok, yyclearin, printf("erro esperado parametros de fechar parenteses : %s, %d, %d\n", getValorLexicoDoToken($1), getLineCount() , getColCount()-getTamanhoLexicoDoToken($1));}
*/
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
	{ declaracaoAnaliseSemantica($1, $2, PARAM); }
	| tipo_especificador IDENT ABRE_COLCHETE FECHA_COLCHETE
	{ declaracaoAnaliseSemantica($1, $2, PARAM_ARRAY); }
	;

composto_decl:
	ABRE_CHAVE abreEscopo local_declaracoes comando_lista fechaEscopo FECHA_CHAVE
	| ABRE_CHAVE abreEscopo comando_lista fechaEscopo FECHA_CHAVE
	| ABRE_CHAVE abreEscopo local_declaracoes fechaEscopo FECHA_CHAVE
	| ABRE_CHAVE abreEscopo fechaEscopo FECHA_CHAVE
	;

abreEscopo:
    {
        escopo++;
    }
;

fechaEscopo:
    {
	removeArrayEscopo(&a, escopo);
        escopo--;
    }
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
	expressao PONTO_VIRGULA {printf("atribuiu\n");}
	| PONTO_VIRGULA
	;

selecao_decl:
	IF ABRE_PARENTESES expressao FECHA_PARENTESES comando			
                %prec THEN
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
	var ATRIBUICAO expressao {printf("atribuiu\n");}
	| expressao_simples
	;

var:
	IDENT 
        { $$ = $1;
          elementoAnaliseSemantica($1, VAR); 
         //printf("Ident\n");
}
	| IDENT ABRE_COLCHETE expressao FECHA_COLCHETE
        {  $$ = $1;
            elementoAnaliseSemantica($1, ARRAY); } 
	| IDENT ABRE_COLCHETE expressao FECHA_COLCHETE var_seq
        {  $$ = $1;
            elementoAnaliseSemantica($1, ARRAY); }
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
        { $$ = $2; }
	| var
        { $$ = $1; }
	| ativacao
        { $$ = $1; }
	| NUM 
        { $$ = $1; }
	| NUM_INT
        { $$ = $1; }
	;

ativacao:
	IDENT ABRE_PARENTESES arg_lista FECHA_PARENTESES
        { elementoAnaliseSemantica($1, FUNC); 
}
	| IDENT ABRE_PARENTESES FECHA_PARENTESES
        { elementoAnaliseSemantica($1, FUNC); 
 }
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

void declaracaoAnaliseSemantica(int tipo, int posicao, int categoria) {
    Item* item;
    if(categoria == PARAM || categoria == PARAM_ARRAY) {
          item = buscaArrayYacc(&a, posicao, escopo+1);
    } else {
	item = buscaArrayYacc(&a, posicao, escopo);
    }
    if(item == NULL) {
        item = buscaArrayYacc(&a, posicao, -1);
        Item novoItem;
        copyItem(&novoItem, item);
        strcpy(novoItem.tipo, buscaArrayYacc(&a, tipo, -1)->cadeia);
	novoItem.escopo = escopo;
	if(categoria == PARAM || categoria == PARAM_ARRAY) {
        	novoItem.escopo++;
	} 
	novoItem.categoria = categoria;
	if(categoria == PARAM) {
        	novoItem.categoria = VAR;
	} else if(categoria == PARAM_ARRAY) {
		novoItem.categoria = ARRAY;
	}
        insertArray(&a, novoItem);
    } else {
	if(categoria == FUNC) {
        	printf("Erro! L:%dC:%d.\n Função/procedimento %s já está definida neste contexto!\n\n", 
           	 lineCount, colCount, item->cadeia);
	} else {
        	printf("Erro! L:%dC:%d.\n Variável %s já está definida neste contexto!\n\n", 
           	 lineCount, colCount, item->cadeia);
	}
    }
}

void elementoAnaliseSemantica(int posicao, int categoria) {
    Item* item = buscaEscopoDescendente(posicao);
    if(item == NULL) {
	item = buscaArrayByPosition(&a, posicao);
	if(categoria == FUNC) {
		printf("Erro! L:%dC:%d.\n Função/procedimento %s não está definida neste contexto!\n\n", 
		    lineCount, colCount, item->cadeia);
	} else {
		printf("Erro! L:%dC:%d.\n Variável %s não está definida neste contexto!\n\n", 
		    lineCount, colCount, item->cadeia);
	}
    } else if (item->categoria != categoria && categoria == ARRAY) {
        printf("Erro! L:%dC:%d.\n Variável %s não é multidimensional!\n\n", 
            lineCount, colCount, item->cadeia);
    }
}

Item* buscaEscopoDescendente(int posicao) {
    Item* item = buscaArrayByPosition(&a, posicao);
    int i;
    for(i = escopo; i > -1; i--) { 
        Item* itemAux = buscaArrayByCadeiaEEscopo(&a, item->cadeia, i);
        if(itemAux != NULL) {
            item = itemAux;
            break;
        }
    }
    if(item->escopo == -1) {
	return NULL;
    }
    return item;
}

int getIndexType(int posicao) {
    Item* item = buscaEscopoDescendente(posicao);
    if(item == NULL) {
	item = buscaArrayByPosition(&a, posicao); 
	if(item->categoria == FUNC) {
	        printf("Erro! L:%dC:%d.\n Função/procedimento %s não está definida neste contexto!\n\n", 
        	    lineCount, colCount, item->cadeia);
	} else {
        	printf("Erro! L:%dC:%d.\n Variável %s não está definida neste contexto!\n\n", 
        	    lineCount, colCount, item->cadeia);
	}
        return 4;
    } else {
	//printArray(&a);
        Item *i = buscaArray(&a, item->tipo);
        return getIndiceArray(&a, i);
    }
}

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
        initArray(&a, 50);
        installPalavrasReservadas();
 	yyparse();
	return 0;
}


	
	

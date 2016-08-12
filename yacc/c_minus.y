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
const char* t = "_t";
unsigned long contT = 0;

extern FILE * yyin;
extern FILE * yyout;

extern int colCount;
extern int lineCount;
Item* buscaEscopoDescendente(int posicao);
void declaracaoAnaliseSemantica(int tipo, int var, int categoria);
int getIndexType(int position);
void elementoAnaliseSemantica(int var, int categoria);
char* getTemp();
char* getOp(int num);
char* getOpTermo(int num, int position);
void verificacaoDeTipoAtribuicao(int posicao1, int posicao2);
void verificacaoDeTipoOperacao(int posicao1, int posicao2);
char* getTipoOperacao(int posicao1, int posicao2);



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
	declaracao declaracao_seq
	| declaracao
	;

declaracao_seq:
	declaracao
	{
		fflush(yyout);
		//printArray(&a);
	}
	| declaracao_seq declaracao
	{
		fflush(yyout);
		//printArray(&a);
	}
	;

declaracao:
	var_declaracao
	| fun_declaracao
	;

var_declaracao:
	tipo_especificador IDENT PONTO_VIRGULA 
    { 
    	declaracaoAnaliseSemantica($1, $2, VAR);
	}
	| tipo_especificador IDENT ABRE_COLCHETE NUM_INT FECHA_COLCHETE 
            var_dimensao PONTO_VIRGULA
    { 
    	declaracaoAnaliseSemantica($1, $2, ARRAY);
	}

	| tipo_especificador IDENT ABRE_COLCHETE NUM_INT FECHA_COLCHETE 
            PONTO_VIRGULA
    { 
    	declaracaoAnaliseSemantica($1, $2, ARRAY);
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
	INT 
	{
		$$ = $1;
	}
	| FLOAT 
	{
		$$ = $1;
	}
	| CHAR	
	{
		$$ = $1;
	}
	| VOID	
	{
		$$ = $1;
	}
	| STRUCT IDENT ABRE_CHAVE atributos_declaracao FECHA_CHAVE 
	{
		$$ = $2;
	}

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
	{ 
		declaracaoAnaliseSemantica($1, $2, FUNC); 
	}

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
	{ 
		declaracaoAnaliseSemantica($1, $2, PARAM); 
	}
	| tipo_especificador IDENT ABRE_COLCHETE FECHA_COLCHETE
	{ 
		declaracaoAnaliseSemantica($1, $2, PARAM_ARRAY); 
	}
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
	expressao PONTO_VIRGULA 
	{}
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
	{
		fprintf(yyout, "return\n");
	}
	| RETURN expressao PONTO_VIRGULA
	{
		fprintf(yyout, "return %s\n", buscaArrayByPosition(&a, $2)->cadeia);
	}
	;

expressao:
	var ATRIBUICAO expressao 
	{
		fprintf(yyout, "%s = %s\n", buscaArrayByPosition(&a, $1)->cadeia, 
			buscaArrayByPosition(&a, $3)->cadeia);
		verificacaoDeTipoAtribuicao($1, $3);
		$$ = $1;
	}
	| expressao_simples
	{
		$$ = $1;
	}
	;

var:
	IDENT 
    { $$ = $1;
        elementoAnaliseSemantica($1, VAR); 
	}
	| IDENT ABRE_COLCHETE expressao FECHA_COLCHETE
    {  $$ = $1;
        elementoAnaliseSemantica($1, ARRAY); 
    } 
	| IDENT ABRE_COLCHETE expressao FECHA_COLCHETE var_seq
    {  
    	$$ = $1;
        elementoAnaliseSemantica($1, ARRAY); 
    }
	;

var_seq:
	ABRE_COLCHETE expressao FECHA_COLCHETE
	| var_seq ABRE_COLCHETE expressao FECHA_COLCHETE
	;

expressao_simples:
	expressao_soma RELOP expressao_soma
	{
		char* temp = getTemp();
		fprintf(yyout, "%s%s = %s %s %s\n", t, temp, 
			buscaArrayByPosition(&a, $1)->cadeia, buscaArrayByPosition(&a, $2)->cadeia
			, buscaArrayByPosition(&a, $3)->cadeia);
		char strCadeia[200];
		strcpy(strCadeia, t);
		strcat(strCadeia, temp);
		verificacaoDeTipoOperacao($1, $3);
		$$ = insertArray(&a, getItemEscopo(strCadeia, escopo, getTipoOperacao($1, $3)));
	}
	| expressao_soma
	{
		$$ = $1;
	}
	;

expressao_soma:
	termo
	{
		$$ = $1; 
	}
	| termo expressao_soma_seq
	{
		char* temp = getTemp();
		fprintf(yyout, "%s%s = %s%s\n", t, temp, 
			buscaArrayByPosition(&a, $1)->cadeia, buscaArrayByPosition(&a, $2)->cadeia);
		char strCadeia[200];
		strcpy(strCadeia, t);
		strcat(strCadeia, temp);
		verificacaoDeTipoOperacao($1, $2);
		$$ = insertArray(&a, getItemEscopo(strCadeia, escopo, getTipoOperacao($1, $2)));
	}
	;

soma:
	SOMA 
	{ $$ = $1; }
	| SUBTRACAO
	{ $$ = $1; }
	;

expressao_soma_seq:
	soma termo 
	{
		$$ = insertArray(&a, getItemEscopo(getOpTermo($1, $2), escopo, 
			buscaArrayByPosition(&a, $1)->tipo));
	}
	| expressao_soma_seq soma termo 
	{
		int i;
		char* temp = getTemp();
		char* str = buscaArrayByPosition(&a, $1)->cadeia;
		fprintf(yyout, "%s%s = ", t, temp);
		for(i = 1; i < strlen(str); i++) {
			fprintf(yyout, "%c", str[i]);
		}
		fprintf(yyout, "%s\n", getOpTermo($2, $3));
		char strCadeia[200];
		strCadeia[0] = str[0];
		strCadeia[1] = '\0';
		strcat(strCadeia, t);
		strcat(strCadeia, temp);
		verificacaoDeTipoOperacao($1, $3);
		$$ = insertArray(&a, getItemEscopo(strCadeia, escopo, getTipoOperacao($1, $3)));
	}
	;

termo:
	fator 
	{
		$$ = $1; 
	}
	| fator termo_seq
	{
		char* temp = getTemp();
		fprintf(yyout, "%s%s = %s%s\n", t, temp, 
			buscaArrayByPosition(&a, $1)->cadeia, buscaArrayByPosition(&a, $2)->cadeia);
		char strCadeia[200];
		strcpy(strCadeia, t);
		strcat(strCadeia, temp);
		verificacaoDeTipoOperacao($1, $2);
		$$ = insertArray(&a, getItemEscopo(strCadeia, escopo, getTipoOperacao($1, $2)));
	}
	;

termo_seq:
	mult fator 
	{

		$$ = insertArray(&a, getItemEscopo(getOpTermo($1, $2), escopo, 
			buscaArrayByPosition(&a, $1)->tipo)); 
	}
	| termo_seq mult fator 
	{ 	
		int i;
		char* temp = getTemp();
		char* str = buscaArrayByPosition(&a, $1)->cadeia;
		fprintf(yyout, "%s%s = ", t, temp);
		for(i = 1; i < strlen(str); i++) {
			fprintf(yyout, "%c", str[i]);
		}
		fprintf(yyout, "%s\n", getOpTermo($2, $3));
		char strCadeia[200];
		strCadeia[0] = str[0];
		strCadeia[1] = '\0';
		strcat(strCadeia, t);
		strcat(strCadeia, temp);
		verificacaoDeTipoOperacao($1, $3);
		$$ = insertArray(&a, getItemEscopo(strCadeia, escopo, getTipoOperacao($1, $3)));
	}
	;

mult:
	MULT 
	{ $$ = $1; }
	| DIV 
	{ $$ = $1; }
	;

fator:
	ABRE_PARENTESES expressao FECHA_PARENTESES
    { 
    	$$ = $2; 
    }
	| var
    { 
    	$$ = $1;
	}
	| ativacao
    { 
    	$$ = $1; 
    }
	| NUM 
    { 
    	$$ = $1; 
    }
	| NUM_INT
    { 
    	$$ = $1;
	}
	;

ativacao:
	IDENT ABRE_PARENTESES arg_lista FECHA_PARENTESES
	{ 
		$$ = $1; 
     	elementoAnaliseSemantica($1, FUNC); 
    }
	| IDENT ABRE_PARENTESES FECHA_PARENTESES
    { 
    	$$ = $1;
       	elementoAnaliseSemantica($1, FUNC); 
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

char* getTipoOperacao(int posicao1, int posicao2) {
	// Item* item1 = buscaArrayByPosition(&a, posicao1);
	// // item1 = buscaArrayByCadeiaEEscopo(&a, item1->cadeia, escopo);
	// Item* item2 = buscaArrayByPosition(&a, posicao2);
	// // item2 = buscaArrayByCadeiaEEscopo(&a, item2->cadeia, escopo);
	// if(strcmp(item1->tipo, "float") == 0 || 
	// 	strcmp(item2->tipo, "float") == 0) {
	// 	return "float";
	// }
	// if(strcmp(item1->tipo, "int") == 0 || 
	// 	strcmp(item2->tipo, "int") == 0) {
	// 	return "int";
	// }
	// if(strcmp(item1->tipo, "char") == 0 || 
	// 	strcmp(item2->tipo, "char") == 0) {
	// 	return "char";
	// }
	return "void";
}

void verificacaoDeTipoAtribuicao(int posicao1, int posicao2) {
	// Item* item1 = buscaArrayByPosition(&a, posicao1);
	// // item1 = buscaArrayByCadeiaEEscopo(&a, item1->cadeia, escopo);
	// Item* item2 = buscaArrayByPosition(&a, posicao2);
	// // item2 = buscaArrayByCadeiaEEscopo(&a, item2->cadeia, escopo);
	// if(strcmp(item1->tipo, item2->tipo) != 0) {
	// 	if(strcmp(item1->tipo, "char") == 0 || 
	// 		strcmp(item1->tipo, "float") == 0 || 
	// 		strcmp(item1->tipo, "int") == 0) {
	// 	} else {
	// 		printf("Erro: Os tipos das variáveis: %s, %s são imcompatíveis (%s, %s)!\n", 
	// 			item1->cadeia, item2->cadeia, item1->tipo, item2->tipo);
	// 		return;
	// 	}
	// 	if(strcmp(item2->tipo, "char") == 0 || 
	// 		strcmp(item2->tipo, "float") == 0 || 
	// 		strcmp(item2->tipo, "int") == 0) {
	// 	} else {
	// 		printf("Erro: Os tipos das variáveis: %s, %s são imcompatíveis (%s, %s)!\n", 
	// 			item1->cadeia, item2->cadeia, item1->tipo, item2->tipo);
	// 	}
	// }
}

void verificacaoDeTipoOperacao(int posicao1, int posicao2) {
	// Item* item1 = buscaArrayByPosition(&a, posicao1);
	// // item1 = buscaArrayByCadeiaEEscopo(&a, item1->cadeia, escopo);
	// Item* item2 = buscaArrayByPosition(&a, posicao2);
	// // item2 = buscaArrayByCadeiaEEscopo(&a, item2->cadeia, escopo);
	// if(strcmp(item1->tipo, item2->tipo) != 0) {
	// 	if(strcmp(item1->tipo, "char") == 0 || 
	// 		strcmp(item1->tipo, "float") == 0 || 
	// 		strcmp(item1->tipo, "int") == 0) {
	// 	} else {
	// 		printf("Erro: Os tipos das variáveis: %s, %s são imcompatíveis (%s, %s)!\n", 
	// 			item1->cadeia, item2->cadeia, item1->tipo, item2->tipo);
	// 		return;
	// 	}
	// 	if(strcmp(item2->tipo, "char") == 0 || 
	// 		strcmp(item2->tipo, "float") == 0 || 
	// 		strcmp(item2->tipo, "int") == 0) {
	// 	} else {
	// 		printf("Erro: Os tipos das variáveis: %s, %s são imcompatíveis (%s, %s)!\n", 
	// 			item1->cadeia, item2->cadeia, item1->tipo, item2->tipo);
	// 	}
	// } else {
	// 	if(strcmp(item1->tipo, "char") == 0 || 
	// 		strcmp(item1->tipo, "float") == 0 || 
	// 		strcmp(item1->tipo, "int") == 0) {
	// 	} else {
	// 		printf("O tipo das variáveis: %s, %s não estão definidos para esta operação (%s)!\n", 
	// 			item1->cadeia, item2->cadeia, item1->tipo);
	// 	}
	// }
}

char* getOpTermo(int num, int position) {
	char* str = malloc( sizeof(char) * 200 );
	strcpy(str, getOp(num));
	strcat(str, buscaArrayByPosition(&a, position)->cadeia);
	return str;
}

char* getOp(int num) {
	switch(num) {
		case 24: return " + ";
		case 25: return " - ";
		case 26: return " * ";
		case 27: return " / ";
	}
	return 0;
}

char* getTemp() {
	char* str = malloc( sizeof(char) * 100 );
	sprintf(str, "%lu", contT++);
	return str;
}

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
        strcpy(novoItem.tipo, buscaArrayByPosition(&a, tipo)->cadeia);
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
        Item *i = buscaArray(&a, item->tipo);
        return getIndiceArray(&a, i);
    }
}

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(int argc, char** argv) {
	yyin = fopen(argv[1],"r");
	if(yyin == NULL){
		printf("Arquivo fonte não existe!\n");
		return 0;
	}
	yyout = fopen(argv[2],"w+");
	// yyin = stdin;
	// yyout = stdout;
    initArray(&a, 50);
    installPalavrasReservadas();
    //printArray(&a);
 	yyparse();
 	fclose(yyin);
 	fclose(yyout);
	return 0;
}


	
	

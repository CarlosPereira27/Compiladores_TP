%{
/*-------------------------- Definitions --------------------------*/
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>
#include "tabelaDeSimbolos/TabelaDeSimbolos.h"
#include "y.tab.h"
#include "strings/erros_lexcos.h"

void yyerror(char *);
void lexerror(int lin, int col, char *ytext, char *msg);
extern int yylval;
%}

num			[+-]?{digito}+(\.{digito}+)?(E[+-]?{digito}+)?
num-int			{digito}+
digito			[0-9]
ident			{letra}({letra}|{digito})*
letra			[a-z]
void			void
int			int
float			float
struct			struct
if			if	
abre-chave		"{"
fecha-chave		"}"
abre-colchete		"["
fecha-colchete		"]"
abre-parenteses		"("       
fecha-parenteses	")"	
comentario		{abre-comentario}(([^*/])|(\*[^/])|([^*]\/))*{fecha-comentario}
abre-comentario		"/*"
fecha-comentario	"*/"
espaco			[ \t]
quebra-linha		\n
ponto-virgula		";"
virgula			","
letraMaiuscula		[A-DF-Z]
other			.
erroLetraMaiuscula1	.*[^0-9]E.*
erroLetraMaiuscula2	.*{letraMaiuscula}.*
erroLetraMaiuscula	{erroLetraMaiuscula1}|{erroLetraMaiuscula2}
erroPontoSemDigito	.*[+-]?{digito}+\.[^0-9].*
erroNumESemDigito1	.*[+-]?{digito}+(\.{digito}+)?E[^0-9\-\+].*
erroNumESemDigito2	.*[+-]?{digito}+(\.{digito}+)?E[\+\-][^0-9].*
erroNumESemDigito	{erroNumESemDigito1}|{erroNumESemDigito2}

%%
%{
/*----------------------------- Rules -----------------------------*/
%}
{espaco}		{ colCount++; } 	
{quebra-linha}		{ colCount=1;
			lineCount++; }
{ponto-virgula}		{ colCount++;
			yylval = 17;
			return (PONTO_VIRGULA); }
{virgula}		{ colCount++;
			yylval = 18;
			return (VIRGULA); }
{abre-chave}		{ colCount++;
			yylval = 11;
			return (ABRE_CHAVE); }
{fecha-chave}		{ colCount++;
			yylval = 12;
			return (FECHA_CHAVE); }
{abre-colchete}		{ colCount++;	
			yylval = 13;
			return (ABRE_COLCHETE); }
{fecha-colchete}	{ colCount++;
			yylval = 14;
			return (FECHA_COLCHETE); }
{abre-parenteses}	{ colCount++;
			yylval = 15;
			return (ABRE_PARENTESES); }      
{fecha-parenteses}	{ colCount++;
			yylval = 16;
			return (FECHA_PARENTESES); } 
"<"			{ colCount++;
			yylval = 19;
			return (RELOP); } 
"<="			{ colCount+=2;
			yylval = 20;
			return (RELOP); } 
">"			{ colCount++;
			yylval = 23;
			return (RELOP); } 
">="			{ colCount+=2;
			yylval = 24;
			return (RELOP); } 
"=="			{ colCount+=2;
			yylval = 21;
			return (RELOP); } 
"!="			{ colCount+=2;
			yylval = 22;
			return (RELOP); } 
int			{ colCount+=3;
			yylval = 0;
			return (INT); } 
float			{ colCount+=5;
			yylval = 1;
			return (FLOAT); } 
char			{ colCount+=4;
			yylval = 2;
			return (CHAR); } 
struct			{ colCount+=6;
			yylval = 3;
			return (STRUCT); } 
void			{ colCount+=4;
			yylval = 4;
			return (VOID); } 
if			{ colCount+=2;
			yylval = 6;			
			return (IF); } 
else			{ colCount+=4;
			yylval = 7;
			return (ELSE); } 
"="			{ colCount++;
			yylval = 8;
			return (ATRIBUICAO); } 
while			{ colCount+=5;
			yylval = 9;
			return (WHILE); } 
return			{ colCount+=6;
			yylval = 10;
			return (RETURN); } 
"-"			{ colCount++;
			yylval = 26;
			return (SUBTRACAO); } 
"+"			{ colCount++;
			yylval = 25;
			return (SOMA); } 
"*"			{ colCount++;
			yylval = 27;
			return (MULT); } 
"/"			{ colCount++;
			yylval = 28;
			return (DIV); } 
{comentario}		{ atualizarLineEColCount(yytext); /*fprintf(yyout,"%s (COMENTARIO)\n", yytext);*/ }
{num-int}		{ colCount+=strlen(yytext); 
			yylval = install(yytext);
			return (NUM_INT); }
{num}			{ colCount+=strlen(yytext); 
			yylval = install(yytext); 
			return (NUM); }
{ident}			{ colCount+=strlen(yytext);
			yylval = install(yytext);
			return (IDENT);}

{erroLetraMaiuscula}	{ colCount+=strlen(yytext);
			fprintf(yyout, "Linha:%d; Lexical error. Input -> \"%s\".\n", lineCount, yytext); 
			fprintf(yyout, LETRAS_CAIXA_ALTA); }
{other}			{ colCount+=strlen(yytext);
			fprintf(yyout, "Linha:%d; Coluna:%d; Lexical error. Input -> \"%s\".\n", lineCount, colCount-(int)strlen(yytext), yytext); }
{erroPontoSemDigito}	{ if(yytext[strlen(yytext)-1] == '\n') { 
				yytext[strlen(yytext)-1] = '\0';
			} fprintf(yyout, "Linha:%d; Coluna:%d; Lexical error. Input -> \"%s\".\n", lineCount, colCount, yytext);
			colCount=1; lineCount++;
			fprintf(yyout, DIGITO_APOS_O_PONTO); }	
{erroNumESemDigito}	{ fprintf(yyout, "Linha:%d; Coluna:%d; Lexical error. Input -> \"%s\".\n", lineCount, colCount, yytext);
			colCount=1; lineCount++;
			fprintf(yyout, LETRA_OU_SINAL_OPCIONAL); }

%%
/*------------------------ User subrotines ------------------------*/

void atualizarLineEColCount(char* string) {
	int i;
	for(i = 0; i < strlen(string); i++) {
		colCount++;
		if(string[i] == '\n') {
			lineCount++;
			colCount=1;
		}
	}
}

/*int installIdent(char* lexema) {
	int i;
	for(i = 0; i < simbolosIdentCount; i++) {
		if(strcmp(lexema, tabelaSimbolosIdent[i]) == 0) {
			return i;
		}
	}
	strcpy(tabelaSimbolosIdent[simbolosIdentCount], lexema);
	return simbolosIdentCount++;
}

int installNum_int(int numInt) {
	int i;
	for(i = 0; i < simbolosNum_intCount; i++) {
		if(numInt == tabelaSimbolosNum_int[i]) {
			return i;
		}
	}
	tabelaSimbolosNum_int[simbolosNum_intCount] = numInt;
	return simbolosNum_intCount++;
}*/

void installPalavrasReservadas() {
	strcpy(tabelaSimbolos[0], "int");
	strcpy(tabelaSimbolos[1], "float");
	strcpy(tabelaSimbolos[2], "char");
	strcpy(tabelaSimbolos[3], "struct");
	strcpy(tabelaSimbolos[4], "void");
	strcpy(tabelaSimbolos[6], "if");
	strcpy(tabelaSimbolos[7], "else");
	strcpy(tabelaSimbolos[8], "=");
	strcpy(tabelaSimbolos[9], "while");
	strcpy(tabelaSimbolos[10], "return");
	strcpy(tabelaSimbolos[11], "{");
	strcpy(tabelaSimbolos[12], "}");
	strcpy(tabelaSimbolos[13], "[");
	strcpy(tabelaSimbolos[14], "]");
	strcpy(tabelaSimbolos[15], "(");
	strcpy(tabelaSimbolos[16], ")");
	strcpy(tabelaSimbolos[17], ";");
	strcpy(tabelaSimbolos[18], ",");
	strcpy(tabelaSimbolos[19], "<");
	strcpy(tabelaSimbolos[20], "<=");
	strcpy(tabelaSimbolos[21], "==");
	strcpy(tabelaSimbolos[22], "!=");
	strcpy(tabelaSimbolos[23], ">");
	strcpy(tabelaSimbolos[24], ">=");
	strcpy(tabelaSimbolos[25], "+");
	strcpy(tabelaSimbolos[26], "-");
	strcpy(tabelaSimbolos[27], "*");
	strcpy(tabelaSimbolos[28], "/");
	simbolosCount = 29;
}

int install(char* token) {
	strcpy(tabelaSimbolos[simbolosCount], token);	
	return simbolosCount++;
}

/*
int installNum(float num, int tamanho) {
	int i;
	for(i = 0; i < simbolosNumCount; i++) {
		if(num == tabelaSimbolosNum[i]) {
			return i;
		}
	}
	tabelaSimbolosNum[simbolosNumCount] = num;
	tabelaSimbolosNumQtdCaracteres[simbolosNumCount] = tamanho;
	return simbolosNumCount++;
}


void exibirToken(int value) {
	printf("Linha:%d; ", lineCount);
	switch(value) {
	case INT: printf("Coluna:%d; Lexema:int; Token:INT\n", colCount-3); break;
	case FLOAT: printf("Coluna:%d; Lexema:float; Token:FLOAT\n", colCount-5); break;
	case CHAR: printf("Coluna:%d; Lexema:char; Token:CHAR\n", colCount-4); break;
	case STRUCT: printf("Coluna:%d; Lexema:struct; Token:STRUCT\n", colCount-6); break;
	case VOID: printf("Coluna:%d; Lexema:void; Token:VOID\n", colCount-4); break;
	case IF: printf("Coluna:%d; Lexema:if; Token:IF\n", colCount-2); break;
	case ELSE: printf("Coluna:%d; Lexema:else; Token:ELSE\n", colCount-4); break;
	case ATRIBUICAO: printf("Coluna:%d; Lexema:=; Token:ATRIBUICAO\n", colCount-1); break;
	case WHILE: printf("Coluna:%d; Lexema:while; Token:WHILE\n", colCount-5); break;
	case RETURN: printf("Coluna:%d; Lexema:return; Token:RETURN\n", colCount-6); break;
	case ABRE_CHAVE: printf("Coluna:%d; Lexema:{; Token:ABRE_CHAVE\n", colCount-1); break;
	case FECHA_CHAVE: printf("Coluna:%d; Lexema:}; Token:FECHA_CHAVE\n", colCount-1); break;
	case ABRE_COLCHETE: printf("Coluna:%d; Lexema:[; Token:ABRE_COLCHETE\n", colCount-1); break;
	case FECHA_COLCHETE: printf("Coluna:%d; Lexema:]; Token:FECHA_COLCHETE\n", colCount-1); break;
	case ABRE_PARENTESES: printf("Coluna:%d; Lexema:(; Token:ABRE_PARENTESES\n", colCount-1); break;
	case FECHA_PARENTESES: printf("Coluna:%d; Lexema:); Token:FECHA_PARENTESES\n", colCount-1); break;
	case PONTO_VIRGULA: printf("Coluna:%d; Lexema:;; Token:PONTO_VIRGULA\n", colCount-1); break;
	case VIRGULA: printf("Coluna:%d; Lexema:,; Token:VIRGULA\n", colCount-1); break;
	case RELOP: 
		switch(yylval) {
		case LT: printf("Coluna:%d; Lexema:<; Token:RELOP->LT\n", colCount-1); break;
		case LE: printf("Coluna:%d; Lexema:<=; Token:RELOP->LE\n", colCount-2); break;
		case EQ: printf("Coluna:%d; Lexema:==; Token:RELOP->EQ\n", colCount-2); break;
		case NE: printf("Coluna:%d; Lexema:!=; Token:RELOP->NE\n", colCount-2); break;
		case GT: printf("Coluna:%d; Lexema:>; Token:RELOP->GT\n", colCount-1); break;
		case GE: printf("Coluna:%d; Lexema:>=; Token:RELOP->GE\n", colCount-2); break;
		}; break;
	case SOMA: printf("Coluna:%d; Lexema:+; Token:SOMA\n", colCount-1); break;
	case SUBTRACAO: printf("Coluna:%d; Lexema:-; Token:SUBTRACAO\n", colCount-1); break;
	case MULT: printf("Coluna:%d; Lexema:*; Token:MULT\n", colCount-1); break;
	case DIV: printf("Coluna:%d; Lexema:/; Token:DIV\n", colCount-1); break;
	case NUM_INT: printf("Coluna:%d; Lexema:%d; Token:<NUM_INT,ID%d>\n", colCount-((int)log10(tabelaSimbolosNum_int[yylval]))-1, tabelaSimbolosNum_int[yylval], yylval); break;
	case NUM: printf("Coluna:%d; Lexema:%f; Token:<NUM,ID%d>\n", colCount-tabelaSimbolosNumQtdCaracteres[yylval], tabelaSimbolosNum[yylval], yylval); break;
	case IDENT: printf("Coluna:%d; Lexema:%s; Token:<IDENT,ID%d>\n", colCount-(int)strlen(tabelaSimbolosIdent[yylval]), tabelaSimbolosIdent[yylval], yylval); break;
	}
}*/

int getLineCount() {
	return lineCount;
}

int getColCount() {
	return colCount;
}

int getTamanhoLexicoDoToken(int posicaoTabelaDeSimbolos) {
	return strlen(tabelaSimbolos[posicaoTabelaDeSimbolos]);
}

char* getValorLexicoDoToken(int posicaoTabelaDeSimbolos) {
	return tabelaSimbolos[posicaoTabelaDeSimbolos];
}

void setEntrada(char* arquivo) {
	yyin = fopen(arquivo, "r");
    	yyout=stdout;
}

/*int getTamanhoToken(int token) {
	printf("%d\n", token);
	switch(token) {
	case INT: return 3;
	case FLOAT: return 5;
	case CHAR: return 4;
	case STRUCT: return 6;
	case VOID: printf("Coluna:%d; Lexema:void; Token:VOID\n", colCount-4); break;
	case IF: printf("Coluna:%d; Lexema:if; Token:IF\n", colCount-2); break;
	case ELSE: printf("Coluna:%d; Lexema:else; Token:ELSE\n", colCount-4); break;
	case ATRIBUICAO: printf("Coluna:%d; Lexema:=; Token:ATRIBUICAO\n", colCount-1); break;
	case WHILE: printf("Coluna:%d; Lexema:while; Token:WHILE\n", colCount-5); break;
	case RETURN: printf("Coluna:%d; Lexema:return; Token:RETURN\n", colCount-6); break;
	case ABRE_CHAVE: printf("Coluna:%d; Lexema:{; Token:ABRE_CHAVE\n", colCount-1); break;
	case FECHA_CHAVE: printf("Coluna:%d; Lexema:}; Token:FECHA_CHAVE\n", colCount-1); break;
	case ABRE_COLCHETE: printf("Coluna:%d; Lexema:[; Token:ABRE_COLCHETE\n", colCount-1); break;
	case FECHA_COLCHETE: printf("Coluna:%d; Lexema:]; Token:FECHA_COLCHETE\n", colCount-1); break;
	case ABRE_PARENTESES: printf("Coluna:%d; Lexema:(; Token:ABRE_PARENTESES\n", colCount-1); break;
	case FECHA_PARENTESES: printf("Coluna:%d; Lexema:); Token:FECHA_PARENTESES\n", colCount-1); break;
	case PONTO_VIRGULA: printf("Coluna:%d; Lexema:;; Token:PONTO_VIRGULA\n", colCount-1); break;
	case VIRGULA: printf("Coluna:%d; Lexema:,; Token:VIRGULA\n", colCount-1); break;
	case RELOP: 
		switch(yylval) {
		case LT: printf("Coluna:%d; Lexema:<; Token:RELOP->LT\n", colCount-1); break;
		case LE: printf("Coluna:%d; Lexema:<=; Token:RELOP->LE\n", colCount-2); break;
		case EQ: printf("Coluna:%d; Lexema:==; Token:RELOP->EQ\n", colCount-2); break;
		case NE: printf("Coluna:%d; Lexema:!=; Token:RELOP->NE\n", colCount-2); break;
		case GT: printf("Coluna:%d; Lexema:>; Token:RELOP->GT\n", colCount-1); break;
		case GE: printf("Coluna:%d; Lexema:>=; Token:RELOP->GE\n", colCount-2); break;
		}; break;
	case SOMA: printf("Coluna:%d; Lexema:+; Token:SOMA\n", colCount-1); break;
	case SUBTRACAO: printf("Coluna:%d; Lexema:-; Token:SUBTRACAO\n", colCount-1); break;
	case MULT: printf("Coluna:%d; Lexema:*; Token:MULT\n", colCount-1); break;
	case DIV: printf("Coluna:%d; Lexema:/; Token:DIV\n", colCount-1); break;
	case NUM_INT: printf("Coluna:%d; Lexema:%d; Token:<NUM_INT,ID%d>\n", colCount-((int)log10(tabelaSimbolosNum_int[yylval]))-1, tabelaSimbolosNum_int[yylval], yylval); break;
	case NUM: printf("Coluna:%d; Lexema:%f; Token:<NUM,ID%d>\n", colCount-tabelaSimbolosNumQtdCaracteres[yylval], tabelaSimbolosNum[yylval], yylval); break;
	case IDENT: printf("Coluna:%d; Lexema:%s; Token:<IDENT,ID%d>\n", colCount-(int)strlen(tabelaSimbolosIdent[yylval]), tabelaSimbolosIdent[yylval], yylval); break;
	default: return -1;
	}
	return -1;
}

int main(int argc, char *argv[]){
   	yyin = fopen(argv[1], "r");
    	yyout=stdout;
	while(1) {
		exibirToken(yylex());
		getchar();
	}
    	return 0;
}*/

int yywrap(){
    	return 0;
}

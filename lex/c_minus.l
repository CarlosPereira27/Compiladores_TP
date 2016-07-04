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
{quebra-linha}		{ colCount=1; lineCount++; }
{ponto-virgula}		{ colCount++; 
			return (PONTO_VIRGULA); }
{virgula}		{ colCount++;
			return (VIRGULA); }
{abre-chave}		{ colCount++;
			return (ABRE_CHAVE); }
{fecha-chave}		{ colCount++;
			return (FECHA_CHAVE); }
{abre-colchete}		{ colCount++;
			return (ABRE_COLCHETE); }
{fecha-colchete}	{ colCount++;
			return (FECHA_COLCHETE); }
{abre-parenteses}	{ colCount++;
			return (ABRE_PARENTESES); }      
{fecha-parenteses}	{ colCount++;
			return (FECHA_PARENTESES); } 
"<"			{ colCount++;
			yylval = LT;
			return (RELOP); } 
"<="			{ colCount+=2;
			yylval = LE;
			return (RELOP); } 
">"			{ colCount++;
			yylval = GT;
			return (RELOP); } 
">="			{ colCount+=2;
			yylval = GE;
			return (RELOP); } 
"=="			{ colCount+=2;
			yylval = EQ;
			return (RELOP); } 
"!="			{ colCount+=2;
			yylval = NE;
			return (RELOP); } 
int			{ colCount+=3;
			return (INT); } 
float			{ colCount+=5;
			return (FLOAT); } 
char			{ colCount+=4;
			return (CHAR); } 
struct			{ colCount+=6;
			return (STRUCT); } 
void			{ colCount+=4;
			return (VOID); } 
if			{ colCount+=2;
			return (IF); } 
else			{ colCount+=4;
			return (ELSE); } 
"="			{ colCount++;
			return (ATRIBUICAO); } 
while			{ colCount+=5;
			return (WHILE); } 
return			{ colCount+=6;
			return (RETURN); } 
"-"			{ colCount++;
			return (SUBTRACAO); } 
"+"			{ colCount++;
			return (SOMA); } 
"*"			{ colCount++;
			return (MULT); } 
"/"			{ colCount++;
			return (DIV); } 
{comentario}		{ atualizarLineEColCount(yytext); /*fprintf(yyout,"%s (COMENTARIO)\n", yytext);*/ }
{num-int}		{ colCount+=strlen(yytext); 
			yylval = installNum_int(atoi(yytext));
			return (NUM_INT); }
{num}			{ colCount+=strlen(yytext); 
			yylval = installNum(atof(yytext),strlen(yytext)); 
			return (NUM); }
{ident}			{ colCount+=strlen(yytext);
			yylval = installIdent(yytext);
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

int installIdent(char* lexema) {
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
}

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
}

/*int main(int argc, char *argv[]){
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

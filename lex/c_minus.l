%{l
/*-------------------------- Definitions --------------------------*/
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <math.h>
#include "tabelaDeSimbolos/TabelaDeSimbolos.h"
#include "strings/erros_lexcos.h"
#include "yacc.h"

extern int yylval;
int colCount;
int lineCount;

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
{comentario}		{ /*atualizarLineEColCount(yytext); /*fprintf(yyout,"%s (COMENTARIO)\n", yytext);*/ }
{num-int}		{ colCount+=strlen(yytext);
			yylval = 29; 
			//yylval = install(yytext);
			return (NUM_INT); }
{num}			{ colCount+=strlen(yytext); 
			yylval = 30; 
			///yylval = install(yytext); 
			return (NUM); }
{ident}			{ colCount+=strlen(yytext);
			yylval = 31; 
			//yylval = install(yytext);
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

int yywrap(){
    	return 0;
}

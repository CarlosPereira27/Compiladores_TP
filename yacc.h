/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_YACC_H_INCLUDED
# define YY_YY_YACC_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT = 258,
    FLOAT = 259,
    CHAR = 260,
    STRUCT = 261,
    VOID = 262,
    IF = 263,
    ELSE = 264,
    ATRIBUICAO = 265,
    WHILE = 266,
    RETURN = 267,
    IDENT = 268,
    ABRE_CHAVE = 269,
    FECHA_CHAVE = 270,
    ABRE_COLCHETE = 271,
    FECHA_COLCHETE = 272,
    ABRE_PARENTESES = 273,
    FECHA_PARENTESES = 274,
    PONTO_VIRGULA = 275,
    VIRGULA = 276,
    NUM_INT = 277,
    NUM = 278,
    RELOP = 279,
    LT = 280,
    LE = 281,
    EQ = 282,
    NE = 283,
    GT = 284,
    GE = 285,
    SOMA = 286,
    SUBTRACAO = 287,
    MULT = 288,
    DIV = 289,
    THEN = 290
  };
#endif
/* Tokens.  */
#define INT 258
#define FLOAT 259
#define CHAR 260
#define STRUCT 261
#define VOID 262
#define IF 263
#define ELSE 264
#define ATRIBUICAO 265
#define WHILE 266
#define RETURN 267
#define IDENT 268
#define ABRE_CHAVE 269
#define FECHA_CHAVE 270
#define ABRE_COLCHETE 271
#define FECHA_COLCHETE 272
#define ABRE_PARENTESES 273
#define FECHA_PARENTESES 274
#define PONTO_VIRGULA 275
#define VIRGULA 276
#define NUM_INT 277
#define NUM 278
#define RELOP 279
#define LT 280
#define LE 281
#define EQ 282
#define NE 283
#define GT 284
#define GE 285
#define SOMA 286
#define SUBTRACAO 287
#define MULT 288
#define DIV 289
#define THEN 290

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_YACC_H_INCLUDED  */
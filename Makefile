compile: analisador-lexico analisador-sintatico
#	gcc	lex.c	yacc.c	yacc.h -o	c_minus	-w	-lm	-ll
	gcc -o c_minus	lex.c 	yacc.c yacc.h tabelaDeSimbolos/TabelaDeSimbolos.c -lm -ll

analisador-sintatico:
	yacc -o	yacc.c	-vd	yacc/c_minus.y
#	yacc -d -l yacc/c_minus.y

analisador-lexico:
	lex	-o	lex.c	-l	lex/c_minus.l
#	lex lex/c_minus.l

clean : 
	rm -rf lex.yy.c lex.c
	rm -rf y.tab.c yacc.c 
	rm -rf y.tab.h	yacc.h
	rm -rf yacc.output

mproper: clean
	rm -rf c_minus

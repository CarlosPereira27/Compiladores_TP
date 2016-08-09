compile: analisador-lexico analisador-sintatico
	gcc lex.yy.c y.tab.c -o c_minus -lm -w

analisador-sintatico:
	yacc -d yacc/c_minus.y

analisador-lexico:
	lex lex/c_minus.l

clean : 
	rm -rf lex.yy.c 
	rm -rf y.tab.c
	rm -rf y.tab.h

mproper: clean
	rm -rf c_minus

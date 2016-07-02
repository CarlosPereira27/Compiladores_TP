lex lex/c_minus.l
yacc -d yacc/c_minus.y 
gcc lex.yy.c y.tab.c -o c_minus -lm

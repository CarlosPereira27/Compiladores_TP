compile:
	./c_minus.sh

clean : 
	rm -rf lex.yy.c 
	rm -rf y.tab.c
	rm -rf y.tab.h

mproper: clean
	rm -rf c_minus

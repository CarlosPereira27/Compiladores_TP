#include "TabelaDeSimbolos.h"

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

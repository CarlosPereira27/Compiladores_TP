#include "TabelaDeSimbolos.h"
#include "string.h"

//void atualizarLineEColCount(char* string) {
//	int i;
//	for(i = 0; i < strlen(string); i++) {
//		colCount++;
//		if(string[i] == '\n') {
//			lineCount++;
//			colCount=1;
//		}
//	}
//}

void printArray(Array *a) {
    int i;
    for (i = 0; i < a->used; i++) {
        printf("Cadeia:%s; Valor:%s\n", 
                a->array[i].cadeia, a->array[i].valor);
    }
}

void initArray(Array *a, size_t initialSize) {
  a->array = (Item *) malloc(initialSize * sizeof(Item));
  a->used = 0;
  a->size = initialSize;
}

Item* buscaArray(Array *a, char *cadeia) {
    int i;
    for(i = 0; i < a->used; i++) {
        if(strcmp(a->array[i].cadeia, cadeia) == 0) {
            return &a->array[i];
        }
    }
    return NULL;
}

int insertArray(Array *a, Item element) {
  if (a->used == a->size) {
    a->size *= 2;
    a->array = (Item *)realloc(a->array, a->size * sizeof(Item));
  }
  if(buscaArray(a, element.cadeia) == NULL) {
    a->array[a->used++] = element;
    return 1;
  }
  return 0;
}

void freeArray(Array *a) {
  free(a->array);
  a->array = NULL;
  a->used = a->size = 0;
}



void copyItem(Item *itemDest, Item *itemSrc) {
    if(itemSrc->cadeia != NULL) {
        printf("OK%s-%s\n", itemDest->cadeia, itemSrc->cadeia);
        strcpy(itemDest->cadeia, itemSrc->cadeia);
        printf("OK\n");
    }
    itemDest->token = itemSrc->token;
    itemDest->categoria = itemSrc->categoria;
    printf("OK\n");
    if(itemSrc->tipo != NULL) {
        strcpy(itemDest->tipo, itemSrc->tipo);
        printf("OK\n");
    }
    if(itemSrc->valor != NULL) {
        strcpy(itemDest->valor, itemSrc->valor);
        printf("OK\n");
    }
    itemDest->escopo = itemSrc->escopo;
}

int removeArray(Array *a, char *cadeia) {
    Item* item = buscaArray(a, cadeia);
    if(item != NULL) {
        copyItem(item, &a->array[a->used-1]);
        a->used--;
        return 1;
    }
    return 0;
}

/*
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

int tamanhoToken(int token) {

	return 0;
}

int getLineCount() {
	return lineCount;
}

int getColCount() {
	return colCount;
}*/


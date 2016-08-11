#include "TabelaDeSimbolos.h"
#include "string.h"

void printArray(Array *a) {
    int i;
    for (i = 0; i < a->used; i++) {
        printf("Cadeia:%s; Tipo:%s; Escopo:%d\n", 
                a->array[i].cadeia, a->array[i].tipo, a->array[i].escopo);
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

Item* buscaArrayByPosition(Array *a, int posicao) {
    return &a->array[posicao];
}

Item* buscaArrayByCadeiaEEscopo(Array *a, char* cadeia, int escopo) {
    int i;
    for(i = 0; i < a->used; i++) {
        if(strcmp(a->array[i].cadeia, cadeia) == 0 && 
                a->array[i].escopo == escopo) {
            return &a->array[i];
        }
    }
    return NULL;
}

Item* buscaArrayYacc(Array *a, int posicao, int escopo) {
    Item* item = &a->array[posicao];
    if(item->escopo == escopo) {
        return item;
    } else {
        return buscaArrayByCadeiaEEscopo(a, item->cadeia, escopo);
    }
}

int getIndiceArray(Array *a, Item* item) {
    int i;
    for(i = 0; i < a->used; i++) {
        if(equalsItem(&a->array[i], item) == 1) {
            return i;
        }
    }
    return -1;
}

int equalsItem(Item* item1, Item* item2) {
    if(strcmp(item1->cadeia, item2->cadeia) != 0) {
        return 0;
    }
    /*if(strcmp(item1->tipo, item2->tipo) != 0) {
        return 0;
    }
    if(strcmp(item1->valor, item2->valor) != 0) {
        return 0;
    }
    if(item1->token != item2->token) {
        return 0;
    }
    if(item1->categoria != item2->categoria) {
        return 0;
    }//*/
    if(item1->escopo != item2->escopo) {
        return 0;
    }
    return 1;
}

int insertArray(Array *a, Item element) {
  if (a->used == a->size) {
    a->size *= 2;
    a->array = (Item *)realloc(a->array, a->size * sizeof(Item));
  }
  int indiceItem = getIndiceArray(a, &element);
  if(indiceItem == -1) {
    a->array[a->used] = element;
    return a->used++;
  } 
  return indiceItem;
}

void freeArray(Array *a) {
  free(a->array);
  a->array = NULL;
  a->used = a->size = 0;
}



void copyItem(Item *itemDest, Item *itemSrc) {
    if(itemSrc->cadeia != NULL) {
        strcpy(itemDest->cadeia, itemSrc->cadeia);
    }
    itemDest->token = itemSrc->token;
    itemDest->categoria = itemSrc->categoria;
    if(itemSrc->tipo != NULL) {
        strcpy(itemDest->tipo, itemSrc->tipo);
    }
    if(itemSrc->valor != NULL) {
        strcpy(itemDest->valor, itemSrc->valor);
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

void removeArrayByPosition(Array *a, int position) {
    copyItem(&a->array[position], &a->array[a->used-1]);
    a->used--;
}

void removeArrayEscopo(Array *a, int escopo) {
   int i;
    for(i = 0; i < a->used; i++) {
        if(a->array[i].escopo == escopo) {
            removeArrayByPosition(a, i);
        }
    }
}

Item getItemLex(char* cadeia, int token) {
    Item item;
    strcpy(item.cadeia, cadeia);
    item.token = token;
    item.escopo = -1;
    strcpy(item.tipo, "");
    strcpy(item.valor, "");
    return item;
}

Item getItem(char* cadeia, int token, int categoria,
    char* tipo, char* valor, int escopo) {
    Item item;
    strcpy(item.cadeia, cadeia);
    item.token = token;
    item.categoria = categoria;
    strcpy(item.tipo, tipo);
    strcpy(item.valor, valor);
    item.escopo = escopo;
    return item;
}

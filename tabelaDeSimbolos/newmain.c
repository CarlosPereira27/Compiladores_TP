/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   newmain.c
 * Author: carlos
 *
 * Created on August 9, 2016, 9:02 PM
 */

#include <stdio.h>
#include <stdlib.h>
#include "TabelaDeSimbolos.h"

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

/*
 * 
 */
int main(int argc, char** argv) {
    Array a;
    initArray(&a, 3);

    char name[50];

    name[0] = 'o';
    name[1] = 'i';
    name[2] = '\n';

    Item item = getItem("cadeia1", 1, 10, "tipo1", "valor1", 0);
    insertArray(&a, item);
    strcpy(item.cadeia, "ola");
    item.categoria = 10;
    item.escopo = 20;
    item.tipo = "as";
    item.token = 1;
    insertArray(&a, item);
    item.cadeia = name;
    item.valor = "tu";
    insertArray(&a, item);
    item.cadeia = "oi1";
    item.valor = "tu2";
    insertArray(&a, item);
    item.cadeia = "oi2";
    item.valor = "tu3";
    insertArray(&a, item);
    item.cadeia = "oi3";
    item.valor = "tu3";
    insertArray(&a, item);
    //    if(buscaArray(&a, "alo") == NULL) {
    //        printf("Deu certo");
    //    };
    removeArray(&a, "oi");
    printArray(&a);
    return (EXIT_SUCCESS);
}


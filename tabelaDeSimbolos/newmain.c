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
/*
 * 
 */
int main(int argc, char** argv) {
    Array a;
    initArray(&a, 3);

    Item item = getItem("cadeia1", 1, 10, "tipo1", "valor1", 0);
    insertArray(&a, item);
    
    Item item = getItem("cadeia2", 1, 10, "tipo1", "valor1", 0);
    insertArray(&a, item);

    //    if(buscaArray(&a, "alo") == NULL) {
    //        printf("Deu certo");
    //    };
    removeArray(&a, "oi");
    printArray(&a);
    return (EXIT_SUCCESS);
}


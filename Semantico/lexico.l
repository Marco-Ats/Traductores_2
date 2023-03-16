%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sintactico.tab.h"

int num_lines = 1;
%}

/*Seccion de opciones*/
%option noyywrap
/* Nombre de salida del archivo */
%option outfile = "scanner.c"


/* SECCION DE TOKENS */

/*TOKENS BASICOS*/
DIGITO            [0-9]
LETRA             [a-zA-ZñÑ]
GUIONBAJO         [_]
COMA              ","
PUNTO             "."
PUNTOYCOMA        ";"
ESPACIOS          [" "\n\t]         
COMENTARIO        "//"[^\n]*
CADENA            (\"[^\n"]*\")
CARACTER          \'[^\n']\'
ENTERO            (-?[1-9][0-9]{0,4})|0
REAL              (-?{DIGITO}{0,8}"."{DIGITO}{1,8})
ID                {LETRA}({LETRA}|{DIGITO}|{GUIONBAJO})*

/*PALABRAS RESERVADAS*/
IF                "si"
ELSE              "sino"
WHILE             "mientras"
FOR               "para"
INT               "entero"
FLOAT             "decimal"
STRING            "cadena"
CHAR              "caracter"
PRINT             "imprimir"
INPUT             "entrada"
AND               "and"
OR                "or"
BOOL              "booleano"
TRUE              "verdadero"
FALSE             "falso"
STRCMP            "strcmp"

/*DELIMITADORES*/
LLAVE_A           "{"
LLAVE_C           "}"
PARENTESIS_A      "("
PARENTESIS_C      ")"
CORCHETE_A        "["
CORCHETE_C        "]" 

/*OPERADORES*/
OP_SUMA           "+"
OP_RESTA          "-"
OP_MULT           "*"
OP_DIV            "/"
OP_IGUAL          "="
OP_MENOR          "<"
OP_MENORIGUAL     "<="
OP_MAYOR          ">"
OP_MAYORIGUAL     ">="
OP_COMP_IGUAL     "=="
OP_NEGACION       "!"
OP_DISTINTO       "!="

/*Seccion de reglas, es importante el orden debido a que se buscara el patron y se ejecutara el patron en orden secuencial*/
%%

{COMA}            {return COMA;}
{PUNTOYCOMA}      {return PUNTOYCOMA;}
{ENTERO}          {yylval.ival = atoi(yytext); return ENTERO;}
{REAL}            {yylval.fval = atof(yytext); return REAL;}
{CARACTER}        {yylval.car = yytext[1]; return CARACTER;}
{CADENA}          {yylval.str = strdup(yytext); return CADENA;}
{GUIONBAJO}       {return GUIONBAJO;}
{PUNTO}           {return PUNTO;}
{COMENTARIO}      {return COMENTARIO;}
 
{OP_SUMA}         {return OP_SUMA;}
{OP_RESTA}        {return OP_RESTA;}
{OP_MULT}         {return OP_MULT;}
{OP_DIV}          {return OP_DIV;}
{OP_IGUAL}        {return OP_IGUAL;}
{OP_MENOR}        {return OP_MENOR;}
{OP_MENORIGUAL}   {return OP_MENORIGUAL;}
{OP_MAYOR}        {return OP_MAYOR;}
{OP_MAYORIGUAL}   {return OP_MAYORIGUAL;}
{OP_COMP_IGUAL}   {return OP_COMP_IGUAL;}
{OP_NEGACION}     {return OP_NEGACION;}
{OP_DISTINTO}     {return OP_DISTINTO;}

{LLAVE_A}         {return LLAVE_A;}
{LLAVE_C}         {return LLAVE_C;}
{PARENTESIS_A}    {return PARENTESIS_A;}
{PARENTESIS_C}    {return PARENTESIS_C;}
{CORCHETE_A}      {return CORCHETE_A;}
{CORCHETE_C}      {return CORCHETE_C;}

{IF}              {return IF;}
{ELSE}            {return ELSE;}
{WHILE}           {return WHILE;}
{FOR}             {return FOR;}
{INT}             {return INT;}
{FLOAT}           {return FLOAT;}
{STRING}          {return STRING;}
{CHAR}            {return CHAR;}
{PRINT}           {return PRINT;}
{INPUT}           {return INPUT;}
{AND}             {return AND;}
{OR}              {return OR;}
{TRUE}            {yylval.ival = 1; return TRUE;}
{FALSE}           {yylval.ival = 0; return FALSE;}
{BOOL}            {return BOOL;}
{STRCMP}          {return STRCMP;}

{ID}              {yylval.str = strdup(yytext); return ID;}

{ESPACIOS}

.               {printf("Error, caracter invalido: %s\n", yytext);}

%%
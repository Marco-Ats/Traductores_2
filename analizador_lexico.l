%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

/*Seccion de opciones*/
%option noyywrap
/* Nombre de salida del archivo */
%option outfile = "lex.c"


/* TOKEN SECTION */

/*BASIC TOKENS*/
DIGIT             [0-9]
LETTER            [a-zA-ZñÑ]
UNDERSCORE        [_]
COMMA             ","
POINT             "."
COMMENT           "//"
SEMICOLON         ";"
SPACES            [" "\n\t]
CHAIN             \"[^\n"]*\"
INTEGER           (-?[1-9][0-9]{0,4})|0
REAL              {DIGIT}{0,8}"."{DIGIT}{1,8}
ID                {LETTER}({LETTER}|{DIGIT}|{UNDERSCORE})*

/*RESERVED WORDS*/
NULL              "nulo"
IMPORT            "importar"
DEFINE            "definir"
RETURN            "retornar"
TRY               "intentar"
EXCEPTION         "excepcion"
ENUM              "enumerar"
IF                "si"
ELSE              "sino"
ELIF              "sinosi"
DO                "hacer"
WHILE             "mientras"
FOR               "para"
SWITCH            "segun"
CASE              "caso"
BREAK             "romper"
GLOBAL            "global"
CONSTANT          "constante"
UNSIGNED          "nosigno"
INT               "entero"
FLOAT             "decimal"
BOOLEAN           "booleano"
STRING            "cadena"
CHAR              "caracter"
SHORT             "corto"
DOUBLE            "doble"
PRINT             "imprimir"
SCAN              "leer"
TRUE              "verdadero"
FALSE             "falso"

/*DELIMITERS*/
BRACKET_O             "{"
BRACKET_C             "}"
PARENTHESES_O     "("
PARENTHESES_C     ")"
SQUARE_BRACKET_O  "["
SQUARE_BRACKET_C  "]" 

/*OPERATORS*/
SUM                  "+"
SUBTRACTION          "-"
MULTIPLICATION       "*"
DIVISION             "/"
EQUAL                "="
LESS_THAN            "<"
LESS_OR_EQUAL_THAN   "<="
MORE_THAN            ">"
MORE_OR_EQUAL_THAN   ">="
EQUAL_THAN           "=="
NEGATION             "!"
DIFFERENT            "!="
INCREMENT            "++"
DECREMENT            "--"
OR                   "||"
AND                  "&&"

/*Rules section, its order is very important because the pattern will be searched and executed in a sequential manner*/
%%

{COMMA}            {printf("COMA: %s\n", yytext);}
{SEMICOLON}        {printf("DELIMITADOR PUNTO Y COMA: %s\n", yytext);}
{INTEGER}          {printf("ENTERO: %s\n", yytext);}
{REAL}             {printf("REAL: %s\n", yytext);}
{CHAIN}            {printf("CADENA DE CARACTERES: %s\n", yytext);}
{UNDERSCORE}       {printf("GUION BAJO: %s\n", yytext);}
{POINT}            {printf("PUNTO: %s\n", yytext);}
{COMMENT}          {printf("COMENTARIO: %s\n", yytext);}

 
{SUM}                {printf("OPERADOR SUMA: %s\n", yytext);}
{SUBTRACTION}        {printf("OPERADOR RESTA: %s\n", yytext);}
{MULTIPLICATION}     {printf("OPERADOR DE MULTIPLICACION: %s\n", yytext);}
{DIVISION}           {printf("OPERADOR DE DIVISION: %s\n", yytext);}
{EQUAL}              {printf("OPERADOR IGUAL: %s\n", yytext);}
{LESS_THAN}          {printf("OPERADOR MENOR QUE: %s\n", yytext);}
{LESS_OR_EQUAL_THAN} {printf("OPERADOR MENOR O IGUAL: %s\n", yytext);}
{MORE_THAN}          {printf("OPERADOR MAYOR QUE: %s\n", yytext);}
{MORE_OR_EQUAL_THAN} {printf("OPERADOR MAYOR O IGUAL: %s\n", yytext);}
{EQUAL_THAN}         {printf("OPERADOR IGUAL QUE: %s\n", yytext);}
{NEGATION}           {printf("OPERADOR DE NEGACION: %s\n", yytext);}
{DIFFERENT}          {printf("OPERADOR DIFERENTE DE: %s\n", yytext);}
{INCREMENT}          {printf("OPERADOR DE INCREMENTO: %s\n", yytext);}
{DECREMENT}           {printf("OPERADOR DE DECREMENTO: %s\n", yytext);}

{BRACKET_O}          {printf("SIMBOLO APERTURA DE LLAVE: %s\n", yytext);}
{BRACKET_C}          {printf("SIMBOLO CIERRE DE LLAVE: %s\n", yytext);}
{PARENTHESES_O}      {printf("SIMBOLO APERTURA DE PARENTESIS: %s\n", yytext);}
{PARENTHESES_C}      {printf("SIMBOLO CIERRE DE PARENTESIS: %s\n", yytext);}
{SQUARE_BRACKET_O}   {printf("SIMBOLO APERTURA DE CORCHETE: %s\n", yytext);}
{SQUARE_BRACKET_C}   {printf("SIMBOLO CIERRE DE CORCHETE: %s\n", yytext);}  

{NULL}            {printf("PALABRA RESERVADA NULO\n");}
{IMPORT}          {printf("PALABRA RESERVADA IMPORTAR\n");}
{DEFINE}          {printf("PALABRA RESERVADA DEFINIR\n");}
{RETURN}          {printf("PALABRA RESERVADA RETORNAR\n");}
{TRY}             {printf("PALABRA RESERVADA INTENTAR\n");}
{EXCEPTION}       {printf("PALABRA RESERVADA EXCEPCION\n");}
{ENUM}            {printf("PALABRA RESERVADA ENUMERAR\n");}
{IF}              {printf("PALABRA RESERVADA SI\n");}
{ELSE}            {printf("PALABRA RESERVADA SINO\n");}
{ELIF}            {printf("PALABRA RESERVADA SINOSI\n");}
{DO}              {printf("PALABRA RESERVADA HACER\n");}
{WHILE}           {printf("PALABRA RESERVADA MIENTRAS\n");}
{FOR}             {printf("PALABRA RESERVADA PARA\n");}
{SWITCH}          {printf("PALABRA RESERVADA SEGUN\n");}
{CASE}            {printf("PALABRA RESERVADA CASO\n");}
{BREAK}           {printf("PALABRA RESERVADA ROMPER\n");}
{GLOBAL}          {printf("PALABRA RESERVADA GLOBAL\n");}
{CONSTANT}        {printf("PALABRA RESERVADA CONSTANTE\n");}
{UNSIGNED}        {printf("PALABRA RESERVADA NOSIGNO\n");}
{INT}             {printf("PALABRA RESERVADA ENTERO\n");}
{FLOAT}           {printf("PALABRA RESERVADA DECIMAL\n");}
{BOOLEAN}         {printf("PALABRA RESERVADA BOOLEANO\n");}
{STRING}          {printf("PALABRA RESERVADA CADENA\n");}
{CHAR}            {printf("PALABRA RESERVADA CARACTER\n");}
{SHORT}           {printf("PALABRA RESERVADA CORTO\n");}
{DOUBLE}          {printf("PALABRA RESERVADA DOBLE\n");}
{PRINT}           {printf("PALABRA RESERVADA IMPRIMIR\n");}
{SCAN}            {printf("PALABRA RESERVADA LEER\n");}
{TRUE}            {printf("PALABRA RESERVADA VERDADERO\n");}
{FALSE}           {printf("PALABRA RESERVADA FALSO\n");}
{AND}             {printf("PALABRA RESERVADA Y\n");}
{OR}              {printf("PALABRA RESERVADA O\n");}

{ID}              {printf("ID: %s\n", yytext);}

{SPACES}      

.               {printf("Error, CARACTER INVALIDO: %s\n", yytext);}

%%

int main(){
    
    char linea[255];
    FILE *archivo = fopen("codigo.txt","r");
    FILE *aux = fopen("tem.txt", "w");

    while(fgets(linea, sizeof(linea), archivo)){
        aux = freopen("tem.txt", "w", aux);
        
        if(linea[strlen(linea)-1] == '\n')
            linea[strlen(linea)-1] = ' ';
        
        printf("\n\nLinea: %s\n\n\n", linea);
        fprintf(aux, "%s", linea);
        aux = freopen("tem.txt", "r", aux);
        yyin = aux;
        yylex();
        printf("--------------------------------------------------------------------------------------------------"); 
    }
    printf("\n");
    system("pause");
    fclose(archivo);
    fclose(aux);
    remove("tem.txt");
    return 0;
}
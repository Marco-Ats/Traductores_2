%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

/////////////////////////////////////

#define SIZE 100

struct dataItem{
  char* clave;
  void* valor;
  int tipo;
  int bandera;
};

struct dataItem dic[SIZE];
int count = 0;
int aux;

////////////////////////////////////

extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

void guardar(char*, void*, int);
void actualizar(char*, void*, int);
void inc_dec(char*, int);
int buscar(char*);
float obtNum(char*);
char* cad_print(char*);
int iof(float);
int cad_bool(char*, char*);
char* bool_s_id(char*);

void* iof_p(float);
int * intdup(int*);
float * floatdup(float*);
char* chardup(char*);
char* itoa(int);
char* ftoa(float);

char* iftos(char*);

void imprimir();
void noUsadas();

%}

%union {
  int ival;
  float fval;
  char *str;
  char car;
  void* vd;
}

%token<ival> ENTERO
%token<fval> REAL
%token<str> ID CADENA
%token<car> CARACTER
%token<ival> TRUE FALSE

%type<str> cadena_io
%type<fval> exp_ari
%type<ival> exp_bool
%type<ival> exp_bool_b
%type<vd> exp_bool_s


//Delimitadores
%token LLAVE_A LLAVE_C PARENTESIS_A PARENTESIS_C
%token CORCHETE_A CORCHETE_C

//Palabras reservadas
%token IF ELSE WHILE FOR INT FLOAT STRING CHAR PRINT
%token INPUT AND OR BOOL STRCMP

//Operadores aritmeticos
%token OP_SUMA OP_RESTA OP_MULT OP_DIV OP_IGUAL

//Operadores logicos
%token OP_MENOR OP_MENORIGUAL OP_MAYOR OP_MAYORIGUAL 
%token OP_COMP_IGUAL OP_NEGACION OP_DISTINTO

//Otros tokens
%token COMA PUNTOYCOMA GUIONBAJO PUNTO COMENTARIO

//Precedencia de operadores 

%left AND OR
%left OP_MENOR OP_MENORIGUAL OP_MAYOR OP_MAYORIGUAL OP_DISTINTO OP_COMP_IGUAL
%left OP_NEGACION

%left OP_SUMA OP_RESTA
%left OP_MULT OP_DIV
 

%start codigo

%%

codigo: 
        | '\n'
        | codigo linea
        | codigo COMENTARIO
        | linea
;

linea:    PRINT PARENTESIS_A cadena_io PARENTESIS_C PUNTOYCOMA              {printf("%s\n", $3);}
        | ID OP_IGUAL INPUT PARENTESIS_A cadena_io PARENTESIS_C PUNTOYCOMA 
        | INT ID OP_IGUAL exp_ari PUNTOYCOMA                      {aux = (int)$4; guardar($2, intdup(&aux), 2);}
        | FLOAT ID OP_IGUAL exp_ari PUNTOYCOMA                    {guardar($2, floatdup(&$4), 3);}
        | STRING ID OP_IGUAL CADENA PUNTOYCOMA                    {guardar($2, strdup($4), 1);}
        | CHAR ID OP_IGUAL CARACTER PUNTOYCOMA                    {guardar($2, chardup(&$4), 1);}
        | BOOL ID OP_IGUAL TRUE PUNTOYCOMA                        {guardar($2, intdup(&$4), 4);}
        | BOOL ID OP_IGUAL FALSE PUNTOYCOMA                       {guardar($2, intdup(&$4), 4);}
        | ID OP_IGUAL exp_ari PUNTOYCOMA                          {actualizar($1, iof_p($3), iof($3));}
        | ID OP_IGUAL CADENA PUNTOYCOMA                           {actualizar($1, strdup($3), 1);}
        | ID OP_IGUAL CARACTER PUNTOYCOMA                         {actualizar($1, chardup(&$3), 1);}
        | ID OP_IGUAL TRUE PUNTOYCOMA                             {actualizar($1, intdup(&$3), 4);}
        | ID OP_IGUAL FALSE PUNTOYCOMA                            {actualizar($1, intdup(&$3), 4);}
        | IF PARENTESIS_A exp_bool PARENTESIS_C LLAVE_A codigo LLAVE_C
        | IF PARENTESIS_A exp_bool PARENTESIS_C LLAVE_A codigo LLAVE_C ELSE LLAVE_A codigo PUNTOYCOMA LLAVE_C
        | WHILE PARENTESIS_A exp_bool PARENTESIS_C LLAVE_A codigo LLAVE_C
        | op_inc_dec
        | FOR PARENTESIS_A ID OP_IGUAL exp_ari PUNTOYCOMA exp_bool PUNTOYCOMA op_inc_dec PARENTESIS_C LLAVE_A codigo PUNTOYCOMA LLAVE_C
				| exp_bool			{printf("Resultado: %i\n", $1);}
				
;

op_inc_dec:   ID OP_SUMA OP_SUMA PUNTOYCOMA               { inc_dec($1, 1); }
            | ID OP_RESTA OP_RESTA PUNTOYCOMA             { inc_dec($1, 0); }
;

valor:    ENTERO
        | REAL
        | CADENA
;

cadena_io:  CADENA                               { $$ = cad_print($1);}
          | ID                                   { $$ = iftos($1);}
          | cadena_io COMA cadena_io             { $$ = strcat($1,$3);}
;

exp_ari:  ENTERO                                 { $$ = $1; }
        | ID                                     { $$ = obtNum($1);}
        | REAL                                   { $$ = $1;}
        | exp_ari OP_SUMA exp_ari                { $$ = $1 + $3; }
        | exp_ari OP_RESTA exp_ari               { $$ = $1 - $3; }
        | exp_ari OP_MULT exp_ari                { $$ = $1 * $3; }
        | exp_ari OP_DIV exp_ari                 { $$ = $1 / $3; }
        | PARENTESIS_A exp_ari PARENTESIS_C      { $$ = $2; }
;

exp_bool:  	exp_bool_s                             { $$ = *(int*)$1; }
					|	exp_bool_b                             { $$ = (int)$1; }
          | exp_bool AND exp_bool                  { $$ = $1 && $3; }
          | exp_bool OR  exp_bool                  { $$ = $1 || $3; }
          | PARENTESIS_A exp_bool PARENTESIS_C     { $$ = $2; }
;


exp_bool_s:   CADENA
            | ID                                   { $$ = bool_s_id($1); }
						| STRCMP PARENTESIS_A exp_bool_s COMA exp_bool_s PARENTESIS_C		{aux = cad_bool($3, $5); $$ = &aux;}
            | PARENTESIS_A exp_bool_s PARENTESIS_C { $$ = $2; }
;

exp_bool_b: TRUE                                 	 { $$ = $1; }  
          | exp_ari                              	 { $$ = $1; }
          | CARACTER                             	 { $$ = (int)$1; }
          | FALSE                                	 { $$ = $1; }
          | exp_bool_b OP_MAYOR exp_bool_b         { $$ = $1 >  $3; }
          | exp_bool_b OP_MAYORIGUAL exp_bool_b    { $$ = $1 >= $3; }
          | exp_bool_b OP_MENOR exp_bool_b         { $$ = $1 <  $3; }
          | exp_bool_b OP_MENORIGUAL exp_bool_b    { $$ = $1 <= $3; }
          | exp_bool_b OP_COMP_IGUAL exp_bool_b    { $$ = $1 == $3; }
          | exp_bool_b OP_DISTINTO exp_bool_b      { $$ = $1 != $3; }
          | PARENTESIS_A exp_bool_b PARENTESIS_C   { $$ = $2;}
;

%%

int main(){
  yyin = fopen("codigo.txt", "r");
  system("clear");
  printf("-------------- Analizador semantico  ------------\n\nResultado:\n");
  if(yyparse()==0)
    {
        printf("\nCodigo compilado correctamente \n");
    }
    else
    {
        printf("\nError de sintaxis :(\n");
    }
  //imprimir();
  noUsadas();
  return 0;
}

void guardar(char* clave, void* valor, int tipo) {
  if(count != SIZE){
    for (int i = 0; i < count; i++){
      if (strcmp(dic[i].clave,clave) == 0){
        printf("El identificador %s ya se habia declarado previamente\n", clave);
        exit(1);
      }
  }
    dic[count].clave = clave; 
    dic[count].valor = valor;
    dic[count].tipo = tipo;
    count++;
  }
  else{
    printf("Memoria llena.\n");
  }
}

void actualizar(char* clave, void* valor, int tipo){
  int index = buscar(clave);

  if(index == -1){
    printf("Variable %s no declarada\n", clave);
    exit(1);
  }

  if (dic[index].tipo != tipo){
    printf("Nuevo valor de %s no compatible\n", clave);
    exit(1);
  }

  int aux = strlen(dic[index].valor);
  int temp = strlen(valor);

  if ((aux == 1 && temp > aux)) {
    printf("Nuevo valor de %s no compatible\n", clave);
    exit(1);
  }

  dic[index].valor = valor;

}

void inc_dec(char* id, int bandera){
  int index = buscar(id);

  if(index == -1){
    printf("Variable %s no declarada\n", id);
    exit(1);
  }

  if(dic[index].tipo == 1 || dic[index].tipo == 4){
    printf("Operador no valido con tipo de datos string/bool\n");
    exit(1);
  }

  if(bandera){
		if(dic[index].tipo == 2){
	    int x = *(int*)dic[index].valor + 1;
	    dic[index].valor = intdup(&x);
	  }
	
	  if(dic[index].tipo == 3){
	    float y = *(float*)dic[index].valor + 1;
	    dic[index].valor = floatdup(&y);
	  }
	}
	else{
		if(dic[index].tipo == 2){
	    int x = *(int*)dic[index].valor - 1;
	    dic[index].valor = intdup(&x);
	  }
	
	  if(dic[index].tipo == 3){
	    float y = *(float*)dic[index].valor - 1;
	    dic[index].valor = floatdup(&y);
	  }
	}
    
}

int buscar(char * id){
  int i;

  for(i = 0; i != count; i++){
    if(strcmp(id,dic[i].clave)==0){
      dic[i].bandera = 1;
      return i;
    }
  }

  return -1;
}

float obtNum(char * id){
  int index = buscar(id);

  if(index == -1){
     printf("Aun no se ha declarado la variable %s\n", id);
     exit(1);
  }

  if(dic[index].tipo == 4){
    printf("Variable bool %s no apta para operaciones aritmeticas\n", id);
    exit(1);
  }

	if(dic[index].tipo == 1){
		int num = strlen(strdup(dic[index].valor));
		if(num == 1)
			return (float)(*(char*)dic[index].valor);

		printf("Variable string %s no apta para operaciones aritmeticas\n", id);
    exit(1);
	}

  if(dic[index].tipo == 2)
    return (float)(*(int*)dic[index].valor);

  return *(float*)dic[index].valor;
}

int cad_bool(char* cadena, char* cadena2){
  int index = strcmp(cadena, cadena2);

  if(index != 0)
    return 0;

  return 1;
}

char* bool_s_id(char* id){
	int index = buscar(id);

	if(index == -1){
     printf("Aun no se ha declarado la variable %s\n", id);
     exit(1);
  }

	if(dic[index].tipo != 1){
		printf("strcmp no acepta variables de tipo int/float/bool\n");
		exit(1);
	}

  int aux;
  aux = strlen(strdup(dic[index].valor));
  if (aux == 1){
		printf("strcmp no acepta variables de tipo char\n");
		exit(1);
	}

  return strdup(dic[index].valor);
}

char* cad_print(char* cadena){
  char aux[128];
  int i;
  int count = 0;
	int size = strlen(cadena);

	if(size == 1){
		return strdup(cadena);	
	}

	for(i = 1; i < strlen(cadena)-1; i++){
    aux[count] = cadena[i];
    count++;
  }

	aux[count] = '\0';
  
	return strdup(aux);
}

int iof(float num){ 
  int x;
  x = num;

  if(num - x)
    return 3;

  return 2;
}

void* iof_p(float num){
  int x;
  x = num;

  if(num - x)
    return floatdup(&num);

  return intdup(&x);
}

int * intdup(int* num){
   int * p = malloc(sizeof(int));
   memcpy(p, num, sizeof(int));
   return p;
}

float * floatdup(float* num){
   float * p = malloc(sizeof(float));
   memcpy(p, num, sizeof(float));
   return p;
}

char * chardup(char* cad){
   char * p = malloc(sizeof(char));
   memcpy(p, cad, sizeof(char));
   return p;
}

char* itoa(int numero) {
  char str[255];
  sprintf(str, "%i", numero);
  return strdup(str);
}

char* ftoa(float numero){
  char str[255];
  sprintf(str, "%f", numero);
  return strdup(str);
}

char* iftos(char* id){
  int index = buscar(id);

  if(index == -1){
     printf("Aun no se ha declarado la variable %s\n", id);
     exit(1);
  }

  if(dic[index].tipo == 2)
    return itoa(*(int*)dic[index].valor);

  if(dic[index].tipo == 3)
    return ftoa(*(float*)dic[index].valor);

	return cad_print(dic[index].valor);  
}

void imprimir(){
  int i;
  int y;
  printf("{\n");
  for(i = 0; i != count; i++){
    printf("%s : ", dic[i].clave);
    y = dic[i].tipo;
    switch(y){
      case 1:
        printf("\t %s \n", strdup(dic[i].valor));
        break;
      case 2:
        printf("\t %i \n", *(int*)dic[i].valor);
        break;
      case 3:
        printf("\t %f \n", *(float*)dic[i].valor);  
        break;
      case 4:
        if(*(int*)dic[i].valor == 1)
          printf("\t true \n");
        else
          printf("\t false \n");
        break;
    }
  }
  printf("}\n");
}

void noUsadas(){
  int warning = 0;
  char w_noUsadas[100] = "Aviso! variables no usadas: ";
  for (int i = 0; i != count; i++){
    if (dic[i].bandera == 0){
      warning = 1;
      strcat(w_noUsadas,dic[i].clave);
      strcat(w_noUsadas,", ");
    }
  }
  if (warning == 1){
    printf("%s \n",w_noUsadas);
  }
}


void yyerror(const char* s) {
    printf("Error en la compilacion del codigo :( %s\n", s);
    exit(1);
}
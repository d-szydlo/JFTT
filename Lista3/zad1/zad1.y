%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#define P 1234577

int yylex();
int yyerror(char *s);
int err = 0;
char *buffer = "";
int buf_size = 1;

int neg(int a){
	return P-a;
}

int add(int a, int b){
	return (a%P + b%P)%P;
}

int sub(int a, int b){
	return add(a, neg(b));
}

int mul(long long int a, long long int b){
	unsigned long long int x = (a%P)*(b%P);
	return x%P;
}

int mult_inv(int a, int b, int *x, int *y){
	if (a == 0){
		*x = 0;
		*y = 1;
		return b;
	}

	int h1, h2;
	int g = mult_inv(b%a, a, &h1, &h2);

	*x = h2 - (b/a)*h1;
	*y = h1;
	return g;
}

int divide(int a, int b){
	int x, y;
	mult_inv(b, P, &x, &y);
	if (x < 0){
		x += P;
	}
	return mul(a, x);
}


int power(unsigned long long int a, unsigned long long int b){
	unsigned long long int r = 1;
	a = a%P;
	while (b > 0){
		if (b%2 == 1){
			r = (r*a)%P;
		}
		b /= 2;
		a = (a*a)%P;
	}
	return r;
}

void concat(char** buffer, char* a){
	if (strlen(a) + strlen(*buffer) < buf_size){
		strcat(*buffer, a);
	}
	else{
		buf_size += strlen(a);
		buf_size *= 2;
		char *new_buff = (char*) malloc((buf_size*sizeof(char)));
		strcpy(new_buff, *buffer);
		strcat(new_buff, a);
		*buffer = new_buff;
	}
}

%}
%token NUM
%token '('
%token ')'
%left '-' '+'
%left '*' '/' '%'
%nonassoc '^'
%nonassoc NEXP
%precedence NEG
%%
input:
	%empty
|	input line
;
line:
	'\n'
|	exp	'\n'	{ 
					if (err == 0) {
						printf("%s\n", buffer);
						printf("Wynik: %d\n", $1);
					} 
					else {
						err = 0;
					}
					buffer = "";
					buf_size = 1;
				}
|	error '\n'	{ buffer = ""; buf_size = 1; }
;
exp:
	NUM					{ $$ = $1%P; char num[9]; snprintf(num, 10, "%d ", $$); concat(&buffer, num);}
|	exp '+' exp 		{ $$ = add($1, $3); concat(&buffer, "+ ");}
|	exp '-' exp 		{ $$ = sub($1, $3); concat(&buffer, "- ");}
|	exp '*'	exp 		{ $$ = mul($1, $3); concat(&buffer, "* ");}
|   exp '/' exp			{ 
							if ($3 != 0){
								$$ = divide($1, $3);
								concat(&buffer, "/ ");
							}
							else{
								yyerror("Nie mozna dzielic przez 0!");
								err = 1;
							}
						}
|   exp NEXP exp		{ 
							$$ = power($1, (P-1)-$3);
							char num[9];
							snprintf(num, 10, "%d ", $3);
							*(buffer+strlen(buffer)-strlen(num)) = '\0';
							snprintf(num, 10, "%d ", (P-1)-$3);
							concat(&buffer, num);
							concat(&buffer, "^ ");
						}
|	exp '^' exp			{ $$ = power($1, $3); concat(&buffer, "^ ");}
|	'-' exp	%prec NEG 	{ 
							$$ = neg($2);
							char num[9];
							snprintf(num, 10, "%d ", $2);
							*(buffer+strlen(buffer)-strlen(num)) = '\0';
							snprintf(num, 10, "%d ", $$);
							concat(&buffer, num);
						}
|   '(' exp ')'			{ $$ = $2; }
;
%%

int yyerror(char *s)
{
	fprintf (stderr, "%s\n", s);
}

int main()
{
    return yyparse();
}


%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
int yywrap();
int yylex();

int id = -1;
int stack_size = 50;
int s[50];

bool overflow = false;
bool underflow = false;

bool err = false;

void push(int val){
    id++;
    if (id == stack_size){
        overflow = true;
        id--;
    }
    else {
        s[id] = val;
    }
}

int pop(){
    if (id == -1){
        underflow = true;
        return -1;
    }
    else {
        id--;
        return s[id+1];
    }
}

%}
%%
[0-9]+"."[0-9]+ {
    if (!err){
        printf("To nie jest liczba całkowita %s\n", yytext);
        err = true;
    }
}
[-]?[0-9]+  {
    if (!err){
        push(atoi(yytext));
        if (overflow){
            printf("Przepelnienie stosu\n");
            err = true;
        }
    }
}
"+" {
    if (!err){
        int b = pop();
        int a = pop();
        if (underflow){
            printf("Za mala liczba argumentow\n");
            err = true;
        }
        else {
            push(a+b);
        }
    }
}
"-" {
    if (!err){
        int b = pop();
        int a = pop();
        if (underflow){
            printf("Za mala liczba argumentow\n");
            err = true;
        }
        else {
            push(a-b);
        }
    }
}
"*" {
    if (!err){
        int b = pop();
        int a = pop();
        if (underflow){
            printf("Za mala liczba argumentow\n");
            err = true;
        }
        else {
            push(a*b);
        }
    }
}
"/" {
    if (!err){
        int b = pop();
        int a = pop();
        if (underflow){
            printf("Za mala liczba argumentow\n");
            err = true;
        }
        else if (b == 0){
            printf("Nie mozna dzielic przez 0 :c\n");
            err = true;
        } else {
            push(a/b);
        }
    }
}
"%" {
    if (!err){
        int b = pop();
        int a = pop();
        if (underflow){
            printf("Za mala liczba argumentow\n");
            err = true;
        }
        else if (b == 0){
            printf("Nie mozna dzielic przez 0 :c\n");
            err = true;
        } else {
            push(a%b);
        }
    }
}
"^" {
    if (!err){
        int b = pop();
        int a = pop();
        if (underflow){
            printf("Za mala liczba argumentow\n");
            err = true;
        }
        else {
            if (b < 0) {
                printf("Ujemna potega\n");
                err = true;
            }
            int p = 1;
            for (int i = 0; i < b; i++){
                p *= a;
            }
            push(p);
        }
    }
}
\n {
    if (!err){
        int result = pop();
        if (id != -1){
            printf("Za mala liczba operatorow\n");
        }
        else {
            printf("Wynik: %d\n", result);
        }
    }
    id = -1;
    err = false;
    underflow = false;
    overflow = false;
}
" " ;
[^0-9 \t\n] {
    if (!err){
        printf("To jest nieprawidłowy znak: %s\n", yytext);
        err = true;
    }
}
%%
int yywrap() {
    return 1;
}
int main(){
    return yylex();
}


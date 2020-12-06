%{
#include <stdio.h>
int yywrap();
int yylex();
int lines = 0;
int words = 0;
%}
%%
^[ \t]*\n*      ;
[ \t]+$         ;
\\\n      ;
[ \t]+          {printf(" ");}
[^ \t\n\\]+     {printf("%s", yytext); words++;}
\n              {lines++; printf("\n");}
%%
int yywrap() {
    printf("---\nlinie: %d slowa: %d", lines, words);
    return 1;
}
int main(){
    return yylex();
}

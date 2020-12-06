%{
#include <stdio.h>
int yywrap();
int yylex();
%}
%s single_line_a
%s single_line_q
%s multiple_line_a
%s multiple_line_q
%%
<INITIAL>{
    \'     {printf("%s", yytext); BEGIN(single_line_a);}
    \"     {printf("%s", yytext); BEGIN(single_line_q);}
    \'{3}  {printf("%s", yytext); BEGIN(multiple_line_a);}
    \"{3}  {printf("%s", yytext); BEGIN(multiple_line_q);}
    "#".*   ;
}
<single_line_a>{
    \\{2}   {printf("%s", yytext);}
    \\\'   {printf("%s", yytext);}
    \'     {printf("%s", yytext); BEGIN(INITIAL);}
}
<single_line_q>{
    \\{2}   {printf("%s", yytext);}
    \\\"   {printf("%s", yytext);}
    \"     {printf("%s", yytext); BEGIN(INITIAL);}
}
<multiple_line_a>{
    \\{2}   {printf("%s", yytext);}
    \\\'{3}   {printf("%s", yytext);}
    \'{3}     {printf("%s", yytext); BEGIN(INITIAL);}
}
<multiple_line_q>{
    \\{2}   {printf("%s", yytext);}
    \\\"{3}   {printf("%s", yytext);}
    \"{3}     {printf("%s", yytext); BEGIN(INITIAL);}
}
%%
int yywrap() {
    return 1;
}
int main(){
    return yylex();
}

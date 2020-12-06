%{
#include <stdio.h>
#include "zad1.tab.h"
int yylex(void);
%}
%s com
%%
<INITIAL>{
    ^#                  {BEGIN(com);}
    [[:blank:]]+        ;
    \\\n                ;
    \^" "?\-            { return NEXP; }
    [+\-*/\^\(\)]|\n    { return *yytext; }
    [0-9]+              { yylval = atoi(yytext); return NUM; }
    .                   ;
}
<com>{
    .*\\\n  ;
    .*\n    { BEGIN(INITIAL);}
}

%%

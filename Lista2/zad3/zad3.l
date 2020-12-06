%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
int yywrap();
int yylex();
bool keep_doc = false;
%}
%s str
%s single_line
%s doc_single
%s multiple_line
%s doc_multiple
%%
<INITIAL>{
    \"              {printf("%s", yytext); BEGIN(str);}
    ("///")|("//!") {if (keep_doc) {printf("%s", yytext);} BEGIN(doc_single);}
    ("/**")|("/*!") {if (keep_doc) {printf("%s", yytext);} BEGIN(doc_multiple);}
    "//"            {BEGIN(single_line);}
    "/*"            {BEGIN(multiple_line);}
}
<str>{
    \\{2}  {printf("%s", yytext);}
    \\\"   {printf("%s", yytext);}
    \"     {printf("%s", yytext); BEGIN(INITIAL);}
}
<single_line>{
    \\{2}   ;
    .*\\    ;
    .*      {BEGIN(INITIAL);}
}
<doc_single>{
    \\{2}   {if (keep_doc) {printf("%s", yytext);}}
    .*\\    {if (keep_doc) {printf("%s", yytext);}}
    .*      {if (keep_doc) {printf("%s", yytext);} BEGIN(INITIAL);}
}
<multiple_line>{
    .*"*/" {BEGIN(INITIAL);}
    .    ;
}
<doc_multiple>{
    .*"*/" {if (keep_doc) {printf("%s", yytext);} BEGIN(INITIAL);}
    .      {if (keep_doc) {printf("%s", yytext);}}
}
%%
int yywrap() {
    return 1;
}
int main(int argc, char** argv){
    if (argc > 1 && strcmp("-d", argv[1]) == 0){
        keep_doc = true;
    }
    return yylex();
}


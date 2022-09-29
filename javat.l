%option noyywrap

%{
#include <stdio.h>
#define YY_DECL int yylex()
#include "javat.tab.h"
%}

%%
[ \t]	; // ignore all space
"public" { return PUBLIC; }
"private" { return PRIVATE; }
"class" { return CLASS; }
[A-Za-z_] { yylval.string = strdup(yytext); return LETTER; }
[A-Za-z_]+[A-Za-z0-9_$]* { yylval.string = strdup(yytext); return WORD; }
[0-9]+\.[0-9]+ 	{ yylval.floating = atof(yytext); return FLOAT; }
[0-9]+[A-Za-z_]+[A-Za-z0-9_$]* { return DISALLOWED_INDENTIFIER; }
[0-9]+		{ yylval.number = atoi(yytext); return INT; }
";"		{ return SEMICOLON; }
"+"		{ return ADD; }
"-"		{ return SUBT; }
"*"		{ return MULT; }
"/"		{ return DIV; }
"("		{ return LPAR; }
")"		{ return RPAR; }
"{"		{ return LBRACE; }
"}"		{ return RBRACE; }
\"""	{ return QUOTE; }
"="     { return EQUALS; }
"\n"    { return NEW; }
%%
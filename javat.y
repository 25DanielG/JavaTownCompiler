%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyparse();
void yyerror(const char* s);
%}

%union {
	int number;
	float floating;
	char* string;
}

%token<number> INT
%token<floating> FLOAT
%token<string> WORD LETTER DISALLOWED_INDENTIFIER
%token ADD SUBT MULT DIV LPAR RPAR SEMICOLON DONE EQUALS PUBLIC PRIVATE CLASS
%token LBRACE RBRACE QUOTE NEW

%type<number> expression
%type<floating> mixed_expression

%start prob

%%

prob:
	| var_def
	| var_def prob
	| class_definition
	| NEW { printf("New line\n"); }
;

var_def:
	| WORD EQUALS quoted_string SEMICOLON NEW { printf("Str = Str\n"); }
	| WORD EQUALS expression SEMICOLON NEW { printf("Str = Exp\n"); }
	| WORD EQUALS mixed_expression SEMICOLON NEW { printf("Str = Mixed_Exp\n"); }
	| LETTER EQUALS quoted_string SEMICOLON NEW { printf("Str = Str\n"); }
	| LETTER EQUALS expression SEMICOLON NEW { printf("Str = Exp\n"); }
	| LETTER EQUALS mixed_expression SEMICOLON NEW { printf("Str = Mixed_Exp\n"); }

class_definition:
	| PUBLIC CLASS WORD LBRACE { printf("Public class\n"); }
	| PRIVATE CLASS WORD LBRACE { printf("Private class\n"); }
	| CLASS WORD LBRACE

mixed_expression: FLOAT                 		 { $$ = $1; }
	| mixed_expression ADD mixed_expression	 { $$ = $1 + $3; }
	| mixed_expression SUBT mixed_expression	 { $$ = $1 - $3; }
	| mixed_expression MULT mixed_expression { $$ = $1 * $3; }
	| mixed_expression DIV mixed_expression	 { $$ = $1 / $3; }
	| LPAR mixed_expression RPAR		 { $$ = $2; }
	| expression ADD mixed_expression	 	 { $$ = $1 + $3; }
	| expression SUBT mixed_expression	 	 { $$ = $1 - $3; }
	| expression MULT mixed_expression 	 { $$ = $1 * $3; }
	| expression DIV mixed_expression	 { $$ = $1 / $3; }
	| mixed_expression ADD expression	 	 { $$ = $1 + $3; }
	| mixed_expression SUBT expression	 	 { $$ = $1 - $3; }
	| mixed_expression MULT expression 	 { $$ = $1 * $3; }
	| mixed_expression DIV expression	 { $$ = $1 / $3; }
	| expression DIV expression		 { $$ = $1 / (float)$3; }
	| FLOAT { $$ = $1; }
;

expression: INT				{ $$ = $1; }
	| expression ADD expression	{ $$ = $1 + $3; }
	| expression SUBT expression	{ $$ = $1 - $3; }
	| expression MULT expression	{ $$ = $1 * $3; }
	| LPAR expression RPAR		{ $$ = $2; }
	| INT { $$ = $1; }
;

quoted_string:
	| QUOTE WORD QUOTE
%%

int main() {
	while(!feof(stdin))
		yyparse();
	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
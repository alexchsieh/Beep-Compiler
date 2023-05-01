%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;


void yyerror(const char* s);
%}

%token INTEGER BREAK CONTINUE IF ELSE WHILE FOR READ WRITE COMMENT RETURN DIGIT ALPHA  
%token ADDITION SUBTRACTION MULTIPLICATION MOD DIVISION
%token OPEN_PARAMETER CLOSE_PARAMETER OPEN_BRACKET CLOSE_BRACKET OPEN_SCOPE CLOSE_SCOPE COMMA END_STATEMENT ASSIGN
%token EQUALS_TO NOT_EQUALS_TO LESS_THAN LESS_THAN_OR_EQUAL_TO GREATER_THAN GREATER_THAN_OR_EQUAL_TO


%start program 


%%
program: function ;

function: function ALPHA END_STATEMENT
    | OPEN_PARAMETER declaration END_STATEMENT CLOSE_PARAMETER
    | OPEN_SCOPE statement CLOSE_SCOPE
    ;

declaration: INTEGER ALPHA END_STATEMENT
    | INTEGER ALPHA OPEN_BRACKET NUMBER CLOSE_BRACKET END_STATEMENT
    ;

statement: variable ASSIGN expr END_STATEMENT
    | IF OPEN_PARAMETER variable comp variable CLOSE_PARAMETER OPEN_SCOPE statement END_STATEMENT CLOSE_SCOPE
    | IF OPEN_PARAMETER variable comp variable CLOSE_PARAMETER OPEN_SCOPE statement END_STATEMENT CLOSE_SCOPE ELSE OPEN_SCOPE statement END_STATEMENT CLOSE_SCOPE 
    | WHILE OPEN_PARAMETER variable CLOSE_PARAMETER OPEN_SCOPE statement END_STATEMENT CLOSE_SCOPE
    | READ variable
    | WRITE variable
    | CONTINUE
    | BREAK
    | RETURN expr 
    ;

bool-expr: NOT bool-expr
    | expr comp expr
    ;

comp: EQUALS_TO
    | NOT_EQUALS_TO
    | GREATER_THAN
    | LESS_THAN
    | GREATER_THAN_OR_EQUAL_TO
    | LESS_THAN_OR_EQUAL_TO 
    ;
    
expr: mulop ADDITION mulop
    | mulop SUBTRACTION mulop
    ;

mulop: term MULTIPLICATION term
    | term DIVISION term
    | term MOD term
    ;

term: variable
    | NUMBER
    | OPEN_PARAMETER expr CLOSE_PARAMETER
    | ALPHA
    | ALPHA OPEN_PARAMETER expr CLOSE_PARAMETER
    ;

variable: ALPHA
    | ALPHA OPEN_BRACKET expr CLOSE_BRACKET
    ;

assign: variable ASSIGN expr ';';
%%

int main(int argc, char* argv[]) {
  ++argv;
  --argc;
  
  if(argc>0) 
  {
    yyin = fopen(argv[0], "r");
  }
  else 
  {
    yyin = stdin;
  }
  
  yyparse();


  printf("Hello World!\n");
  return 0; 
}

void yyerror(const char* s) {
  fprintf(stderr, "Parse error: %s. Parenthesis are not balanced!\n", s);
  exit(1);
}


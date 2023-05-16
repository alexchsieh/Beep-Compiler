%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <vector>
#include "y.tab.h"
extern FILE* yyin;
extern int line_number;
extern int column_number; 
extern int yylex(void);

void yyerror(const char * s) {
    printf("Error: On line %d, column %d: %s \n", line_number, column_number, s);
}

char *identToken;
int numberToken;
int count_names = 0;

enum Type { Integer, Array };

struct CodeNode {
        std::string code;
        std::string name;
};

struct Symbol {
  std::string name;
  Type type;
};

struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

Function *get_function() {
  int last = symbol_table.size()-1;
  if (last < 0) {
    printf("***Error. Attempt to call get_function with an empty symbol table\n");
    printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
    printf("calling 'find' or 'add_variable_to_symbol_table'");
    exit(1);
  }
  return &symbol_table[last];
}


bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

%}

%union {

        char *op_val;
        struct CodeNode *node;
}


%error-verbose
%start prog_start

%token WRITE READ WHILE BREAK CONTINUE IF ELSE INSERT EXTRACT RETURN INTEGER
%token ALPHA DIGIT
%token ADDITION SUBTRACTION MULTIPLICATION DIVISION MOD ASSIGN
%token EQUALS_TO LESS_THAN GREATER_THAN LESS_THAN_OR_EQUAL_TO GREATER_THAN_OR_EQUAL_TO NOT OPEN_PARAMETER
%token CLOSE_PARAMETER OPEN_SCOPE CLOSE_SCOPE OPEN_BRACKET CLOSE_BRACKET END_STATEMENT COMMA ENDL
%type <node> functions
%type <node> function
%type <node> statements
%type <node> statement
%type <node> int_declaration
%type <node> array_declaration
%type <node> assign_statement
%type <node> else_statement
%type <node> add_expression
%type <node> args
%type <op_val> ALPHA

%%
prog_start: 
        %empty /* epsilon */ 
        {} 
        | functions 
        {
               CodeNode *node = $1; 
                //printf("All generated code: \n");
                printf("%s\n", node->code.c_str());      

        }
        ;

functions: 
        function 
        {
                CodeNode *func = $1;
                std::string code = func->code;
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
        }
        | function functions 
        {
                CodeNode *func = $1;
                CodeNode *funcs = $2;
                std::string code = func->code + std::string("\n") + funcs->code;
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node;
        }
        ;

function: 
        INTEGER ALPHA OPEN_PARAMETER args CLOSE_PARAMETER OPEN_SCOPE statements CLOSE_SCOPE 
        {
                std::string func_name = $2;
                CodeNode *params = $4;
                CodeNode *stmts = $7;
                std::string code = std::string("func ") + func_name + std::string("\n");
                //code += params->code;
                //code += stmts->code;
                code += std::string("endfunc");
                
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node; 
        }
	;

statements: 
        statement statements 
        {
                CodeNode *stmt1 = $1;
                CodeNode *stmt2 = $2;
                CodeNode *node = new CodeNode;
                node->code = stmt1->code + stmt2->code;
                $$ = node; 
        }
        | %empty 
        {
                CodeNode *node = new CodeNode;
                $$ = node;
        }
        ;

statement: 
        int_declaration 
        {
                CodeNode *int_declar = $1;
                CodeNode *node = new CodeNode;
                node->code = int_declar->code;
                $$ = node;
        }
        | array_declaration 
        {

        }
        | print_statement 
        {

        }
        | input_statement 
        {

        }
        | if_statement 
        {

        }
        | while_statement 
        {

        }
        | break_statement 
        {

        }
        | continue_statement 
        {

        }
        | function_call 
        {

        }
        | return_statement 
        {

        }
        | assign_int 
        {

        }
        | assign_array 
        {

        }
        ;

int_declaration: 
        INTEGER ALPHA assign_statement END_STATEMENT 
        {
                CodeNode *assign_statement = $3;
                std::string value = $2;
                Type t = Integer;
                add_variable_to_symbol_table(value, t);

                std::string code = std::string(". ") + value + std::string("\n");
                CodeNode *node = new CodeNode;
                node->code = assign_statement->code;
                node->code = code;
                $$ = node;
        }
        ;

array_declaration: 
        INTEGER ALPHA OPEN_BRACKET add_expression CLOSE_BRACKET assign_statement END_STATEMENT 
        {
                std::string value = $2;
                CodeNode *add_exp = $4;
                std::string code = std::string("array ") + value + std::string("\n");
                code += add_exp->code;
                code += std::string("end array\n");
                
                CodeNode *node = new CodeNode;
                node->code = code;
                $$ = node; 
        }
	;

assign_statement: 
        %empty 
        {
                CodeNode *node = new CodeNode;
                $$ = node;
        }
        | ASSIGN add_expression 
        {

        }
        ;

print_statement: 
        WRITE EXTRACT binary_expression END_STATEMENT 
        {

        }
        | 
        WRITE EXTRACT binary_expression EXTRACT ENDL END_STATEMENT 
        {

        }
        ;

input_statement: 
        READ INSERT ALPHA END_STATEMENT 
        {
                
        }
        ;

if_statement: 
        IF expression OPEN_SCOPE statements CLOSE_SCOPE else_statement 
        {
                
        }
        ;

else_statement: 
        ELSE OPEN_SCOPE statements CLOSE_SCOPE 
        {

        }
        | %empty 
        {
                CodeNode *node = new CodeNode;
                $$ = node;
        }
        ;

while_statement: 
        WHILE OPEN_PARAMETER binary_expression CLOSE_PARAMETER OPEN_SCOPE statements CLOSE_SCOPE 
        {

        }
        ;

break_statement: 
        BREAK END_STATEMENT 
        {

        }
        ;  

continue_statement: 
        CONTINUE END_STATEMENT 
        {

        }
        ;

expression: 
        DIGIT 
        {

        }    
        | OPEN_PARAMETER binary_expression CLOSE_PARAMETER 
        {

        }  
        | ALPHA 
        {

        }
        | ALPHA OPEN_BRACKET add_expression CLOSE_BRACKET 
        {

        }
        | function_call 
        {

        }
        ;

binary_expression: 
        add_expression 
        {
        
        }
        | binary_expression EQUALS_TO add_expression 
        {
                
        }
        | binary_expression NOT add_expression 
        {
                
        }
        | binary_expression LESS_THAN add_expression 
        {
                
        }
        | binary_expression LESS_THAN_OR_EQUAL_TO add_expression 
        {

        }
        | binary_expression GREATER_THAN add_expression 
        {

        }
        | binary_expression GREATER_THAN_OR_EQUAL_TO add_expression 
        {

        }
        ;

add_expression: 
        mult_expression 
        {

        }
        | add_expression ADDITION mult_expression 
        {
        
        }
        | add_expression SUBTRACTION mult_expression 
        {

        }
        ;

mult_expression: 
        base_expression 
        {

        }
        | mult_expression MULTIPLICATION base_expression 
        {

        }
        | mult_expression DIVISION base_expression 
        {

        }
        | mult_expression MOD base_expression 
        {

        }
        ;

base_expression: 
        expression 
        {

        }
        ;

assign_int: 
        ALPHA ASSIGN add_expression END_STATEMENT 
        {
                
        }
        ;

assign_array: 
        ALPHA OPEN_BRACKET DIGIT CLOSE_BRACKET ASSIGN add_expression END_STATEMENT 
        {
                
        }
        ;

function_call: 
        ALPHA OPEN_PARAMETER param CLOSE_PARAMETER 
        {
        
        }

param: 
        binary_expression params 
        {

        }
        | %empty 
        {
        
        }
        ;

params: 
        COMMA binary_expression params 
        {
                
        }
        | %empty 
        {
                
        }
        ;

args: 
        arg repeat_args 
        {

        } 
        | %empty 
        {

        }
        ;

repeat_args: 
        COMMA arg repeat_args 
        {
                
        }
        | %empty 
        {
                
        }
        ;

arg: 
        INTEGER ALPHA 
        {
                
        }
        ;

return_statement: 
        RETURN return_expression END_STATEMENT 
        {
                
        }
        ;

return_expression: 
        add_expression 
        {
                
        }
        | %empty 
        {

        }
        ;
%%

int main(int argc, char** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL)
			yyin = stdin;
	}
	else {
		yyin = stdin;
	}
	yyparse();

        return 1;
}
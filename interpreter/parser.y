/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<float> symbols;
std::vector <float> paramVec;
float result;
int caseVal=0;
float caseVar=0;
%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	float value;
}

%token <iden> IDENTIFIER
%token <value> BOOL_LITERAL INT_LITERAL REAL_LITERAL 
%token <oper> ADDOP MULOP RELOP REMOP EXPOP
%token OROP
%token ANDOP
%token NOTOP
%token BEGIN_  END ENDREDUCE FUNCTION IS REDUCE RETURNS ARROW
%token BOOLEAN INTEGER REAL
%token IF THEN ELSE ENDIF CASE WHEN ENDCASE OTHERS

%type <value> body statement_  parameters parameter statement reductions expression relation term
	factor primary andexp remainder notst exponent case_ case 
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER possibleparam RETURNS type ';'|
	error';';


possibleparam:
	parameters |
	 ;

parameters: 
	parameter |
	parameters ',' parameter;

parameter: 
	IDENTIFIER ':' type {symbols.insert($1, paramVec.front());
	  paramVec.erase(paramVec.begin());};

optional_variable:
 	optional_variable variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} |
	error ';';

type:
	REAL |
	INTEGER |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression  |
	REDUCE operator reductions ENDREDUCE {$$ = $3;}|
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $<value>2==1?$<value>4:$<value>6; cout<<$2;}|
	CASE expression IS case_ OTHERS ARROW statement_ ENDCASE {$$ = evaluateCase(caseVal,caseVar,$7);};

case_:
	case_ case|
	;
case:
	WHEN INT_LITERAL ARROW statement_ {if($<value>-2==$2){caseVar=$<value>4;caseVal=1;}cout<<caseVar;};

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression OROP andexp {$$ = $1 || $3;}|
	andexp;


andexp:
	andexp ANDOP relation {$$ = $1 && $3;}  |
	relation;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term;

term:
	term ADDOP remainder {$$ = evaluateArithmetic($1, $2, $3);} |
	remainder ;

remainder:
	remainder REMOP factor {$$ = evaluateArithmetic($1, $2, $3);}  |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
	notst EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
		notst;
notst:
	NOTOP primary {$$ = ! $2;} |
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	BOOL_LITERAL | 
	REAL_LITERAL| 
	INT_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	extern vector<float> paramVec;
		
	for(int i=1; i<argc; i++){
		paramVec.push_back(atof(argv[i]));
		cout<<paramVec[i-1]<<endl;;
	}
	firstLine();
	yyparse();
	
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 

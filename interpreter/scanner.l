/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment1 	\/\/.*\n
comment2 	\-\-.*\n
comment	({comment2}|{comment1})

line		[\n]
boolean 	(true|false)?
digit		[0-9]
int			{digit}+
real 		[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?
id1 		([A-Za-z][A-Za-z0-9]*_?)+[A-Za-z0-9][A-Za-z0-9]* 
id3 		{id1}+
id2			[A-Za-z]
id  		({id1}|{id2}|{id3})
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"			{ ECHO; yylval.oper = LESS; return(RELOP); }
">"			{ ECHO; yylval.oper = GREATER; return(RELOP); }
"="			{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="		{ ECHO; yylval.oper = NOTEQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESSEQUAL; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATEQUAL; return(RELOP); }
"+"			{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"			{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"			{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		    { ECHO; yylval.oper = DIVIDE; return(MULOP); }
"**"		{ ECHO; yylval.oper = EXPONENT;return(EXPOP);}
"=>"		{ ECHO; return (ARROW);}
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end			{ ECHO; return(END); }
if 			{ECHO; return (IF);}
endif		{ECHO; return (ENDIF);}
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
real		{ ECHO; return(REAL); }
integer		{ ECHO; return(INTEGER); }
is			{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
case		{ECHO; return (CASE);}
endcase		{ECHO; return (ENDCASE);}
others		{ECHO; return (OTHERS);}
else		{ECHO; return (ELSE);}
then		{ECHO; return (THEN);}
when		{ECHO; return (WHEN);}
and			{ ECHO; return(ANDOP); }
or			{ECHO; return (OROP);}
not			{ECHO; return (NOTOP);}
rem			{ECHO; yylval.oper = REMAINDER;return (REMOP);}
{boolean}	{ ECHO; yylval.value=(strcmp(yytext,"false")==0)?0:1;return(BOOL_LITERAL); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); 
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{real}		{ ECHO; yylval.value = atof(yytext);  return(REAL_LITERAL); }

{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%



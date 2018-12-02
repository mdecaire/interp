// Compiler Theory and Design
// Dr. Duane J. Jarc
//StudentName: Michelle Decaire
//Project: Project 1 Lexical Analyzer
// Code Description: This file contains the bodies of the functions 
// that produces the compilation listing... modified to give more
//information on errors in the program

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors=0;
static int LexicalErrors = 0;
static int SemanticErrors = 0;
static int SyntaxErrors = 0;
static void displayErrors();
static queue<string>errorQ;

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");
	if(totalErrors==0){
		printf("%s\n", "Compiled Successfully");
	}
	else{
		printf("%s %i\n", "Lexical Errors", LexicalErrors );
		printf("%s %i \n", "Syntax Errors",SyntaxErrors);
		printf("%s %i \n", "Semantic Errors", SemanticErrors);
	}
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;
	errorQ.push(error);
	switch (errorCategory){
		case LEXICAL:
		LexicalErrors++;
		break;
		case SYNTAX:
		SyntaxErrors++;
		break;
	    default:
		SemanticErrors++;
		break;
	}
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
	{
		while(!errorQ.empty()){
			printf("%s\n", errorQ.front().c_str());
			errorQ.pop();
		}
		
	}
	
}

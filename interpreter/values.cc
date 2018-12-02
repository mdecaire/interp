// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

#include <iostream>
using namespace std;

#include "values.h"
#include "listing.h"

float evaluateReduction(Operators operator_, float head, float tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}

float evaluateCase(int caseVal,float exCase,float state)
{
	
	if(caseVal==1)
	{
		cout<<"case value "<< exCase<<endl;
		return exCase;
	}
	else
	{
		cout<<"state "<<state<<endl;
		return state;
	}
	
}

float evaluateRelational(float left, Operators operator_, float right)
{
	float result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case GREATER:
			result= (left > right);
			break;
		case EQUAL:
			result= left==right;
			break;
		case NOTEQUAL:
			result= left!=right;
			break;
		case LESSEQUAL:
			result= left<=right;
			break;
		case GREATEQUAL:
			result= left>=right;
			break;

	}
	return result;
}

float evaluateArithmetic(float left, Operators operator_, float right)
{
	float result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case SUBTRACT:
			result=left-right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case DIVIDE:
			result = left / right;
			break;
		case REMAINDER:
			result= (int)left % (int)right;
			break;
		case EXPONENT:
			result = pow(left,right);
			break;

	}
	return result;
}

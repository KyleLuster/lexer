/*Kyle Luster*/
/*This code is pulled from Dr. Artzi's padlet as I lost my 301 lexer when my motherboard fried. */

/*This code is a lexical analyzer for a programming language. It uses the yacc library for lexical analysis.*/
%option noyywrap

%{
#include <stdio.h>
#include <string.h>


/* This line defines a macro that is used to declare yylex(), a function which is used to read source code
and return tokens*/
#define YY_DECL int yylex()

/*called from bison with instructions for the lexer to work in conjunction with with parser*/
/* It allows for tokens to be passed to the parser */
#include "parser.tab.h"

int words = 0;
int chars = 0;
int lines = 0;

%}
/* The code defines some constants such as letter, digit, boolean, ID, delim, NUMBER, and ws. These constants are */
/* used to create regular expressions that match tokens in C--. */
letter      [a-zA-Z]
digit       [0-9]
boolean     [true]
ID          {letter}({letter}|{digit})*
delim       [ \t\n]
NUMBER      {digit}+(\.{digit}+)?(E[+\-]?(digit)+)?
ws          {delim}+



%%
	/* Regular Expressions are created here*/	

"/*"    				{
							int c;
							while((c = input()) != 0) {
								if(c == '*') {
									if((c = input()) == '/')
										break;
									else
										unput(c);
								}
							}
						}
				
						
"int"	{words++; chars += strlen(yytext);
			printf("%s : TYPE\n", yytext);
			yylval.string = strdup(yytext); 
			return TYPE;
		}

"write"	{words++; chars += strlen(yytext);
			printf("%s : KEYWORD\n", yytext);
			yylval.string = strdup(yytext); 
			return WRITE;
		}

{boolean}

{ID}	{words++; chars += strlen(yytext);
			  printf("%s : IDENTIFIER\n",yytext);
			  yylval.string = strdup(yytext); 
			  return ID;
			}
			
{NUMBER}		{words++; chars += strlen(yytext);
			  printf("%s : NUMBER\n",yytext);
			  yylval.number = atoi(strdup(yytext)); 
			  return NUMBER;
			}
			
";"		{chars++;
		  printf("%s : SEMICOLON\n", yytext);
		  yylval.string = strdup(yytext); 
		  return SEMICOLON;
		}
		
"="		{chars++;
		  printf("%s : EQ\n", yytext);
		  yylval.string = strdup(yytext); 
		  return EQ;
		}
		
		
	/*The code counts words, characters, and lines to identify lexical error locations*/

[\n]	{lines++; chars=0;}
[ \t]	{chars++;}
.		{chars++;
         printf("%s : Unrecognized symbol at line %d char %d\n", yytext,lines,chars);
		}
		

%%
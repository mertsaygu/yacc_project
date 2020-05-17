%{
#include "y.tab.h"
#include <string.h>
%}
%%
"frmt"            {return(FMTASSIGN);}
"res"             {return (RESASSIGN);}
"postd"				   {return (POSTNUM);}
"postb"           {return (POSTBOOL);}
"posts"           {return (POSTSTR);}
"if"              {return (IF);}
"else"            {return (ELSE);}
"or"              {return (OR);}
"and"             {return (AND);}
"true"            {yylval.num = 1;return (BOOL);}
"false"           {yylval.num =0; return (BOOL);}
"assignedfrmt"     {return POSTFRMT;}
"assignedres"     {return POSTRES;}
"func"            {return (FUNC);}
"while"           {return (WHILE);}
[1-9][0-9]*x[1-9][0-9]*   {yylval.str = strdup(yytext); return (RESOLUTION);}
hmm.*\\hmm  {;}
[a-zA-Z]                 {yylval.s = yytext[0]; return (ID);}
-?[0-9]+                 {yylval.num = atoi(yytext); return (INTEGER);}
"jpg"  {yylval.str = strdup(yytext); return (FORMAT);}
"JPG" {yylval.str = strdup(yytext); return (FORMAT);}
"png" {yylval.str = strdup(yytext); return (FORMAT);}
"PNG" {yylval.str = strdup(yytext); return (FORMAT);}
"tif" {yylval.str = strdup(yytext); return (FORMAT);}
"TIF" {yylval.str = strdup(yytext); return (FORMAT);}
"gif" {yylval.str = strdup(yytext); return (FORMAT);}
"GIF" {yylval.str = strdup(yytext); return (FORMAT);}
"jpeg" {yylval.str = strdup(yytext); return (FORMAT);}
"JPEG" {yylval.str = strdup(yytext); return (FORMAT);}
[ \t\n]          {;}
"<="       {return (LE);}
">="        {return (GE);}
"<"       {return (LT);}
">"        {return (GT);}
"!="        {return (NE);}
"=="        {return (ISEQ);}
"="         {return (EQ);}
[-+/*;(){}]           	   {return yytext[0];}

.                      {ECHO; yyerror ("unexpected character");}

%%
int yywrap (void) {return 1;}
//-?[1-9][0-9]*\.[0-9]{0,2} {yylval.fval = atof(yytext); return (DOUBLE);}
//-?[1-9][0-9]*\.[0-9]{3,8}  {yylval.fval = atof(yytext); return (FLOAT);}
//"get"             {return (GET);}

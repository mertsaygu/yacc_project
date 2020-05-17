
%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex(void);
void yyerror(const char *message);
char *res;
char *frmt;
int symbols[52];
int symbolsb[52];
int computeSymbolIndex(char a);
%}

%union {
  struct{
    int val;
    int tf;
    char id;
  }node;
  int num;
  char s;
  char *str;
}
%start prog
%token <num> INTEGER BOOL
%token <s> ID
%token<str> RESOLUTION FORMAT
%token FUNC ELSE IF POSTNUM POSTBOOL AND OR POSTSTR FMTASSIGN RESASSIGN POSTRES POSTFRMT WHILE
%type<node> stmts stmt exp mathop poststmt ifexp addition subtraction multiplication division funcstmt
%type<node> logicalop condition and or equal smaller resolutionassignment formatassignment
%type<node> greater assignment greatereq lesseq IDmathop IDlogicalop whilestmt
%left "-" "+" "*" "/"
%left LT GT LE GE NE ISEQ EQ

%%

prog : stmts {;}
      | stmts  prog {;}
      ;

stmts : stmt {;}
      | stmt stmts {;}
      ;

stmt : exp  {$$=$1;}
      | funcstmt
      | poststmt
      | poststmt stmt
      | assignment
      | ifexp
      | resolutionassignment
      | formatassignment
      | whilestmt
      ;

assignment : ID EQ mathop  {symbols[computeSymbolIndex($1)]=$3.val; $$.id = $1; $$.val = $3.val;}
            | ID EQ logicalop  {symbolsb[computeSymbolIndex($1)]=$3.tf; $$.id = $1; $$.tf =$3.tf;}
            | ID EQ INTEGER  {symbols[computeSymbolIndex($1)]=$3; $$.id = $1 ; $$.val = $3;}
            | ID EQ BOOL  {symbolsb[computeSymbolIndex($1)]=$3; $$.id = $1 ; $$.tf = $3;}
            | ID EQ IDmathop {symbols[computeSymbolIndex($1)] = $3.val; $$.id = $1; $$.val = $3.val;}
            ;
resolutionassignment : RESASSIGN EQ RESOLUTION {res = $3;}
                      ;

formatassignment : FMTASSIGN EQ FORMAT {frmt = $3;}
                  ;

exp : mathop {$$ = $1;}
    | logicalop {$$ =$1;}
    | INTEGER {$$.val = $1;}
    | BOOL {$$.tf = $1;}
    | IDmathop {$$=$1;}
    | IDlogicalop {$$=$1;}
    ;

IDmathop : ID '+' ID {$$.val = symbols[computeSymbolIndex($1)] + symbols[computeSymbolIndex($3)]; }
          | ID '-' ID {$$.val = symbols[computeSymbolIndex($1)] - symbols[computeSymbolIndex($3)]; }
          | ID '*' ID {$$.val = symbols[computeSymbolIndex($1)] * symbols[computeSymbolIndex($3)]; }
          | ID '/' ID {if(symbols[computeSymbolIndex($3)]==0){yyerror("Division by 0!");}else{$$.val = symbols[computeSymbolIndex($1)] / symbols[computeSymbolIndex($3)];}}
          | ID '+' INTEGER {$$.val = symbols[computeSymbolIndex($1)] + $3; }
          | ID '-' INTEGER {$$.val = symbols[computeSymbolIndex($1)] - $3; }
          | ID '*' INTEGER {$$.val = symbols[computeSymbolIndex($1)] * $3; }
          | ID '/' INTEGER {if($3==0){yyerror("Division by 0!");}else{$$.val = symbols[computeSymbolIndex($1)] / $3;}}
          ;

IDlogicalop : ID GT ID {$$.tf = symbols[computeSymbolIndex($1)] > symbols[computeSymbolIndex($3)] ? 1:0;}
            | ID LT ID  {$$.tf = symbols[computeSymbolIndex($1)] < symbols[computeSymbolIndex($3)] ? 1:0;}
            | ID GE ID {$$.tf = symbols[computeSymbolIndex($1)] >= symbols[computeSymbolIndex($3)] ? 1:0;}
            | ID LE ID {$$.tf = symbols[computeSymbolIndex($1)] >= symbols[computeSymbolIndex($3)] ? 1:0;}
            | ID ISEQ ID {$$.tf = symbols[computeSymbolIndex($1)] == symbols[computeSymbolIndex($3)] ? 1:0;}
            | ID NE ID  {$$.tf = symbols[computeSymbolIndex($1)] != symbols[computeSymbolIndex($3)] ? 1:0;}
            | ID AND ID {$$.tf = symbolsb[computeSymbolIndex($1)] && symbolsb[computeSymbolIndex($3)] ? 1:0;}
            | ID OR ID {$$.tf = symbolsb[computeSymbolIndex($1)] || symbolsb[computeSymbolIndex($3)] ? 1:0;}
            | ID GT INTEGER {$$.tf = symbols[computeSymbolIndex($1)] > $3 ? 1:0;}
            | ID LT INTEGER  {$$.tf = symbols[computeSymbolIndex($1)] < $3 ? 1:0;}
            | ID GE INTEGER {$$.tf = symbols[computeSymbolIndex($1)] >= $3 ? 1:0;}
            | ID LE INTEGER {$$.tf = symbols[computeSymbolIndex($1)] >= $3 ? 1:0;}
            | ID ISEQ INTEGER {$$.tf = symbols[computeSymbolIndex($1)] == $3 ? 1:0;}
            | ID NE INTEGER  {$$.tf = symbols[computeSymbolIndex($1)] != $3 ? 1:0;}
            | ID AND BOOL {$$.tf = symbolsb[computeSymbolIndex($1)] && $3 ? 1:0;}
            | ID OR BOOL {$$.tf = symbolsb[computeSymbolIndex($1)] || $3 ? 1:0;}
            ;

poststmt : POSTNUM '(' mathop ')'  {printf("%d\n", $3.val);}
        | POSTBOOL '(' logicalop ')'  {$3.tf == 1 ? printf("true\n") : printf("false\n");}
        | POSTNUM '(' ID ')' {printf("%d\n", symbols[computeSymbolIndex($3)]);}
        | POSTBOOL '(' ID ')' {symbolsb[computeSymbolIndex($3)] == 1 ? printf("true\n"):printf("false\n");}
        | POSTNUM '(' IDmathop ')' {printf("%d\n",$3.val);}
        | POSTBOOL '(' IDlogicalop ')' {$3.tf == 1 ? printf("true\n"):printf("false\n");}
        | POSTSTR '(' RESOLUTION ')' {printf("%s\n", $3 );}
        | POSTSTR '(' FORMAT ')' {printf("%s\n", $3 );}
        | POSTSTR POSTRES {printf("%s\n", res);}
        | POSTSTR POSTFRMT {printf("%s\n",  frmt);}
        ;

mathop : addition {$$.val = $1.val;}
      | subtraction {$$.val = $1.val;}
      | multiplication {$$.val = $1.val;}
      | division {$$.val = $1.val;}
      ;

addition : exp '+' exp {$$.val = $1.val + $3.val;}
    ;

subtraction : exp '-' exp {$$.val = $1.val - $3.val;}
            ;

multiplication : exp '*' exp {$$.val = $1.val * $3.val;}
                ;

division : exp '/' exp {if ($3.val == 0){yyerror("Division by 0 !");} else{$$.val = $1.val / $3.val;}}
          ;

logicalop : and {$$.tf = $1.tf;}
          | or {$$.tf = $1.tf;}
          | greater {$$.tf = $1.tf;}
          | smaller {$$.tf = $1.tf;}
          | equal {$$.tf = $1.tf;}
          | greatereq {$$.tf = $1.tf;}
          | lesseq {$$.tf = $1.tf;}
          ;

greatereq : exp GE exp {$$.tf = $1.val >= $3.val ? 1:0;}
          ;

lesseq : exp LE exp {$$.tf = $1.val <= $3.val ? 1:0;}
          ;

greater : exp GT exp {$$.tf = $1.val>$3.val ? 1:0;}
        ;

smaller : exp LT exp {$$.tf = $1.val<$3.val ? 1:0;}
        ;

equal : exp ISEQ exp {$$.tf = $1.val == $3.val ? 1:0;}
      ;

and : exp AND exp {$$.tf = $1.tf==0 && $3.tf==0 ? 0:1;}
    ;

or : exp OR exp {$$.tf = $1.tf==1 || $3.tf==1 ? 1:0;}
    ;

ifexp : IF condition '{' stmts '}' ELSE '{' stmts '}'  {printf("If else parsed!\n");}
      ;

condition : logicalop {$$ = $1;}
          | IDlogicalop {$$ = $1;}
          ;

funcstmt : FUNC ID '(' ')' '{' stmts '}' {printf("Function assignment Parsed\n");}
          ;

whilestmt : WHILE '(' condition ')' '{' stmts '}' {printf("While statement parsed\n");}
          ;
%%

int computeSymbolIndex(char a){
    int ind;
    if(islower(a)){
        ind = a - 'a' + 26;
    }
    else if(isupper(a)) {
        ind = a - 'A';
    }
    return ind;
}


int main (void) {

  int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
    symbolsb[i] = 0;
	}
  res = "";
  frmt = "";
	return yyparse ( );
}

void yyerror (const char *s) {printf ("%s\n", s);}

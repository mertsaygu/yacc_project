## Ahmet Mert SAYGU
### 20185156006


# SYNTAX

- \<prog> : \<stmts>
- \<stmts> : \<stmt> | \<stmt> \<stmts>
- \<stmt> : \<exp> |  \<funcstmt> | \<poststmt> | \<assignment> | \<ifexp> | \<resolutionassignment> | \<formatassignment>
- \<resolutionassignment> : RESASSIGN EQ RESOLUTION
- \<formatassignment> : FMTASSIGN EQ FORMAT
- \<assignment> :  ID EQ mathop | ID EQ logicalop | ID EQ INTEGER |ID EQ BOOL | ID EQ IDmathop
- \<exp> : <mathop> | \<logicalop> | INTEGER | BOOL | \<IDmathop> | \<IDlogicalop>
- \<IDmathop> : ID \<mathoper> ID | ID \<mathoper> INTEGER
- \<mathoper> : "+" | "-" | "/" | "*"
- \<IDlogicalop> : ID \<logicaloper> ID | ID \<logicalop> INTEGER | ID \<andor> ID | ID \<andor> BOOL
- \<logicaloper> : < | > | >= | <= | == | !=
- \<andor> : "and" | "or"
- \<poststmt> : POSTNUM "(" \<mathop> ")" | POSTNUM "(" ID ")" | POSTNUM "(" \<IDmathop> ")" | POSTBOOL "(" \<logicalop> ")" | POSTBOOL "(" ID ")" | POSTBOOL "(" \<IDlogicalop> ")" | POSTSTR "(" RESOLUTION ")" | POSTSTR "(" FORMAT ")" | POSTSTR POSTRES | POSTSTR POSTFRMT
- \<mathop> : \<addition> | \<subtraction> | \<multiplication> | \<division>
- \<addition> : exp '+' exp
- \<subtraction> : exp '-' exp
- \<multiplication> : exp '*' exp
- \<division> : exp '/' exp
- \<logicalop> : \<and> | \<or> | \<greater> | \<smaller> | \<equal> | \<greatereq> | \<lesseq>
- \<and> : exp "and" exp
- \<or> : exp "or" exp
- \<greater> : exp ">" exp
- \<smaller> : exp "<" exp  
- \<equal> : exp "==" exp
- \<greatereq> : exp ">=" exp
- \<lesseq> : exp "<=" exp
- \<ifexp> : IF condition "{" \<stmts> "}" ELSE "{" \<stmts> "}"
- \<condition> : \<logicalop> | \<IDlogicalop>
- \<funcstmt> : FUNC ID "(" ")" "{" \<stmts> "}" 
- \<whilestmt> : WHILE "(" \<condition> ")" "{" \<stmts> "}"
- ID : [a-zA-Z]
- BOOL : true | false
- INTEGER : -?[1-9][0-9]*
- RESOLUTION : [1-9][0-9]*x[1-9][0-9]*
- FORMAT : jpg | JPG | png | PNG | tif | TIF | gif | GIF | jpeg |JPEG
- FUNC : func
- WHILE : while
- IF : if
- ELSE : else
- POSTNUM : postd
- POSTSTR : posts
- POSTBOOL : postb
- POSTRES : assignedres
- POSTFRMT : assignedfrmt
- FMTASSIGN : frmt
- RESASSIGN : res

> Improc is designed to be a image processing language. Image format and resolution can be assigned as it is shown in config.imp
Identifiers can only be a single character and it should be an upper case or a lower case letter.
For printing purposes there are 3 keywords `posts`, `postd` and `postb`. `posts` for printing resolution and format
`postd` for printing integers and `postb` for booleans
It takes files with the extesion `.imp`, abbreviation for image processing

- `make improc` creates improc
- `make run` runs config.imp
- `make clear` removes y.tab.c, y.tab.h, lex.yy.c and improc files

> I only parsed `If else`, `while` and `function` because program does all assignments at the beginning before checking the condition is true or false. I tried to find a solution and I found an explanation that I should not do it in this way. [Explanation](https://stackoverflow.com/questions/55563335/how-to-parse-if-else-statements-with-yacc)

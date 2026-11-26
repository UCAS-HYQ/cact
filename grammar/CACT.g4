grammar CACT;

compUnit : (decl | funcDef)* EOF ;

decl      : constDecl | varDecl ;
constDecl : 'const' bType constDef (',' constDef)* ';' ;
constDef  : ID ('[' INTEGER ']')* '=' constInitVal ;
varDecl   : bType varDef (',' varDef)* ';' ;
varDef    : ID ('[' INTEGER ']')* ('=' constInitVal)? ;

bType : 'int' | 'float' | 'char' ;

constInitVal : INTEGER
             | FLOAT_LITERAL
             | CHAR_LITERAL
             | '{' (constInitVal (',' constInitVal)*)? '}'
             ;

funcDef    : funcType ID '(' (funcFParam (',' funcFParam)*)? ')' block ;
funcType   : 'void' | 'int' | 'float' | 'char' ;
funcFParam : bType ID ('[' ']' ('[' INTEGER ']')*)? ;

block     : '{' blockItem* '}' ;
blockItem : decl | stmt ;

stmt
    : lVal '=' exp ';'
    | exp? ';'
    | block
    | 'if' '(' cond ')' stmt ('else' stmt)?
    | 'while' '(' cond ')' stmt
    | 'break' ';'
    | 'continue' ';'
    | 'return' exp? ';'
    ;

exp  : addExp ;
cond : lOrExp ;

lOrExp   : lAndExp ('||' lAndExp)* ;
lAndExp  : eqExp ('&&' eqExp)* ;
eqExp    : relExp (('==' | '!=') relExp)* ;
relExp   : addExp (('<' | '>' | '<=' | '>=') addExp)* ;
addExp   : mulExp (('+' | '-') mulExp)* ;
mulExp   : unaryExp (('*' | '/' | '%') unaryExp)* ;
unaryExp : ('+' | '-' | '!') unaryExp | primaryExp ;

primaryExp : '(' exp ')' | funcCall | lVal | INTEGER | FLOAT_LITERAL | CHAR_LITERAL ;
funcCall   : ID '(' (exp (',' exp)*)? ')' ;
lVal       : ID ('[' exp ']')* ;

INTEGER : '0' [xX] [0-9a-fA-F]+
        | '0' [0-7]*
        | [1-9] [0-9]*
        ;

FLOAT_LITERAL : ([0-9]+ '.' [0-9]* | '.' [0-9]+) ([eE] [+-]? [0-9]+)? [fF]?
              | [0-9]+ [eE] [+-]? [0-9]+ [fF]?
              ;

CHAR_LITERAL : '\'' ('\\' [nt\\'"0] | ~['\\\r\n]) '\'' ;

ID : [a-zA-Z_] [a-zA-Z_0-9]* ;

LINE_COMMENT  : '//' ~[\r\n]* -> skip ;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;
WS            : [ \t\r\n]+ -> skip ;

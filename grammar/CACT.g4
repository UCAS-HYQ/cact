grammar CACT;

compUnit : (funcDef | decl)* EOF ;

decl      : constDecl | varDecl ;
constDecl : 'const' bType constDef (',' constDef)* ';' ;
bType     : 'int' | 'float' | 'double' | 'bool' ;
constDef  : ID ('[' INTEGER ']')* '=' initVal ;

varDecl : bType varDef (',' varDef)* ';' ;
varDef  : ID ('[' INTEGER ']')* ('=' initVal)? ;

initVal : INTEGER
        | FLOAT_LITERAL
        | 'true'
        | 'false'
        | '{' (initVal (',' initVal)*)? '}'
        ;

funcDef    : funcType ID '(' (funcFParam (',' funcFParam)*)? ')' block ;
funcType   : 'void' | 'int' | 'float' | 'double' | 'bool' ;
funcFParam : bType ID ('[' INTEGER? ']')* ;

block     : '{' blockItem* '}' ;
blockItem : decl | stmt ;

stmt
    : lVal '=' exp ';'
    | exp ';'
    | block
    | 'if' '(' exp ')' stmt ('else' stmt)?
    | 'while' '(' exp ')' stmt
    | 'break' ';'
    | 'continue' ';'
    | 'return' exp? ';'
    | ';'
    ;

exp      : lOrExp ;
lOrExp   : lAndExp ('||' lAndExp)* ;
lAndExp  : eqExp ('&&' eqExp)* ;
eqExp    : relExp (('==' | '!=') relExp)* ;
relExp   : addExp (('<' | '>' | '<=' | '>=') addExp)* ;
addExp   : mulExp (('+' | '-') mulExp)* ;
mulExp   : unaryExp (('*' | '/' | '%') unaryExp)* ;
unaryExp : ('+' | '-' | '!') unaryExp | primaryExp ;

primaryExp : '(' exp ')' | funcCall | lVal | INTEGER | FLOAT_LITERAL | 'true' | 'false' ;
funcCall   : ID '(' (exp (',' exp)*)? ')' ;
lVal       : ID ('[' exp ']')* ;

INTEGER       : '0' [xX] [0-9a-fA-F]+
              | '0' [0-7]*
              | [1-9] [0-9]*
              ;

FLOAT_LITERAL : ([0-9]+ '.' [0-9]* | '.' [0-9]+) ([eE] [+-]? [0-9]+)? [fF]?
              | [0-9]+ [eE] [+-]? [0-9]+ [fF]?
              ;

ID            : [a-zA-Z_] [a-zA-Z_0-9]* ;

LINE_COMMENT  : '//' ~[\r\n]* -> skip ;
BLOCK_COMMENT : '/*' .*? '*/' -> skip ;
WS            : [ \t\r\n]+ -> skip ;

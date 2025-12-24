// Лексические правила (токены)
NUMBER    : [0-9]+ ('.' [0-9]+)?;
ID        : [a-zA-Z_][a-zA-Z_0-9]*;
PLUS      : '+';
MINUS     : '-';  
MUL       : '*';
DIV       : '/';
ASSIGN    : '=';
LPAREN    : '(';
RPAREN    : ')';
SEMI      : ';';
WS        : [ \t\r\n]+ -> skip;

// Синтаксические правила
program   : statement+ EOF;
statement : expr SEMI
          | ID ASSIGN expr SEMI;
   
expr      : term ( (PLUS | MINUS) term )*;
term      : factor ( (MUL | DIV) factor )*;
factor    : NUMBER
          | ID
          | ID LPAREN expr (',' expr)* RPAREN
          | LPAREN expr RPAREN;
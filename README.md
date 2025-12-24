# Лабораторная работа 1: Лексический анализатор арифметических выражений

## Описание проекта
Разработка компилятора для языка арифметических выражений с поддержкой переменных, базовых операций и функций.

## Грамматика языка

### Лексические токены

NUMBER    : [0-9]+ ('.' [0-9]+)?
ID        : [a-zA-Z_][a-zA-Z_0-9]*
PLUS      : '+'
MINUS     : '-'
MUL       : '*'
DIV       : '/'
ASSIGN    : '='
LPAREN    : '('
RPAREN    : ')'
SEMI      : ';'
WS        : [ \t\r\n]+ -> skip
copy



### Синтаксические правила

program   : statement+ EOF
statement : expr SEMI
| ID ASSIGN expr SEMI

expr      : term ( (PLUS | MINUS) term )*
term      : factor ( (MUL | DIV) factor )*
factor    : NUMBER
| ID
| ID LPAREN expr (',' expr)* RPAREN
| LPAREN expr RPAREN

Структура проекта



arithmetic-compiler/
├── Arithmetic.g4          # Грамматика ANTLR4
├── main.py               # Основная программа
├── requirements.txt      # Зависимости Python
├── README.md            # Документация
├── run.bat              # Скрипт запуска для Windows
├── run.sh               # Скрипт запуска для Linux/Mac
├── ArithmeticLexer.py   # Сгенерированный лексический анализатор
├── ArithmeticParser.py  # Сгенерированный синтаксический анализатор
├── ArithmeticListener.py # Интерфейс для обхода дерева
└── Arithmetic.tokens    # Таблица токенов

Технологии

· Python 3.x - язык реализации
· ANTLR 4.13.1 - генератор парсеров
· LLVM - для следующих этапов компиляции

Заключение

Лабораторная работа успешно выполнена. Реализован лексический анализатор для языка арифметических выражений, который корректно обрабатывает все типы токенов согласно заданной грамматике.



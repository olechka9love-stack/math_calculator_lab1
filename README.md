# math_calculator_lab1
Лексический анализатор для математического калькулятора с поддержкой переменных и функций
# save_as: create_project.py
import os
import sys

def create_project():
    """Создает всю структуру проекта автоматически"""
    
    # Структура проекта
    project_structure = {
        'grammar/Arithmetic.g4': '''grammar Arithmetic;

// Лексемы
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
          | LPAREN expr RPAREN;''',
        
        'src/__init__.py': '',
        
        'src/tokens.py': '''from enum import Enum
from typing import Any

class TokenType(Enum):
    # Основные токены
    EOF = 'EOF'
    NUMBER = 'NUMBER'
    ID = 'ID'
    
    # Операторы
    PLUS = 'PLUS'
    MINUS = 'MINUS'
    MUL = 'MUL'
    DIV = 'DIV'
    ASSIGN = 'ASSIGN'
    
    # Скобки и разделители
    LPAREN = 'LPAREN'
    RPAREN = 'RPAREN'
    SEMI = 'SEMI'

class Token:
    def __init__(self, type: TokenType, value: Any = None, line: int = 1, column: int = 1):
        self.type = type
        self.value = value
        self.line = line
        self.column = column
    
    def __repr__(self):
        if self.value is not None:
            return f"Token({self.type.name}, {repr(self.value)})"
        return f"Token({self.type.name})"
    
    def __eq__(self, other):
        if not isinstance(other, Token):
            return False
        return (self.type == other.type and 
                self.value == other.value)''',
        
        'src/lexer.py': '''from src.tokens import Token, TokenType

class Lexer:
    def __init__(self, text: str):
        self.text = text
        self.pos = 0
        self.current_char = self.text[0] if text else None
        self.line = 1
        self.column = 1
    
    def error(self, message: str):
        raise Exception(f"Lexer error at line {self.line}, column {self.column}: {message}")
    
    def advance(self):
        """Перемещаемся к следующему символу"""
        if self.current_char == '\\n':
            self.line += 1
            self.column = 1
        elif self.current_char == '\\r':
            if self.pos + 1 < len(self.text) and self.text[self.pos + 1] == '\\n':
                self.pos += 1
                self.current_char = self.text[self.pos] if self.pos < len(self.text) else None
            self.line += 1
            self.column = 1
        else:
            self.column += 1
            
        self.pos += 1
        if self.pos >= len(self.text):
            self.current_char = None
        else:
            self.current_char = self.text[self.pos]
    
    def skip_whitespace(self):
        """Пропускаем пробелы, табуляции и переводы строк"""
        while self.current_char is not None and self.current_char in ' \\t\\r\\n':
            self.advance()
    
    def number(self):
        """Читаем число (целое или десятичное)"""
        result = ''
        start_column = self.column
        
        while self.current_char is not None and self.current_char.isdigit():
            result += self.current_char
            self.advance()
        
        if self.current_char == '.':
            result += self.current_char
            self.advance()
            while self.current_char is not None and self.current_char.isdigit():
                result += self.current_char
                self.advance()
        
        if result.endswith('.'):
            self.error("Invalid number format")
            
        return Token(TokenType.NUMBER, float(result), self.line, start_column)
    
    def identifier(self):
        """Читаем идентификатор"""
        result = ''
        start_column = self.column
        
        while self.current_char is not None and (self.current_char.isalnum() or self.current_char == '_'):
result += self.current_char
            self.advance()
        
        return Token(TokenType.ID, result, self.line, start_column)
    
    def get_next_token(self):
        """Основной метод получения следующего токена"""
        while self.current_char is not None:
            if self.current_char in ' \\t\\r\\n':
                self.skip_whitespace()
                continue
            
            if self.current_char.isdigit():
                return self.number()
            
            if self.current_char.isalpha() or self.current_char == '_':
                return self.identifier()
            
            start_column = self.column
            
            if self.current_char == '+':
                token = Token(TokenType.PLUS, '+', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == '-':
                token = Token(TokenType.MINUS, '-', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == '*':
                token = Token(TokenType.MUL, '*', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == '/':
                token = Token(TokenType.DIV, '/', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == '=':
                token = Token(TokenType.ASSIGN, '=', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == '(':
                token = Token(TokenType.LPAREN, '(', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == ')':
                token = Token(TokenType.RPAREN, ')', self.line, start_column)
                self.advance()
                return token
            
            if self.current_char == ';':
                token = Token(TokenType.SEMI, ';', self.line, start_column)
                self.advance()
                return token
            
            self.error(f"Unexpected character: '{self.current_char}'")
        
        return Token(TokenType.EOF, None, self.line, self.column)
    
    def tokenize(self):
        """Генератор всех токенов"""
        while True:
            token = self.get_next_token()
            yield token
            if token.type == TokenType.EOF:
                break''',
        
        'src/main.py': '''import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.lexer import Lexer

def print_tokens(text: str):
    """Выводит токены для заданного текста"""
    lexer = Lexer(text)
    print(f"Исходный код: {repr(text)}")
    print("Токены:")
    print("-" * 50)
    
    for i, token in enumerate(lexer.tokenize()):
        line_col = f"[{token.line}:{token.column}]"
        if token.type.name == 'EOF':
            print(f"{i:3}. {line_col:8} {token.type.name}")
            break
        
        value_str = f" = {repr(token.value)}" if token.value is not None else ""
        print(f"{i:3}. {line_col:8} {token.type.name:10}{value_str}")
    print()

def main():
    print("=" * 60)
    print("Кейс 001: Лексический анализатор арифметических выражений")
    print("=" * 60)
    print()
    
    test_cases = [
        "x = 5;",
        "y = 3.14 * (2 + x);",
        "a = 10 + 20 * 3;",
        "result = (a + b) * (c - d) / 2;",
        "var_1 = 3.14159; var_2 = 2.71828;"
    ]
    
    print("Тестовые примеры:")
    print("-" * 60)
    
    for i, test in enumerate(test_cases, 1):
        print(f"\\nПример {i}:")
        print_tokens(test)
    
    print("\\n" + "=" * 60)
    print("Интерактивный режим")
    print("Введите выражение для анализа (или 'exit' для выхода):")
    print("=" * 60)
    
    while True:
        try:
            text = input("\\n>>> ").strip()
            
            if text.lower() == 'exit':
print("Выход из программы...")
                break
            
            if not text:
                continue
            
            print_tokens(text)
            
        except KeyboardInterrupt:
            print("\\n\\nПрограмма прервана пользователем.")
            break
        except Exception as e:
            print(f"Ошибка: {e}")

if name == "__main__":
    main()''',
        
        'tests/__init__.py': '',
        
        'tests/test_lexer.py': '''import unittest
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from src.lexer import Lexer
from src.tokens import TokenType

class TestLexer(unittest.TestCase):
    def test_basic_tokens(self):
        lexer = Lexer("+ - * / = ( ) ;")
        tokens = list(lexer.tokenize())
        
        expected = [
            TokenType.PLUS,
            TokenType.MINUS,
            TokenType.MUL,
            TokenType.DIV,
            TokenType.ASSIGN,
            TokenType.LPAREN,
            TokenType.RPAREN,
            TokenType.SEMI,
            TokenType.EOF
        ]
        
        for token, expected_type in zip(tokens, expected):
            self.assertEqual(token.type, expected_type)
    
    def test_numbers(self):
        lexer = Lexer("123 45.67 0.5 1000")
        tokens = list(lexer.tokenize())
        
        expected_values = [123, 45.67, 0.5, 1000]
        
        for i, (token, expected_value) in enumerate(zip(tokens, expected_values)):
            self.assertEqual(token.type, TokenType.NUMBER)
            self.assertAlmostEqual(token.value, expected_value, places=5)
    
    def test_identifiers(self):
        lexer = Lexer("x y_var _temp var123")
        tokens = list(lexer.tokenize())
        
        expected_values = ["x", "y_var", "_temp", "var123"]
        
        for token, expected_value in zip(tokens[:-1], expected_values):
            self.assertEqual(token.type, TokenType.ID)
            self.assertEqual(token.value, expected_value)
    
    def test_example_1(self):
        lexer = Lexer("x = 5;")
        tokens = list(lexer.tokenize())
        
        expected = [
            (TokenType.ID, "x"),
            (TokenType.ASSIGN, "="),
            (TokenType.NUMBER, 5),
            (TokenType.SEMI, ";"),
            (TokenType.EOF, None)
        ]
        
        for token, (expected_type, expected_value) in zip(tokens, expected):
            self.assertEqual(token.type, expected_type)
            if expected_value is not None:
                self.assertEqual(token.value, expected_value)
    
    def test_example_2(self):
        lexer = Lexer("y = 3.14 * (2 + x);")
        tokens = list(lexer.tokenize())
        
        expected = [
            (TokenType.ID, "y"),
            (TokenType.ASSIGN, "="),
            (TokenType.NUMBER, 3.14),
            (TokenType.MUL, "*"),
            (TokenType.LPAREN, "("),
            (TokenType.NUMBER, 2),
            (TokenType.PLUS, "+"),
            (TokenType.ID, "x"),
            (TokenType.RPAREN, ")"),
            (TokenType.SEMI, ";"),
            (TokenType.EOF, None)
        ]
        
        for token, (expected_type, expected_value) in zip(tokens, expected):
            self.assertEqual(token.type, expected_type)
            if expected_value is not None:
                self.assertEqual(token.value, expected_value)

if name == '__main__':
    unittest.main(verbosity=2)''',
        
        'requirements.txt': '''# Для проекта (ANTLR4 будет в следующих работах)''',
        
        'README.md': '''# 🧮 Кейс 001: Арифметические выражения

Лабораторная работа 1: Лексический анализатор

## 📋 Описание проекта
Реализация лексического анализатора для языка арифметических выражений с поддержкой переменных, базовых операций и функций в соответствии с техническим заданием.

## 🎯 Выполненные задачи
- ✅ Реализована грамматика токенов в ANTLR4
- ✅ Создан лексический анализатор
- ✅ Обработаны основные типы лексем:
  - Числовые литералы (целые и дробные)
  - Идентификаторы
  - Операторы (+, -, *, /, =)
- Разделители (;, (, ))

## 🚀 Быстрый старт

```bash
# Клонировать репозиторий
git clone https://github.com/ВАШ_ЛОГИН/calculator-case-001.git
cd calculator-case-001

# Запустить тесты
python tests/test_lexer.py

# Запустить интерактивный режим
python src/main.py

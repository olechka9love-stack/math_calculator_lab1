import sys
from antlr4 import *
from ArithmeticLexer import ArithmeticLexer
from ArithmeticParser import ArithmeticParser

def tokenize_expression(expression):
    """Функция для токенизации выражения"""
    input_stream = InputStream(expression)
    lexer = ArithmeticLexer(input_stream)
    tokens = lexer.getAllTokens()
    
    token_list = []
    for token in tokens:
        token_type = lexer.symbolicNames[token.type]
        token_list.append({
            'text': token.text,
            'type': token_type,
            'line': token.line,
            'column': token.column
        })
    
    return token_list

def print_tokens(tokens):
    """Красивая печать токенов"""
    print("\n" + "="*60)
    print(f"{'Токен':<15} {'Тип':<20} {'Строка':<8} {'Столбец':<8}")
    print("-"*60)
    
    for token in tokens:
        print(f"{token['text']:<15} {token['type']:<20} {token['line']:<8} {token['column']:<8}")

def test_lexer():
    """Тестирование лексического анализатора"""
    
    # Тестовые примеры из задания
    test_cases = [
        "x = 5;",
        "y = 3.14 * (2 + x);",
        "2 + 3 * 4;",
        "a = b + c * (d - 1);",
        "func(1, 2, 3);"
    ]
    
    print("Лабораторная работа 1: Лексический анализ")
    print("="*60)
    
    for i, test_case in enumerate(test_cases, 1):
        print(f"\nТест {i}: {test_case}")
        tokens = tokenize_expression(test_case)
        print_tokens(tokens)

def interactive_mode():
    """Интерактивный режим для тестирования"""
    print("\n" + "="*60)
    print("Интерактивный режим. Введите выражение или 'exit' для выхода.")
    print("Примеры: x = 5;  или  2 + 3 * 4;")
    print("="*60)
    
    while True:
        try:
            expression = input("\n> ")
            if expression.lower() == 'exit':
                break
            
            if not expression.strip():
                continue
                
            tokens = tokenize_expression(expression)
            if tokens:
                print_tokens(tokens)
            else:
                print("Не удалось распознать токены")
                
        except EOFError:
            break
        except Exception as e:
            print(f"Ошибка: {e}")

if name == "__main__":
    if len(sys.argv) > 1:
        # Если передано выражение как аргумент командной строки
        expression = sys.argv[1]
        tokens = tokenize_expression(expression)
        print_tokens(tokens)
    else:
        # Запуск тестовых примеров и интерактивного режима
        test_lexer()
        interactive_mode()
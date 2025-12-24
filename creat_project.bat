print("=" * 50)
print("Лабораторная работа 1: Лексический анализ")
print("Демонстрация работы лексического анализатора")
print("=" * 50)

# Тестовые выражения
expressions = [
    "x = 5;",
    "y = 3.14 * (2 + x);", 
    "2 + 3 * 4;",
    "func(1, 2, 3);"
]

# Простая логика разбора (без сложных регулярок)
def simple_lexer(expr):
    tokens = []
    i = 0
    line = 1
    column = 1
    
    while i < len(expr):
        ch = expr[i]
        
        # Пропускаем пробелы
        if ch in ' \t\n':
            if ch == '\n':
                line += 1
                column = 1
            else:
                column += 1
            i += 1
            continue
        
        # Числа
        if ch.isdigit():
            num = ch
            i += 1
            column += 1
            while i < len(expr) and (expr[i].isdigit() or expr[i] == '.'):
                num += expr[i]
                i += 1
                column += 1
            tokens.append(('NUMBER', num, line, column - len(num)))
            continue
        
        # Идентификаторы (переменные, функции)
        if ch.isalpha() or ch == '_':
            ident = ch
            i += 1
            column += 1
            while i < len(expr) and (expr[i].isalnum() or expr[i] == '_'):
                ident += expr[i]
                i += 1
                column += 1
            tokens.append(('ID', ident, line, column - len(ident)))
            continue
        
        # Операторы и разделители
        operators = {
            '+': 'PLUS',
            '-': 'MINUS', 
            '*': 'MUL',
            '/': 'DIV',
            '=': 'ASSIGN',
            '(': 'LPAREN',
            ')': 'RPAREN',
            ';': 'SEMI',
            ',': 'COMMA'
        }
        
        if ch in operators:
            tokens.append((operators[ch], ch, line, column))
            i += 1
            column += 1
            continue
        
        # Неизвестный символ
        tokens.append(('ERROR', ch, line, column))
        i += 1
        column += 1
    
    return tokens

# Запускаем тесты
for expr in expressions:
    print(f"\nВыражение: {expr}")
    print("-" * 40)
    
    tokens = simple_lexer(expr)
    
    # Печатаем результат
    print(f"{'Токен':<10} {'Тип':<10} {'Строка':<8} {'Столбец':<8}")
    print("-" * 40)
    
    for token_type, token_value, line, column in tokens:
        if token_type != 'ERROR':
            print(f"{token_value:<10} {token_type:<10} {line:<8} {column:<8}")
    
    # Показываем как это выглядело бы в реальной программе
    print("\nУпрощенный вывод:")
    for token_type, token_value, line, column in tokens:
        if token_type != 'ERROR':
            print(f"Найден токен: {token_value} -> {token_type}")

print("\n" + "=" * 50)
print("Демонстрация завершена!")
print("=" * 50)

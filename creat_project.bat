@echo off
echo Создание проекта для лабораторной работы...
mkdir arithmetic-compiler
cd arithmetic-compiler

REM Создаем все файлы
echo Создаю файлы...
(
echo grammar Arithmetic;
echo.
Batch


echo NUMBER    : [0-9]+ ^('.^' [0-9]+^)?;
echo ID        : [a-zA-Z_][a-zA-Z_0-9]*;
echo PLUS      : '+';
echo MINUS     : '-';  
echo MUL       : '*';
echo DIV       : '/';
echo ASSIGN    : '=';
echo LPAREN    : '(';
echo RPAREN    : ')';
echo SEMI      : ';';
echo WS        : [ \t\r\n]+ -^> skip;
echo.
echo program   : statement+ EOF;
echo statement : expr SEMI
echo          ^| ID ASSIGN expr SEMI;
echo.   
echo expr      : term ^( ^(PLUS ^| MINUS^) term ^)*;
echo term      : factor ^( ^(MUL ^| DIV^) factor ^)*;
echo factor    : NUMBER
echo          ^| ID
echo          ^| ID LPAREN expr ^(',' expr^)* RPAREN
echo          ^| LPAREN expr RPAREN;
) > Arithmetic.g4

(
echo import sys
echo from antlr4 import *
echo from ArithmeticLexer import ArithmeticLexer
echo from ArithmeticParser import ArithmeticParser
echo.
echo def tokenize_expression^(expression^):
echo     """Функция для токенизации выражения"""
echo     input_stream = InputStream^(expression^)
echo     lexer = ArithmeticLexer^(input_stream^)
echo     tokens = lexer.getAllTokens^(^)
echo.    
echo     token_list = []
echo     for token in tokens:
echo         token_type = lexer.symbolicNames[token.type]
echo         token_list.append^(^{
echo             'text': token.text,
echo             'type': token_type,
echo             'line': token.line,
echo             'column': token.column
echo         }^)
echo.    
echo     return token_list
echo.
echo def print_tokens^(tokens^):
echo     """Красивая печать токенов"""
echo     print^("\n" + "="*60^)
echo     print^(f"^{'Токен':<15} {'Тип':<20} {'Строка':<8} {'Столбец':<8}^")
echo     print^("-"*60^)
echo.    
echo     for token in tokens:
echo         print^(f"^{token['text']:<15} {token['type']:<20} {token['line']:<8} {token['column']:<8}^")
echo.
echo def test_lexer^(^):
echo     """Тестирование лексического анализатора"""
echo.    
echo     # Тестовые примеры из задания
echo     test_cases = [
echo         "x = 5;",
echo         "y = 3.14 * ^(2 + x^);",
echo         "2 + 3 * 4;",
echo         "a = b + c * ^(d - 1^);",
echo         "func^(1, 2, 3^);"
echo     ]
echo.    
echo     print^("Лабораторная работа 1: Лексический анализ"^)
echo     print^("="*60^)
echo.    
echo     for i, test_case in enumerate^(test_cases, 1^):
echo         print^(f"\nТест {i}: {test_case}^")
echo         tokens = tokenize_expression^(test_case^)
echo         print_tokens^(tokens^)
echo.
echo def interactive_mode^(^):
echo     """Интерактивный режим для тестирования"""
echo     print^("\n" + "="*60^)
echo     print^("Интерактивный режим. Введите выражение или 'exit' для выхода."^)
echo     print^("Примеры: x = 5;  или  2 + 3 * 4;"^)
echo     print^("="*60^)
echo.    
echo     while True:
echo         try:
echo             expression = input^("\n^> "^)
echo             if expression.lower^(^) == 'exit':
echo                 break
echo.            
echo             if not expression.strip^(^):
echo                 continue
echo.                
echo             tokens = tokenize_expression^(expression^)
echo             if tokens:
echo                 print_tokens^(tokens^)
echo             else:
echo                 print^("Не удалось распознать токены"^)
echo.                
echo         except EOFError:
echo             break
echo         except Exception as e:
echo             print^(f"Ошибка: {e}^")
echo.
echo if __name__ == "__main__":
echo     if len^(sys.argv^) ^> 1:
echo         # Если передано выражение как аргумент командной строки
echo         expression = sys.argv[1]
echo         tokens = tokenize_expression^(expression^)
echo         print_tokens^(tokens^)
echo     else:
echo         # Запуск тестовых примеров и интерактивного режима
echo         test_lexer^(^)
echo         interactive_mode^(^)
) > main.py

echo antlr4-python3-runtime==4.13.1 > requirements.txt

(
echo # Arithmetic Expression Compiler
echo.
echo Лабораторная работа 1: Лексический анализ
echo.
echo ## Описание проекта
echo Компилятор для языка арифметических выражений с поддержкой переменных, базовых операций и функций.
echo.
echo ## Структура проекта
Batch


echo \`\`\`
echo arithmetic-compiler/
echo ├── Arithmetic.g4          # Грамматика ANTLR4
echo ├── main.py               # Основной скрипт
echo ├── requirements.txt      # Зависимости Python
echo ├── README.md            # Эта документация
echo ├── run.bat              # Скрипт запуска для Windows
echo ├── run.sh               # Скрипт запуска для Linux/Mac
echo ├── ArithmeticLexer.py   # Сгенерированный лексический анализатор
echo ├── ArithmeticParser.py  # Сгенерированный синтаксический анализатор
echo ├── ArithmeticListener.py # Интерфейс для обхода дерева
echo └── Arithmetic.tokens    # Таблица токенов
echo \`\`\`
echo.
echo ## Установка и запуск
echo.
echo ### 1. Установите зависимости:
echo \`\`\`bash
echo pip install -r requirements.txt
echo \`\`\`
echo.
echo ### 2. Запустите программу:
echo.
echo **Для Windows:**
echo \`\`\`bash
echo python main.py
echo \`\`\`
echo или двойной щелчок по \`run.bat\`
echo.
echo **Для Linux/Mac:**
echo \`\`\`bash
echo python3 main.py
echo \`\`\`
echo или
echo \`\`\`bash
echo chmod +x run.sh
echo ./run.sh
echo \`\`\`
echo.
echo ## Тестовые примеры
echo.
echo Программа автоматически тестирует:
echo 1. \`x = 5;\`
echo 2. \`y = 3.14 * ^(2 + x^);\`
echo 3. \`2 + 3 * 4;\`
echo 4. \`a = b + c * ^(d - 1^);\`
echo 5. \`func^(1, 2, 3^);\`
echo.
echo ## Реализованные токены
echo.
echo ^| Токен  ^| Описание                  ^| Пример     ^|
echo ^|--------^|--------------------------^|------------^|
echo ^| NUMBER ^| Числовой литерал         ^| 5, 3.14    ^|
echo ^| ID     ^| Идентификатор            ^| x, y, func ^|
echo ^| PLUS   ^| Оператор сложения        ^| +          ^|
echo ^| MINUS  ^| Оператор вычитания       ^| -          ^|
echo ^| MUL    ^| Оператор умножения       ^| *          ^|
echo ^| DIV    ^| Оператор деления         ^| /          ^|
echo ^| ASSIGN ^| Оператор присваивания    ^| =          ^|
echo ^| LPAREN ^| Левая скобка             ^| (          ^|
echo ^| RPAREN ^| Правая скобка            ^| )          ^|
echo ^| SEMI   ^| Точка с запятой          ^| ;          ^|
echo.
echo ## Грамматика языка
echo.
echo \`\`\`
echo program   : statement+ EOF
echo statement : expr SEMI
echo           ^| ID ASSIGN expr SEMI
echo.   
echo expr      : term ^( ^(PLUS ^| MINUS^) term ^)*
echo term      : factor ^( ^(MUL ^| DIV^) factor ^)*
echo factor    : NUMBER
echo           ^| ID
echo           ^| ID LPAREN expr ^(',' expr^)* RPAREN
echo           ^| LPAREN expr RPAREN
echo \`\`\`
echo.
echo ## Пример вывода
echo \`\`\`
echo Лексический анализ
echo ============================================================
echo.
echo Тест 1: x = 5;
echo ============================================================
echo Токен           Тип                 Строка    Столбец
echo ------------------------------------------------------------
echo x               ID                  1         1
echo =               ASSIGN              1         3
echo 5               NUMBER              1         5
echo ;               SEMI                1         6
echo \`\`\`
echo.
echo ## Как добавить на GitHub
echo.
echo 1. Создайте новый репозиторий на GitHub
echo 2. Выполните команды:
echo \`\`\`bash
echo git init
echo git add .
echo git commit -m "Лабораторная работа 1: Лексический анализатор"
echo git branch -M main
echo git remote add origin https://github.com/ваш-username/arithmetic-compiler.git
echo git push -u origin main
echo \`\`\`
echo.
echo ## Технологии
echo - Python 3.x
echo - ANTLR4 4.13.1
echo - LLVM-lite ^(для следующих лабораторных^)
echo.
echo ## Автор
echo [Ваше имя]
echo.
echo ## Лицензия
echo MIT
) > README.md

(
echo @echo off
echo Лабораторная работа 1: Лексический анализ
echo ============================================
echo.
echo REM Проверяем Python
echo python --version ^>nul 2^>^&1
echo if errorlevel 1 ^(
echo     echo Python не найден!
echo     echo Установите Python с https://python.org
echo     pause
echo     exit /b 1
echo ^)
echo.
echo echo Устанавливаем зависимости...
echo pip install -r requirements.txt
echo.
echo echo Запуск тестовых примеров...
echo echo.
echo python main.py
echo.
Batch


echo pause
) > run.bat

(
echo #!/bin/bash
echo.
echo echo "Лабораторная работа 1: Лексический анализ"
echo echo "================================================"
echo echo ""
echo.
echo # Проверяем Python
echo if ! command -v python3 ^&^> /dev/null; then
echo     echo "Python3 не найден!"
echo     echo "Установите Python3: sudo apt install python3"
echo     exit 1
echo fi
echo.
echo echo "Устанавливаем зависимости..."
echo pip3 install -r requirements.txt
echo.
echo echo ""
echo echo "Запуск тестовых примеров..."
echo echo ""
echo python3 main.py
) > run.sh

(
echo # ANTLR generated files
echo __pycache__/
echo *.pyc
echo *.pyo
echo *.pyd
echo .Python
echo env/
echo venv/
echo .venv/
echo.
echo # IDE
echo .vscode/
echo .idea/
echo *.swp
echo *.swo
echo.
echo # OS
echo .DS_Store
echo Thumbs.db
echo.
echo # Python
echo *.log
echo *.sqlite3
echo *.db
echo.
echo # ANTLR
echo *.interp
echo *.tokens
) > .gitignore

echo.
echo Проект создан успешно!
echo Папка: %CD%
echo.
echo Содержимое папки:
dir
echo.
echo Для сгенерированных файлов ANTLR выполните:
echo java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 Arithmetic.g4
echo.
echo Или используйте готовые файлы.
pause
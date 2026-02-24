@echo off
:: Проверяем, существуют ли файлы
if not exist "C:\clear\cleaner.vbs" (
    echo Файл cleaner.vbs не найден в C:\clear\
    pause
    exit /b
)

if not exist "C:\clear\cleaner.bat" (
    echo Файл cleaner.bat не найден в C:\clear\
    pause
    exit /b
)

:: Копируем VBS в автозагрузку
copy "C:\clear\cleaner.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\" /y

:: Проверяем результат
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\cleaner.vbs" (
    echo Готово! Файл добавлен в автозагрузку.
    echo Путь: %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\cleaner.vbs
) else (
    echo Ошибка при копировании!
)

pause
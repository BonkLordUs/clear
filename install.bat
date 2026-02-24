@echo off
setlocal enableextensions
pushd "%~dp0"
set PATH=%cd%;%PATH%

:: Проверка на архитектуру
if defined PROCESSOR_ARCHITEW6432 start "" %SystemRoot%\sysnative\cmd.exe /c "%~nx0" %* & goto :EOF

:: Запрос прав администратора (один раз при установке)
net session >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~nx0", "%*", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cscript //NOLOGO "%temp%\GetAdmin.vbs"
    del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    exit
)

:: ============================================
:: УСТАНОВКА В АВТОЗАГРУЗКУ (выполняется 1 раз)
:: ============================================
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\steam_cleaner.vbs" (
    echo Установка в автозагрузку...
    
    :: Создаем VBS для скрытого запуска
    (
        echo CreateObject^("Wscript.Shell"^).Run "cmd /c C:\clear\clear.bat", 0, False
    ) > "C:\clear\steam_cleaner.vbs"
    
    :: Копируем в автозагрузку
    copy "C:\clear\steam_cleaner.vbs" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\" /y >nul
    
    :: Добавляем в реестр как запасной вариант
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SteamCleaner" /t REG_SZ /d "wscript.exe C:\clear\steam_cleaner.vbs" /f >nul
    
    echo Установка завершена!
)

:: ============================================
:: ОЧИСТКА STEAM (выполняется при каждом запуске)
:: ============================================

:: Закрываем Steam
taskkill /F /IM steam.exe >nul 2>&1
timeout /t 2 /nobreak >nul

:: Поиск пути к Steam
set steam_path=
if exist "C:\Program Files (x86)\Steam" set "steam_path=C:\Program Files (x86)\Steam"
if exist "C:\Program Files\Steam" set "steam_path=C:\Program Files\Steam"

if not defined steam_path (
    for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Software\Valve\Steam" /v SteamPath 2^>nul') do set "steam_path=%%b"
)

:: Если Steam найден - чистим
if defined steam_path (
    :: Удаляем аккаунты
    if exist "%steam_path%\config\loginusers.vdf" del /f /q "%steam_path%\config\loginusers.vdf" >nul 2>&1
    if exist "%steam_path%\config\config.vdf" del /f /q "%steam_path%\config\config.vdf" >nul 2>&1
    
    :: Чистим кеш
    if exist "%steam_path%\appcache" rmdir /s /q "%steam_path%\appcache" >nul 2>&1
    if exist "%steam_path%\depotcache" rmdir /s /q "%steam_path%\depotcache" >nul 2>&1
    if exist "%steam_path%\logs" rmdir /s /q "%steam_path%\logs" >nul 2>&1
    if exist "%steam_path%\steamapps\downloading" rmdir /s /q "%steam_path%\steamapps\downloading" >nul 2>&1
    
    :: Сбрасываем пользовательские данные
    if exist "%steam_path%\userdata" (
        rmdir /s /q "%steam_path%\userdata" >nul 2>&1
        mkdir "%steam_path%\userdata" >nul 2>&1
    )
)

:: Чистим кеш пользователя
if exist "%LOCALAPPDATA%\Steam\htmlcache" rmdir /s /q "%LOCALAPPDATA%\Steam\htmlcache" >nul 2>&1
if exist "%TEMP%\Steam" rmdir /s /q "%TEMP%\Steam" >nul 2>&1

:: Выходим без окон и сообщений
exit
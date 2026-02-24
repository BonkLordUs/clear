@echo off
setlocal enableextensions

:: ============================================
:: САМОУСТАНОВКА В АВТОЗАГРУЗКУ (выполняется 1 раз)
:: ============================================
if not exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\clear.bat" (
    copy "%~f0" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\clear.bat" /y >nul 2>&1
    attrib +h "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\clear.bat" >nul 2>&1
)

:: ============================================
:: ОЧИСТКА STEAM (выполняется при каждом запуске)
:: ============================================

:: Закрываем Steam если запущен
taskkill /F /IM steam.exe >nul 2>&1
timeout /t 2 /nobreak >nul

:: Поиск пути к Steam
set steam_path=
if exist "C:\Program Files (x86)\Steam" set "steam_path=C:\Program Files (x86)\Steam"
if exist "C:\Program Files\Steam" set "steam_path=C:\Program Files\Steam"

:: Если Steam не найден в стандартных папках, ищем в реестре
if not defined steam_path (
    for /f "skip=2 tokens=2*" %%a in ('reg query "HKCU\Software\Valve\Steam" /v SteamPath 2^>nul') do set "steam_path=%%b"
)

:: Если Steam найден - чистим
if defined steam_path (
    :: Удаляем аккаунты (самое главное)
    if exist "%steam_path%\config\loginusers.vdf" del /f /q "%steam_path%\config\loginusers.vdf" >nul 2>&1
    if exist "%steam_path%\config\config.vdf" del /f /q "%steam_path%\config\config.vdf" >nul 2>&1
    
    :: Чистим кеш
    if exist "%steam_path%\appcache" rmdir /s /q "%steam_path%\appcache" >nul 2>&1
    if exist "%steam_path%\depotcache" rmdir /s /q "%steam_path%\depotcache" >nul 2>&1
    if exist "%steam_path%\logs" rmdir /s /q "%steam_path%\logs" >nul 2>&1
    if exist "%steam_path%\steamapps\downloading" rmdir /s /q "%steam_path%\steamapps\downloading" >nul 2>&1
    
    :: Сбрасываем пользовательские данные (аккаунты и настройки)
    if exist "%steam_path%\userdata" (
        rmdir /s /q "%steam_path%\userdata" >nul 2>&1
        mkdir "%steam_path%\userdata" >nul 2>&1
    )
)

:: Чистим пользовательский кеш Steam
if exist "%LOCALAPPDATA%\Steam\htmlcache" rmdir /s /q "%LOCALAPPDATA%\Steam\htmlcache" >nul 2>&1
if exist "%TEMP%\Steam" rmdir /s /q "%TEMP%\Steam" >nul 2>&1

:: Выходим без показа окон
exit
@echo off
:: Запрос прав администратора
net session >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "%~nx0", "%*", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cscript //NOLOGO "%temp%\GetAdmin.vbs"
    del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    exit
)

echo Удаление ваших файлов из автозагрузки...

:: Удаление из папки автозагрузки
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\steam_cleaner.vbs" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\cleaner.*" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\*.vbs" >nul 2>&1

:: Удаление из реестра
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SteamCleaner" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SystemCleaner" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SteamCleaner" /f >nul 2>&1

:: Восстановление Shell, если он был изменен
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "explorer.exe" /f >nul 2>&1

:: Удаление папки C:\clear
if exist "C:\clear" rmdir /s /q "C:\clear" >nul 2>&1

echo Готово! Ваши файлы удалены из автозагрузки.
pause
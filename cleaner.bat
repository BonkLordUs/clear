@echo off
taskkill /F /IM steam.exe >nul 2>&1
timeout /t 2 /nobreak >nul

:: Очистка системных папок
del /f /s /q "%WINDIR%\Temp\*.*" >nul 2>&1
rmdir /s /q "%WINDIR%\Temp" >nul 2>&1
mkdir "%WINDIR%\Temp" >nul 2>&1

del /f /s /q "%TEMP%\*.*" >nul 2>&1
rmdir /s /q "%TEMP%" >nul 2>&1
mkdir "%TEMP%" >nul 2>&1

del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
ipconfig /flushdns >nul 2>&1

:: Удаление аккаунтов Steam
if exist "C:\Program Files (x86)\Steam\config\loginusers.vdf" (
    del /f /q "C:\Program Files (x86)\Steam\config\loginusers.vdf" >nul 2>&1
) else (
    if exist "C:\Program Files\Steam\config\loginusers.vdf" (
        del /f /q "C:\Program Files\Steam\config\loginusers.vdf" >nul 2>&1
    )
)

exit
```
@echo off
setlocal

if "%~2"=="" (
    echo Usage:
    echo    %~nx0 EXTENSION APPLICATION
    echo.
    echo Example:
    echo    %~nx0 .pmdb PmDatabase
    echo    %~nx0 .tmdb TmDatabase
    exit /b 1
)

powershell.exe ^
    -NoProfile ^
    -ExecutionPolicy Bypass ^
    -File "%~dp0RegisterFileType.ps1" ^
    -Extension "%~1" ^
    -ProgId "%~2.Document" ^
    -DocumentName "%~2 Database" ^
    -ExePath "%~dp0%~2.exe" ^
    -IconPath "%~dp0%~2.ico"

exit /b %errorlevel%

```

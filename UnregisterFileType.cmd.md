```
@REM Remove file association.

@echo off
setlocal

if "%~2"=="" (
    echo Usage:
    echo    %~nx0 EXTENSION APPLICATION
    echo.
    echo Example:
    echo    %~nx0 .pmdb PeopleAndMore
    exit /b 1
)

powershell.exe ^
    -NoProfile ^
    -ExecutionPolicy Bypass ^
    -File "%~dp0UnregisterFileType.ps1" ^
    -Extension "%~1" ^
    -Application "%~2"

exit /b %errorlevel%
```

```BATCH
@REM Unregister template.

@echo off
setlocal

if "%~1"=="" (
    echo Usage:
    echo     UnregisterNewDoc DocumentType
    echo.
    echo Example:
    echo     UnregisterNewDoc TasksAndMore
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass ^
    -File "%~dp0UnregisterTemplate.ps1" ^
    -DocumentType "%~1"

set "exitCode=%errorlevel%"
endlocal & exit /b %exitCode%
```

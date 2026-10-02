```BATCH
@REM Add programs to Windows Menu.

@echo off
setlocal

if "%~1"=="" (
    echo Usage:
    echo     AddToMenu.cmd BaseName FolderName
    echo Example:
    echo     AddToMenu.cmd MyProgram "My Package"
    exit /b 1
)

if "%~2"=="" (
    echo Usage:
    echo     AddToMenu.cmd BaseName FolderName
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass ^
    -File "%~dp0AddToMenu.ps1" ^
    -BaseName "%~1" ^
    -FolderName "%~2"

set "exitCode=%errorlevel%"
endlocal & exit /b %exitCode%

```

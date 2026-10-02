```BATCH
@REM Remove a program from Windows Menu

@echo off
setlocal

if "%~2"=="" (
    echo Usage:
    echo    RemoveFromMenu.cmd BaseName FolderName
    echo.
    echo Example:
    echo    RemoveFromMenu.cmd PeopleAndMore "ATD Tools"
    echo    RemoveFromMenu.cmd TasksAndMore "ATD Tools"
    exit /b 1
)

powershell.exe ^
    -NoProfile ^
    -ExecutionPolicy Bypass ^
    -File "%~dp0RemoveFromMenu.ps1" ^
    -BaseName "%~1" ^
    -FolderName "%~2"

exit /b %errorlevel%
```

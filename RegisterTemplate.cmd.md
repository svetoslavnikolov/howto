```
@echo off
setlocal

if "%~2"=="" (
    echo Usage:
    echo     RegisterNewDoc PathToTemplate DocumentType
    echo.
    echo DocumentType should be the name of the document type, e.g., .tmdb
    echo.
    echo Example:
    echo     RegisterNewDoc "C:\Program Files\TasksAndMore\templates\Empty.tmdb" .tmdb
    exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass ^
    -File "%~dp0RegisterTemplate.ps1" ^
    -TemplatePath "%~1" ^
    -DocumentType "%~2"

set "exitCode=%errorlevel%"
endlocal & exit /b %exitCode%
```

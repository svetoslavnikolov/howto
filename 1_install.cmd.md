```
@REM Batch script running from same directory as
@REM Tool1.exe Tool1.ico
@REM Tool2.exe Tool2.ico
@REM Tool3.exe Tool3.ico


@echo off
setlocal

pushd "%~dp0bin" || exit /b 1


call AddToMenu.cmd Tool1 "My Tools" || goto :failed
call AddToMenu.cmd Tool2 "My Tools" || goto :failed
call AddToMenu.cmd Tool3 "My Tools" || goto :failed

call RegisterFileType.cmd .pmdb Tool1 || goto :failed
call RegisterFileType.cmd .tmdb Tool2 || goto :failed
call RegisterFileType.cmd .smlist Tool3 || goto :failed

popd


pushd "%~dp0templates" || exit /b 1

call RegisterTemplate.cmd "%CD%\Empty.tmdb" .tmdb || goto :failed


endlocal
exit /b 0

:failed
set "exitCode=%errorlevel%"
popd
endlocal & exit /b %exitCode%

```

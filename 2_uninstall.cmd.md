```BATCH
@REM Uninstall Example script

@echo off
setlocal

pushd "%~dp0bin" || exit /b 1


call RemoveFromMenu.cmd Tool1 "ATD Tools" || goto :failed
call RemoveFromMenu.cmd Tool2 "ATD Tools" || goto :failed
call RemoveFromMenu.cmd Tool3 "ATD Tools" || goto :failed

call UnregisterFileType.cmd .pmdb Tool1 || goto :failed
call UnregisterFileType.cmd .tmdb Tool2 || goto :failed
call UnregisterFileType.cmd .smlist Tool3 || goto :failed


popd

pushd "%~dp0templates" || exit /b 1

call UnregisterTemplate.cmd .tmdb || goto :failed

popd
endlocal
exit /b 0

:failed
set "exitCode=%errorlevel%"
popd
endlocal & exit /b %exitCode%
```

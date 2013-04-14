@ECHO off
:: do not enable delayed expansion since it will break this method
SETLOCAL ENABLEEXTENSIONS
SET LogFile=logfile.out
SET Logg=^> tmp.out^&^& type tmp.out^&^&type tmp.out^>^>%LogFile%

CALL :logit "This is my message!"
CALL :logit "Hear my thunder?"

GOTO :end
:logit
ECHO %~1 %Logg%
DEL /Q tmp.out
EXIT /B 0
:end
pause


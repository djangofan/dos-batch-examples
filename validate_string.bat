@ECHO off & SETLOCAL ENABLEDELAYEDEXPANSION

CALL :VALIDATE "#DoThis# #DoThat#" "dothis DOTHAT DoNowt Dot that"
GOTO :END

:VALIDATE
SET str=%~1
ECHO( & ECHO( validating random {%~2} against legal words {%~1}
FOR %%a IN (%~2) DO (
  IF "!str:#%%a#=!"=="%str%" (ECHO rejected   %%a) ELSE (ECHO validated  %%a )
)
EXIT /B 0

:END
PAUSE

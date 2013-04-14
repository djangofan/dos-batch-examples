@ECHO off

SET x=99
CALL :printsub 10
ECHO %x%
GOTO :done

:printsub
ECHO ----------
ECHO   printsub
SETLOCAL
SET /a x=%1 + 1
ECHO %x%
ENDLOCAL
ECHO ----------
EXIT /B 0

:done
PAUSE

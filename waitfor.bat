@ECHO off

ECHO %time%
CALL :waitfor 5
ECHO %time%
ECHO :done
	
:waitfor
ECHO Waiting for %1 seconds...
SETLOCAL
SET /a "t = %1 + 1"
>nul ping 127.0.0.1 -n %t%
ENDLOCAL
EXIT /B 0
	
:done
ECHO Script done.
PAUSE
	
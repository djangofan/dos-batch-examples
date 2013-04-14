@ECHO off

call :StartTimer
:: 
:: Add your script functionality here
::
call :StopTimer
call :DisplayTimerResult
pause

call :StartTimer
:: 
:: Add more script functionality here
::
call :StopTimer
call :DisplayTimerResult
goto :EOF





:StartTimer
:: Store start time
SET StartTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`ECHO %StartTIME: =0%`) do set /a Start100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
EXIT /B 0

:StopTimer
:: Get the end time
SET StopTIME=%TIME%
for /f "usebackq tokens=1-4 delims=:., " %%f in (`ECHO %StopTIME: =0%`) do set /a Stop100S=1%%f*360000+1%%g*6000+1%%h*100+1%%i-36610100
:: Test midnight rollover. If so, add 1 day=8640000 1/100ths secs
if %Stop100S% LSS %Start100S% set /a Stop100S+=8640000
SET /a TookTime=%Stop100S%-%Start100S%
SET TookTimePadded=0%TookTime%
EXIT /B 0

:DisplayTimerResult
:: Show timer start/stop/delta
ECHO Started: %StartTime%
ECHO Stopped: %StopTime%
ECHO Elapsed: %TookTime:~0,-2%.%TookTimePadded:~-2% seconds
EXIT /B 0

GOTO :EOF
:ERROR
PAUSE

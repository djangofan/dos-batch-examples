@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
set logfile=test.out
echo. 2>%logfile% 
set /A count=0
set /A lastline=0
:loop
if not %count%==100 (
  set /A count += 1
  SET PR >> %logfile%
  CALL :printlog
  goto :loop
)
goto :pause
:printlog
SET incount=0
FOR /F "delims=" %%M in (%logfile%) DO (
    set /A incount +=1
    if %incount% GEQ %lastline% (
      ECHO %%M
      SET /A lastline=%incount%
    )
)
ECHO -
EXIT /B 0
:pause
pause

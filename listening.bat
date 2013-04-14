@ECHO off
TITLE Open Ports by Process ID
SETLOCAL ENABLEDELAYEDEXPANSION
::  need to update , output to tmp file and use the dos SORT command to sort by PID
COLOR 3F
cls
SET "TAB=	"
ECHO TCP ports that are listening...
ECHO.
ECHO PID     Interface:Port
ECHO.
netstat -an -o | find "LISTENING">listening.tmp
echo. 2>ordered.tmp
for /F "tokens=1-5" %%I in (listening.tmp) do ECHO %%M,%%J,%%K,%%I>>ordered.tmp
DEL /Q listening.tmp
SORT ordered.tmp > sorted.tmp
DEL /Q ordered.tmp
for /F "tokens=1-5 delims=," %%I in (sorted.tmp) do ECHO %%I%TAB%%%J
DEL /Q sorted.tmp
ECHO.
pause
COLOR 0F


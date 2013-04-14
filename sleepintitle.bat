@ECHO off
TITLE Initial title
SET TITLETEXT=Sleep
:: start of script
CALL :sleep 5
:: rest of script
GOTO :END
:: Function
:sleep ARG
ECHO Pausing...
FOR /l %%a in (%~1,-1,1) do (TITLE %TITLETEXT% -- time left %%as&PING.exe -n 2 -w 1 127.0.0.1>nul)
EXIT /B 0
:END
pause
::this is EOF
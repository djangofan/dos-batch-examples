@ECHO off
CALL :scan
GOTO :end

:scan
ECHO Scanning for JBOSS services...
SET QUERY=%JBOSS_HOME%
ECHO. 2>infolist.txt
ECHO. 2>list.txt
ECHO. 2>servicelist.txt
SC.exe query type= service>list.txt
FOR /F "tokens=1,2" %%R IN (list.txt) DO (  
  ECHO %%R %%S | FIND "SERVICE_NAME"
  sc.exe qc %%S | FIND "BINARY" | FIND "%QUERY%"
  IF %ERRORLEVEL% EQU 1 ECHO %%S>>servicelist.txt
)
DEL /Q list.txt
DEL /Q infolist.txt
EXIT /B 0

:end
pause


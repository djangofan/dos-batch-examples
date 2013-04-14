@ECHO off
:: This script can be called to take a core dump and finish closing
:: a hung Java jvm.  This script doesn't detect the JVM crash itself
:: but it just helps clean things up if you call this after an event.
::-------
SET "PATH=%PATH%;C:\MyProgram\Javasoft\jre\bin\server"
::-------
FOR /F "tokens=2,3,4,5,6,7 delims=\" %%I in ('CD') DO (
  SET i=%%I
  SET j=%%J
  SET k=%%K
  SET l=%%L
  SET m=%%M
  SET n=%%N
)
SET HOME=%I%
IF NOT "%I%" == "" (SET SITE=%I%
) else ( GOTO :end )
IF NOT "%J%" == "" (SET SITE=%J%
) else ( GOTO :end )
IF NOT "%K%" == "" (SET SITE=%K%
) else ( GOTO :end )
IF NOT "%L%" == "" (SET SITE=%L%
) else ( GOTO :end )
IF NOT "%M%" == "" (SET SITE=%M%
) else ( GOTO :end )
IF NOT "%N%" == "" (SET SITE=%N%
) else ( GOTO :end )
:end
ECHO The parent directory name of this script is: %SITE%
ECHO Thinkstream install dir is: %HOMEDRIVE%:\%HOME%
ECHO.
::-------
:: kill process using window TITLE to find PID
FOR /F "tokens=2" %%I in ('TASKLIST /NH /FI "WINDOWTITLE eq %SITE%"' ) DO SET PID=%%I
ECHO The process id of window called %SITE% is %PID%
ECHO.
ECHO %HOMEDRIVE%\%HOME%\Javasoft\bin\jmap.exe -dump:format=b,file=heap.bin %PID%
ECHO Taking core dump... please wait...
ECHO.
%HOMEDRIVE%\%HOME%\Javasoft\bin\jmap.exe -dump:format=b,file=heap.bin %PID%
TIMEOUT 5
ECHO Killing JVM %PID%...
TASKKILL /PID %PID%
::-------
PING -n 12 127.0.0.1>nul
if ERRORLEVEL == 0 (
  EXIT 0
) else (
  PAUSE
)

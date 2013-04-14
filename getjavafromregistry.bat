@ECHO off
SET TITLE=detectJDK.bat
TITLE=%TITLE%
SETLOCAL ENABLEDELAYEDEXPANSION
IF EXIST jdkhome.txt (
  ECHO JDK home already set in jdkhome.txt file.
  GOTO :END
)
ECHO. 2>merged.txt
ECHO. 2>list.txt
ECHO. 2>uniquelist.txt
IF NOT EXIST reg32.txt ECHO. 2>reg32.txt
IF NOT EXIST reg64.txt ECHO. 2>reg64.txt
START /w REGEDIT /e reg32.txt "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\JavaSoft\Java Development Kit"
TYPE reg32.txt | FIND "JavaHome" > merged.txt
START /w REGEDIT /e reg64.txt "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Development Kit"
TYPE reg64.txt | FIND "JavaHome" >> merged.txt
FOR /f "tokens=2 delims==" %%x IN (merged.txt) DO (
  CALL :STRIP "%%~x" >>list.txt
)

FOR /F "tokens=* delims= " %%a IN (list.txt) DO (
  SET str=%%a
  FIND /I ^"!str!^" list.txt>nul
  FIND /I ^"!str!^" uniquelist.txt>nul
  IF ERRORLEVEL 1 ECHO !str!>>uniquelist.txt
)

ECHO Select a JDK from the list:
SET /A COUNT=0
FOR /f "tokens=1,* delims=" %%y IN (uniquelist.txt) DO (
  SET /A COUNT += 1
  ECHO    !COUNT!: %%~y
)
SET /P NUMBER=Type a number here: 
SET /A COUNT=0
FOR /f "tokens=1,* delims=" %%z IN (uniquelist.txt) DO (
  SET /A COUNT += 1
  IF !COUNT!==!NUMBER! (
    SET JAVA_HOME=%%~z
  )
)
ECHO.
ECHO JAVA_HOME was found to be %JAVA_HOME%
ECHO JDK_HOME=%JAVA_HOME%>jdkhome.txt
GOTO CLEANUP

:CLEANUP
DEL /Q merged.txt
DEL /Q list.txt
DEL /Q uniquelist.txt
DEL /Q reg32.txt
DEL /Q reg64.txt
GOTO :END

:: Strip quotes and extra backslash from string
:STRIP
SET n=%~1
SET n=%n:\\=\%
SET n=%n:"=%
IF NOT "%n%"=="" ECHO %n%
GOTO :EOF

:END
FOR /l %%a in (5,-1,1) do (TITLE %TITLE% -- Closing in %%as&ping -n 2 -w 1 127.0.0.1>NUL)
  
@ECHO off
ECHO ------------------------------------------------------------------
ECHO  Define the location of an existing JDK install by 
ECHO  searching for Javasoft JDK distrobution in parent 
ECHO  directories.
ECHO.
ECHO  Script does not add trailing slash.
ECHO ------------------------------------------------------------------
IF DEFINED JAVA_HOME (
  ECHO JAVA_HOME is already set.
  GOTO :JAVAHOMESET
)
SET matchobject=Javasoft\bin\java.exe
SET "dir=%~f0"
:LOOP
CALL :FGETDIR "%dir%"
IF EXIST "%dir%\%matchobject%" (
  ECHO Found JAVA_HOME at %dir%\
  GOTO :HOMESET
)
IF "%dir:~-1%" == ":" (
  ECHO Reached root and directory containing "%matchobject%" not found.
  GOTO :EOF
)
GOTO :LOOP
:HOMESET
SET JAVA_HOME=%dir%
GOTO :JAVAHOMESET
:: function section
:FGETDIR
SET "dir=%~dp1"
SET "dir=%dir:~0,-1%"
EXIT /B 0
:: end function section
:JAVAHOMESET
:: Does JAVA_HOME have a trailing slash? If so remove it.
IF !JAVA_HOME:~-1!==\ SET JAVA_HOME=!JAVA_HOME:~0,-1!
ECHO JAVA_HOME is %JAVA_HOME%
ECHO Will close in a few seconds...
ping -n 60 127.0.0.1>nul

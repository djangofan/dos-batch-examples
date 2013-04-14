@echo off
TITLE MAP S DRIVE

ECHO Begin Mapping S Drive
ECHO.
ECHO --------------------
ECHO.
SET /P username=What is your username for the S drive? 
ECHO.
ECHO.
SET /P mypassword=What is your password for the S drive? 
ECHO.
ECHO.
ECHO --------------------
cls
ECHO.
ECHO.
net use S: \\share\dev %mypassword% /USER:%username% /PERSISTENT:YES
ECHO.
ECHO --------------------
ECHO.
@echo on
pause


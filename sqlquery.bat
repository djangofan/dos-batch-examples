@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
:: batch file for sql query
SET FIELDVAL=Empty
SET DBNAME=MYDB
SET SQLSTRING=SELECT column_name(s)^
 FROM table_name1^
 INNER JOIN table_name2^
 ON table_name1.column_name=table_name2.column_name^
 AND table_name2.field=%FIELDVAL%
ECHO !SQLSTRING!

ECHO.
sqlcmd.exe -b -S localhost -E -d !DBNAME! -Q "!SQLSTRING!" -W
ECHO Query is done. Hit any key to close this window....
pause>nul

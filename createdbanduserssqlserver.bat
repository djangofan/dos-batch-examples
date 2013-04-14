@ECHO off
SETLOCAL ENABLEDELAYEDEXPANSION
TITLE Create Databases And Users

::---------------------------------------------
::  Open source free use
::  Author: Jon Austen, Last Modified: 9/26/2012
::---------------------------------------------

ECHO *************************************************
ECHO * This process will perform all steps to create *
ECHO * the databases and users for SQL Server.       *
ECHO * This must be run on the server hosting the    *
ECHO * databases.                                    *
ECHO *                                               *
ECHO *************************************************
ECHO.

::---------------------------------------------
:: Script variables
:: Do not remove the 2 consecutive blank lines below!
::---------------------------------------------
set "LA=^<"
set "RA=^>"
set NLM=^


set NL=^^^%NLM%%NLM%^%NLM%%NLM%
SET _host=%COMPUTERNAME%
SET _server=
SET _instance=.
SET _sqlURL=
SET _saUsr=sa
SET _saUsrPassword=Password1
SET _sqlDatabaseName=DEFDB
SET _sqlSystemUser=defsysuser
SET _sqlPassword=Password1
SET _sqlDatabaseUser=defuser
SET _windowsAuthentication=n

::------------------------------------------------------------------
:: Detect version of SQL Server
::------------------------------------------------------------------
SET _SQLVER=
IF EXIST "%ProgramFiles(x86)%\Microsoft SQL Server\100\Tools\BINN\osql.exe" (
  ECHO MSSQL Server 2008 or 2008R2 found.
  SET _SQLVER=100
  GOTO :sqlDetected
)
IF EXIST "%ProgramFiles(x86)%\Microsoft SQL Server\90\Tools\BINN\osql.exe" (
  ECHO MSSQL Server 2005 found.
  SET _SQLVER=90
  GOTO :sqlDetected
)
IF EXIST "%ProgramFiles(x86)%\Microsoft SQL Server\80\Tools\BINN\osql.exe" (
  ECHO MSSQL Server 2000 found.
  SET _SQLVER=80
  GOTO :sqlDetected
)
IF EXIST "%ProgramFiles%\Microsoft SQL Server\100\Tools\BINN\osql.exe" (
  ECHO MSSQL Server 2008 or 2008R2 found.
  SET _SQLVER=100
  GOTO :sqlDetected
)
IF EXIST "%ProgramFiles%\Microsoft SQL Server\90\Tools\BINN\osql.exe" (
  ECHO MSSQL Server 2005 found.
  SET _SQLVER=9
  GOTO :sqlDetected
)
IF EXIST "%ProgramFiles%\Microsoft SQL Server\80\Tools\BINN\osql.exe" (
  ECHO MSSQL Server 2000 found.
  SET _SQLVER=80
  GOTO :sqlDetected
)
IF "%_SQLVER%" == "" (
  CALL :sqlCmdError "MSSQL Server is not found." "SQLVER=%_SQLVER%"
)
:sqlDetected
ECHO Your SQL Server version is %_SQLVER% (100=2008,90=2005, and 80=2000)

::---------------------------------------------
:: Script prompts
::---------------------------------------------

:create_info
ECHO --------------------------------------------------
ECHO.
ECHO Local Database Server Connectivity Information:
ECHO.
CALL :simplePrompt ".  Enter the SQL Server machine name or IP address " _server "%COMPUTERNAME%"
CALL :simplePrompt ".  Enter the SQL Server instance name " _instance "default"
SET "_sqlURL=%_server%\%_instance%"
IF "%_instance%"=="default" SET "_sqlURL=%_server%"
IF "%_instance%"=="" SET "_sqlURL=%_server%"

CALL :confirm ".  Use WINDOWS authentication during database creation [Y]?" true _windowsAuthentication

SET _baseDirQuery=SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1) ^
 FROM master.sys.master_files WHERE database_id = 1 AND file_id = 1;
IF "%_windowsAuthentication%" == "true" GOTO :windowsAuthQuery
CALL :simplePrompt ".  Enter the name of the user with SA privileges that will create the databases " _saUsr "%_saUsr%"
CALL :simplePrompt ".  Enter the password for that user " _saUsrPassword "%_saUsrPassword%"
ECHO.
SQLCMD.EXE -b -E -U %_saUsr% -P %_saUsrPassword% -S %_sqlURL% -d master -Q "%_baseDirQuery%" -W >data_dir.tmp
IF ERRORLEVEL 1 ECHO "Error with automatically determining SQL data directory by querying your server."
:windowsAuthQuery
SQLCMD.EXE -b -E -S %_sqlURL% -d master -Q "%_baseDirQuery%" -W >data_dir.tmp
IF ERRORLEVEL 1 ECHO Error with automatically determining SQL data directory by querying your server&ECHO using Windows authentication.
CALL :getBaseDir data_dir.tmp _baseDir
:dirPrompt
ECHO.
CALL :simplePrompt ".  Enter path to your preferred Sql Server datafile directory" _baseDir "!_baseDir!"
IF "%_baseDir%" == "" GOTO :dirPrompt

:: if baseDir does not start with drive letter, re-prompt
SET "_tmpVar=%baseDir:~1,1%"
IF "_tmpVar" == ":" GOTO :dirPrompt

IF not exist "%_baseDir%" (
  ECHO Folder not found at path.  Creating folder "%_baseDir%"
  mkdir "%_baseDir%"
)
IF "%_baseDir:~-1%"=="\" SET "_baseDir=%_baseDir:~0,-1%"
DEL /Q data_dir.tmp

ECHO --------------------------------------------------
ECHO.
ECHO -- Database Information --
ECHO.
ECHO    IMPORTANT:  Any password entered for newly created users 
ECHO                must conform to SQL Server's password policy.
ECHO.
ECHO Enter credential and data store information for the database:
ECHO.
CALL :simplePrompt ".  Enter the database name" _sqlDatabaseName "%_sqlDatabaseName%"
CALL :simplePrompt ".  Enter the login user name" _sqlSystemUser "%_sqlSystemUser%"
CALL :simplePrompt ".  Enter the desired DB user name (usually same as login user)" _sqlDatabaseUser "%_sqlDatabaseUser%"
CALL :simplePrompt ".  Enter the desired DB password" _sqlPassword "%_sqlPassword%"
ECHO.
ECHO --------------------------------------------------

::----------------------------------------------------------------
:: Generate createSqlServerDatabases.sql script
:: Start by overwriting any previously existing file
:: Note: exclamation marks are escaped with 2 carrot characters
::----------------------------------------------------------------
:createFile
ECHO use [master] %NL%^
 GO>createSqlServerDatabases.sql
:createDatabase 
ECHO CREATE DATABASE [%_sqlDatabaseName%]%NL%^
 ON(	NAME =	N'%_sqlDatabaseName%', %NL%^
    FILENAME =  N'%_baseDir%\%_sqlDatabaseName%_data.MDF', %NL%^
                SIZE = 512, %NL%^
 		FILEGROWTH = 10%%) %NL%^
 LOG ON (NAME =	N'%_sqlDatabaseName%_log', %NL%^
 		FILENAME = N'%_baseDir%\%_sqlDatabaseName%_log.LDF', %NL%^
 		SIZE = 64, %NL%^
 		FILEGROWTH = 10%%) %NL%^
 COLLATE Latin1_General_CI_AS %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'ANSI null default', N'true' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'ANSI nulls', N'true' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'autoclose', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'bulkcopy', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'trunc. log', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'torn page detection', N'true' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'read only', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'dbo use', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'single', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'autoshrink', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'recursive triggers', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'concat null yields null', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'cursor close on commit', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'default to local cursor', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'quoted identifier', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'ANSI warnings', N'false' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'auto create statistics', N'true' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'auto update statistics', N'true' %NL%^
 GO %NL%^
 exec sp_dboption N'%_sqlDatabaseName%', N'db chaining', N'false' %NL%^
 GO >> createSqlServerDatabases.sql

:create_etl_repo_user
ECHO if not exists (select * from master.dbo.syslogins where loginname = N'%_sqlSystemUser%') %NL%^
 BEGIN %NL%^
   declare @loginlang nvarchar(132) %NL%^
   select @loginlang = N'us_english' %NL%^
   if @loginlang is null or (not exists (select * from master.dbo.syslanguages where name = @loginlang) and @loginlang ^^!= N'us_english') %NL%^
     select @loginlang = @@language %NL%^
 CREATE LOGIN %_sqlSystemUser% WITH PASSWORD = '%_sqlPassword%', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF, DEFAULT_DATABASE=%_sqlDatabaseName% %NL%^
 END %NL%^
 GO %NL%^
 grant alter any linked server to %_sqlSystemUser% %NL%^
 GO%NL%^
 grant alter any login to %_sqlSystemUser% %NL%^
 GO %NL%^
 use [%_sqlDatabaseName%] %NL%^
 GO %NL%^
 if not exists (select * from dbo.sysusers where name = N'%_sqlDatabaseUser%' and status ^^!= 0) %NL%^
 CREATE USER %_sqlDatabaseUser% FOR LOGIN %_sqlSystemUser% WITH DEFAULT_SCHEMA = %_sqlDatabaseUser% %NL%^
 GO %NL%^
 CREATE SCHEMA %_sqlDatabaseUser% AUTHORIZATION %_sqlDatabaseUser% %NL%^
 GO %NL%^
 exec sp_addrolemember N'db_datareader', N'%_sqlDatabaseUser%' %NL%^
 GO %NL%^
 exec sp_addrolemember N'db_datawriter', N'%_sqlDatabaseUser%' %NL%^
 GO %NL%^
 exec sp_addrolemember N'db_ddladmin', N'%_sqlDatabaseUser%' %NL%^
 GO %NL%^
 exec sp_addrolemember N'db_owner', N'%_sqlDatabaseUser%' %NL%^
 GO >> createSqlServerDatabases.sql

:: Create sample tables, in this case the sample db from CakePHP project page
ECHO --First, create our CakePHP posts table %NL%^
 CREATE TABLE posts ( %NL%^
    id INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, %NL%^
    title VARCHAR(50), %NL%^
    body TEXT, %NL%^
    created DATETIME DEFAULT NULL, %NL%^
    modified DATETIME DEFAULT NULL %NL%^
 ); %NL%^
 GO %NL%^
 -- Then insert some posts for testing %NL%^
INSERT INTO posts (title,body,created) %NL%^
    VALUES ('The title', 'This is the post body.', {fn NOW()} ); %NL%^
 GO %NL%^
INSERT INTO posts (title,body,created) %NL%^
    VALUES ('A title once again', 'And the post body follows.', {fn NOW()} ); %NL%^
 GO %NL%^
INSERT INTO posts (title,body,created) %NL%^
    VALUES ('Title strikes back', 'This is really exciting! Not.', GETDATE() ); %NL%^
 GO>> createSqlServerDatabases.sql



::---------------------------------------------
:: Execute script
::---------------------------------------------
ECHO.
ECHO.
ECHO ************************************************
ECHO * Logging into server and creating databases   *
ECHO * and users...                                 *
ECHO *                                              *
ECHO ************************************************

IF "%_windowsAuthentication%" == "false" (
  :: run commands as the _saUsr user
  ECHO SQLCMD.EXE -b -U %_saUsr% -P %_saUsrPassword% -S %_sqlURL% -d master -i createSqlServerDatabases.sql
  SQLCMD.EXE -b -U %_saUsr% -P %_saUsrPassword% -S %_sqlURL% -d master -i createSqlServerDatabases.sql
  IF ERRORLEVEL 1 CALL :sqlCmdError "Error calling createSqlServerDatabases.sql"
) ELSE (
  :: run commands with Windows authentication
  ECHO SQLCMD.EXE -b -S %_sqlURL% -d master -i createSqlServerDatabases.sql
  SQLCMD.EXE -b -S %_sqlURL% -d master -i createSqlServerDatabases.sql
  IF ERRORLEVEL 1 CALL :sqlCmdError "Error calling createSqlServerDatabases.sql"
)
GOTO :allDone

::---------------------------------------------
:: Functions that end script
::---------------------------------------------

:sqlCmdError Message1 Message2
ECHO.
ECHO.
ECHO ************************************************
ECHO * Fatal Error: SQL Server User/DB creation was unsuccessful.  
ECHO *   %~1
ECHO *   %~2
ECHO ************************************************
ECHO.
pause
GOTO :EOF

:allDone
ECHO .
ECHO .
ECHO .
ECHO ************************************************
ECHO * Create database processing is complete!      *
ECHO ************************************************
ECHO.
pause
GOTO :EOF

::---------------------------------------------
:: Functions 
::---------------------------------------------

:simplePrompt 1-question 2-Return-var 3-default-Val
SET input=%~3
IF "%~3" NEQ "" (
  :askAgain
  SET /p "input=%~1 [%~3]:"
  IF "!input!" EQU "" (
    GOTO :askAgain
  ) 
) else (
  SET /p "input=%~1 [null]: "
)	
SET "%~2=%input%"
EXIT /B 0

:confirm Question DefaultBooleanValue ReturnVar
SET %~3=%~2
SET /P _confirm=%~1
IF /I "%_confirm%" == "N" (
  SET %~3=false
  EXIT /B 0
)
IF /I "%_confirm%" == "NO" (
  SET %~3=false
  EXIT /B 0
)
IF /I "%_confirm%" == "Y" (
  SET %~3=true
  EXIT /B 0
)
IF /I "%_confirm%" == "YES" (
  SET %~3=true
  EXIT /B 0
)
IF "%_confirm%" == "" (
  ECHO     Your answer defaults to '%~2' .
  EXIT /B 0
)
ECHO Answer not understood. Using safe default of "%~2".
EXIT /B 1

:getBaseDir fileName var
:: this function could be improved
FOR /F "tokens=*" %%i IN (%~1) DO (
  SET "_line=%%i"
  IF "!_line:~1,1!" == ":" (
    SET "_baseDir=!_line!"
    EXIT /B 0
  )
)
EXIT /B 1

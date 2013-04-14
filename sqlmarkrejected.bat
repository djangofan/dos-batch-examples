@echo off
set DBSERVERNAME=THOR
set DBNAME=Process_Workflow

@echo Please wait a few seconds. Testing database connectivity using SQLCMD.EXE to %DBSERVERNAME%.%DBNAME% ...
@echo.
sqlcmd -b -S %DBSERVERNAME% -E -d %DBNAME% -Q "SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES"
if errorlevel 1 goto NOCONN
cls

:SCRIPT
@echo Database connectivity test is successful...
@echo.
@echo ######################################################################################
@echo ### You don't need to run this script as Administrator                             ###
@echo ### This script defaults to the local database named 'TS-DIR-SV.Bossier_Workflow'  ###
@echo ### This script works on Veh citations and Incident reports                        ###
@echo ######################################################################################
@echo.
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set year=%%c
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set month=%%a
for /f "tokens=2-4 delims=/ " %%a in ('date /T') do set day=%%b
set TODAY=%year%-%month%-%day%

set /P DOCID=Please enter the report number you want to set to rejected [20110000000]:
if "%DOCID%" == "" (
  @echo.
  @echo A report number must be entered. Please try again...
  GOTO INVALID
) else (
  sqlcmd -b -S %DBSERVERNAME% -E -d %DBNAME% -Q "SELECT c_document_label from df_document WHERE c_document_label = '%DOCID%';" -h-1 -o TestResult.rpt
  if errorlevel 1 goto INVALID
  set /p ROWSFOUND=<TestResult.rpt
  @echo .%ROWSFOUND%.
  if "%ROWSFOUND%"=="" (  
    @echo Report number %DOCID% didn't exist.
	GOTO INVALID
  ) else (
	sqlcmd -S %DBSERVERNAME% -E -d %DBNAME% -Q "UPDATE df_document_department_status SET n_document_status_id = '5' WHERE (n_document_id IN (SELECT n_document_id FROM df_document WHERE (c_document_label = '%DOCID%')));" -o .\MarkRejectedResult.rpt
	@echo Processed status change.
  )
)

:RESULT
TYPE MarkRejectedResult.rpt
@echo %DOCID% set to rejected on %TODAY% .
@echo %DOCID% set to rejected on %TODAY% . >> fixuplog.log
pause
GOTO ENDF
:INVALID
@echo A valid report number must be entered, rather than %DOCID%. Please try again. %TODAY% is the date. >> fixuplog.log
GOTO ENDF
:NOCONN
cls
@echo Invalid database connection to %DBSERVERNAME%.%DBNAME% ...
@echo Invalid database connection %DBSERVERNAME%.%DBNAME% ... %TODAY% is the date. >> fixuplog.log
:ENDF
@echo Script done.
pause
del MarkRejectedResult.rpt
del TestResult.rpt

@ECHO off

::/T (has W implied would work as well) sorts based on time Last Written
::/O sets the order, -D = By Date/Time, in reverse order
::/A-D only entries that are NOT directories (hence files)
::/B returns simply the filename
cls
ECHO Sorts files in current directory by date...
for /F "skip=1" %%f IN ('dir /TW /O-D /A-D') DO ECHO %%f

pause
cls
ECHO Here are the files in order...
for /F "skip=1" %%f IN ('dir /TW /O-D /A-D /B') DO ECHO %%f


pause


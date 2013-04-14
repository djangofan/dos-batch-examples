@echo off
COLOR 1F
echo The properties of this script file are:
echo This file is: %0
echo This drive is: %~d0
echo This files directory location is: %~p0
echo This files name is: %~n0
echo This files extension is: %~x0
echo This files permissions are: %~a0
echo This scripts modified date is: %~t0
echo This file is %~z0 bytes
echo Drive plus this files directory is: %~dp0
echo Current directory is: %CD%
pause

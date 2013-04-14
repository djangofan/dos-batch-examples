@echo off
if not defined PIL (
    set PIL=1
    start /min "" %~0
    exit /b
)
TITLE Hello World
echo Hello world!
pause>nul

@echo off
setlocal
REM This script sets colors of the batch file window
::    0 = Black       8 = Gray
::    1 = Blue        9 = Light Blue
::    2 = Green       A = Light Green
::    3 = Aqua        B = Light Aqua
::    4 = Red         C = Light Red
::    5 = Purple      D = Light Purple
::    6 = Yellow      E = Light Yellow
::    7 = White       F = Bright White

COLOR 75
MODE CON: COLS=120 LINES=50
pause
COLOR E2
@ECHO Pausing script ... &PAUSE&GOTO:EOF


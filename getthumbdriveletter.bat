@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: This script looks for the drive letter of a thumbdrive

echo This script is located at: %~0
echo This drive letter: %~dp0
PAUSE

REG.exe query HKLM\system\mounteddevices
for /f "tokens=1 delims= " %%I in ('REG.exe query HKLM\system\mounteddevices ^|findstr /C:"Volume"') do (
  ECHO Volume=%%I
)

:: Backup files from c: drive to thumbdrive j:
FOR %%R in (D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
  IF exist %~0 (
    SET LW=%%R
    GOTO :FOUNDDRIVE
  )
)
:FOUNDDRIVE
ECHO Thumbdrive is : %LW%
SET ThumbDriveLetter=%LW:~0,2%
ECHO ThumbDriveLetter=%ThumbDriveLetter%
ECHO REG set : %DL%

pause



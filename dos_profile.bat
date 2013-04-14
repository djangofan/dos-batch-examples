@ECHO off 
:: to install, place this .bat script in the location you want 
:: it to reside and then run this batch script with the argument "register"
IF "%1"=="register" (
  cls&ECHO.
  REG ADD "HKCU\Software\Microsoft\Command Processor\AutoRun" /ve /t REG_SZ /d "%~dp0%0" /f
  ::REG ADD "HKLM\Software\Microsoft\Command Processor\Autorun" /ve /t REG_SZ /d "%~dp0%0" /f
  ECHO The DOS profile is registered.  Load a new command prompt and test a command.
  GOTO :EOF
)
IF "%1"=="verify" (
  cls&ECHO.
  ECHO Trying to verify that doskey macros are registered...
  REG query "HKCU\Software\Microsoft\Command Processor" /s
  ::REG query "HKLM\Software\Microsoft\Command Processor" /s
  GOTO :EOF
)
IF "%1"=="delete" (
  cls&ECHO.
  ECHO Trying to delete existing doskey macro registration...
  REG delete "HKCU\Software\Microsoft\Command Processor\AutoRun" /va
  GOTO :EOF
)
ECHO -------------------------
ECHO     Customized Command Prompt
ECHO -------------------------
ECHO     Loading additional commands from:
ECHO        %~dp0%~nx0
ECHO     Type 'DOSKEY /MACROS:ALL' to see the configured commands.
ECHO ---------------------------------------------------------
DOSKEY LS=DIR /w 
DOSKEY CP=COPY $* 
DOSKEY MV=MOVE $* 
DOSKEY H=DOSKEY /HISTORY
DOSKEY WHERE=@for %%E in (%PATHEXT%) do @for %%I in ($*%%E) do @if NOT "%%~$PATH:I"=="" echo %%~$PATH:I
DOSKEY LISTEN=netstat -an ^| find "LISTEN"
DOSKEY POKE=ping -t $*
DOSKEY MACROS=DOSKEY /MACROS

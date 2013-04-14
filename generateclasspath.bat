Set RUN_CLASS_PATH=.

For %%i in (
  ..\..\j2eeclient\*
) Do Call :append_classpath %%i

:: Set RUN_CLASS_PATH=%RUN_CLASS_PATH%;%CLASSPATH%

:execute
:: Set RUN_CLASS_PATH
Goto end

:append_classpath
Set RUN_CLASS_PATH=%RUN_CLASS_PATH%;%1
Goto :EOF

:end
Endlocal

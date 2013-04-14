@rem==================================================================================
@rem==========              HTML Index Generator for Windows               ===========
@rem==========           Copyright (C) 2008   Adarsh Ramamurthy            ===========
@rem==========               www.adarshr.com/papers/indexer                ===========
@rem==================================================================================

@echo off
@setlocal

set index="index.html"

echo ^<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"^> > %index%
echo ^<html^> >> %index%
echo   ^<head^> >> %index%
echo     ^<title^>Index of %CD%^</title^> >> %index%
echo     ^<style type="text/css"^> >> %index%
echo        td,a >> %index%
echo        { >> %index%
echo          font-family: courier; >> %index%
echo          font-size: 12px; >> %index%
echo        } >> %index%
echo     ^</style^> >> %index%
echo   ^</head^> >> %index%
echo   ^<body^> >> %index%
echo     ^<h1^>Index of %CD%^</h1^> >> %index%
echo     ^<table width="100%%" cellpadding="2" cellspacing="0"^> >> %index%
echo       ^<tr^> >> %index%
echo         ^<td colspan="4"^>^<hr/^>^</td^> >> %index%
echo       ^</tr^> >> %index%

for /F "usebackq delims=" %%F in (`dir /b /a-h /og`) do (
    echo       ^<tr^> >> %index%
    echo         ^<td^>%%~aF^</td^> >> %index%
    echo         ^<td^>^<a href="file:///%%~fF"^>%%F^</a^>^</td^> >> %index%
    echo         ^<td^>%%~zF^</td^> >> %index%
    echo         ^<td^>%%~tF^</td^> >> %index%
    echo       ^</tr^> >> %index%
)

echo       ^<tr^> >> %index%
echo         ^<td colspan="4"^>^<hr/^>^</td^> >> %index%
echo       ^</tr^> >> %index%
echo     ^</table^> >> %index%
echo   ^</body^> >> %index%
echo ^</html^> >> %index%
echo.

@endlocal

@echo off


:where
doskey w=@for %%e in (%PATHEXT%) do @for %%i in (%1%%e) do @if NOT "%%~$PATH:i"=="" echo %%~$PATH:i


pause


"C:\Program Files\doxygen\bin\doxygen.exe" doxygen.cfg

@echo off
if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
pause
:normalexit
cd ..
SET SASUNIT_ROOT=..\.
SET SASUNIT_OVERWRITE=0
SET SASUNIT_LANGUAGE=de
SET SASUNIT_HOST_OS=windows
SET SASUNIT_SAS_VERSION=9.2_32
"C:\Program Files\SAS\SASFoundation\9.2(32-bit)\sas.exe" -CONFIG "bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg" -no$syntaxcheck -noovp -nosplash

@echo off
if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
pause
:normalexit
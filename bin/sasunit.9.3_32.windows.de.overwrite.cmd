@echo off
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GPL license see included file readme.txt
REM or https://sourceforge.net/p/sasunit/wiki/readme/.

cd ..
SET SASUNIT_ROOT=.
SET SASUNIT_OVERWRITE=1
SET SASUNIT_LANGUAGE=de
SET SASUNIT_HOST_OS=windows
SET SASUNIT_SAS_VERSION=9.3_32
SET SASUNIT_COVERAGEASSESSMENT=1

echo.
echo SASUnit root path     = %SASUNIT_ROOT%
echo SASUnit config        = bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg
echo Overwrite             = %SASUNIT_OVERWRITE%
echo Testcoverage          = %SASUNIT_COVERAGEASSESSMENT%
echo.

echo "Starting SASUnit in Overwrite Mode ..."
"C:\Program Files\SASHome\x86\SASFoundation\9.3\sas.exe" -CONFIG "bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg" -no$syntaxcheck -noovp -nosplash

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
pause
:normalexit
@echo off
rem Copyright 2010, 2012 HMS Analytical Software GmbH.
rem This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
rem For terms of usage under the GPL license see included file readme.txt
rem or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

cd ..
SET SASUNIT_ROOT=.
SET SASUNIT_OVERWRITE=0
SET SASUNIT_LANGUAGE=en
SET SASUNIT_HOST_OS=windows
SET SASUNIT_SAS_VERSION=9.3
SET SASUNIT_COVERAGEASSESSMENT=1

rem Check if SASUnit Jenkins Plugin is present and use given SASUnit root path
echo Checking for presence of SASUnit Jenkins plugin...
if [%1] == [] (
   echo ... parameter not found. Using SASUnit root path from skript
   echo.
) else (
   SET SASUNIT_ROOT=%1
   echo ...plugin found. Using plugin provided SASUnit root path
   echo.
)
echo.
echo SASUnit root path     = %SASUNIT_ROOT%
echo SASUnit config        = bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg
echo Overwrite             = %SASUNIT_OVERWRITE%
echo Testcoverage          = %SASUNIT_COVERAGEASSESSMENT%
echo.

rem Deletion of SASUnit styles ot avoid incompatabilites between 32 and 64 bit systems
echo Deleting SASUnit styles
echo on
del %SASUNIT_ROOT%\resources\style\*.sas7bitm

echo "Starting SASUnit ..."
"C:\Program Files\SASHome\SASFoundation\9.3\sas.exe" -CONFIG "bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg" -no$syntaxcheck -noovp -nosplash

@echo off
if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
:normalexit
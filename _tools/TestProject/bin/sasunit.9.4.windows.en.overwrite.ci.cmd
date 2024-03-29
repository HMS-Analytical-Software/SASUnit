@echo off
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

cd ..
SET SASUNIT_ROOT=..\..\.
SET SASUNIT_OVERWRITE=1
SET SASUNIT_LANGUAGE=en
SET SASUNIT_HOST_OS=windows
SET SASUNIT_SAS_VERSION=9.4
SET SASUNIT_COVERAGEASSESSMENT=1
SET SASUNIT_PGMDOC=1

REM Check if SASUnit Jenkins Plugin is present and use given SASUnit root path
echo Checking for presence of SASUnit Jenkins plugin...
if not [%1] == [] SET SASUNIT_ROOT=%~1
if [%1] == [] (
   echo ... parameter not found. Using SASUnit root path from script
   echo.
) else (
   echo ...plugin found. Using plugin provided SASUnit root path
   echo.
)
echo SASUnit root path     = %SASUNIT_ROOT%
echo SASUnit config        = bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg
echo Overwrite             = %SASUNIT_OVERWRITE%
echo Testcoverage          = %SASUNIT_COVERAGEASSESSMENT%

REM Deletion of SASUnit styles to avoid incompatibilites between 32 and 64 bit systems
echo Deleting SASUnit styles
del "%SASUNIT_ROOT%\resources\style\*.sas7bitm"

echo "Starting SASUnit in Overwrite Mode ..."
"C:\Program Files\SASHome2\SASFoundation\9.4\sas.exe" -CONFIG "bin\sasunit.%SASUNIT_SAS_VERSION%.%SASUNIT_HOST_OS%.%SASUNIT_LANGUAGE%.cfg" -no$syntaxcheck -noovp -nosplash

@echo off
if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
:normalexit
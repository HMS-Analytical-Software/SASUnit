@echo off
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

cd ..
cd ..

SET SASUNIT_ROOT=.
SET SASUNIT_TOOL_ROOT=.\_tools\SASUnitSetup
SET SASUNIT_HOST_OS=WINDOWS
SET SASUNIT_SAS_PATH=C:\Program Files\SASHome\SASFoundation
SET SASUNIT_SAS_VERSION=9.4


echo.
echo SASUnit root path         = %SASUNIT_ROOT%
echo SASUnit tools path        = %SASUNIT_TOOL_ROOT%
echo SASUnit host os           = %SASUNIT_HOST_OS%
echo SASUnit SAS path          = %SASUNIT_SAS_PATH%
echo SASUnit SAS version       = %SASUNIT_SAS_VERSION%
echo.

echo "Starting SASUnit Setup..."
"%SASUNIT_SAS_PATH%\%SASUNIT_SAS_VERSION%\sas.exe" -no$syntaxcheck -noovp -nosplash -sysin "%SASUNIT_TOOL_ROOT%\CreateSASUnitCommandFilesWIN.sas" -log "%SASUNIT_TOOL_ROOT%/CreateSASUnitCommandFilesWindows.log"

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo.
pause
:normalexit

@echo off
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GPL license see included file readme.txt
REM or https://sourceforge.net/p/sasunit/wiki/readme/.

SET SASUNIT_ROOT=C:\projects\sasunit
SET SASUNIT_PROJECT_ROOT=C:\projects\sasunit\example
SET SASUNIT_TOOL_ROOT=C:\projects\sasunit\_tools\SASUnitSetup
SET SASUNIT_HOST_OS=WINDOWS
SET SASUNIT_SAS_PATH=C:\Program Files\SASHome\SASFoundation
SET SASUNIT_SAS_VERSION=9.4
SET SASUNIT_RUNALL=C:\projects\sasunit\example\saspgm\run_all.sas

echo.
echo SASUnit root path         = %SASUNIT_ROOT%
echo SASUnit project root path = %SASUNIT_PROJECT_ROOT%
echo SASUnit tools path        = %SASUNIT_TOOL_ROOT%
echo SASUnit host os           = %SASUNIT_HOST_OS%
echo SASUnit SAS path          = %SASUNIT_SAS_PATH%
echo SASUnit SAS version       = %SASUNIT_SAS_VERSION%
echo SASUnit run all program   = %SASUNIT_RUNALL%
echo.

echo "Starting SASUnit Setup..."
"%SASUNIT_SAS_PATH%\%SASUNIT_SAS_VERSION%\sas.exe" -no$syntaxcheck -noovp -nosplash -sysin "%SASUNIT_TOOL_ROOT%\CreateSASUnitCommandFilesWIN.sas" -log "./CreateSASUnitCommandFilesHD1PCMS0268.log"

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo.
pause
:normalexit

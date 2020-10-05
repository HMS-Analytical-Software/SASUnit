@echo off
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GPL license see included file readme.txt
REM or https://sourceforge.net/p/sasunit/wiki/readme/.

cd ..
SET SASUNIT_ROOT=..\.
SET SASUNIT_PROJECTROOT=.
SET SASUNIT_HOST_OS=windows
SET SASUNIT_SAS_VERSION=9.4
SET SASUNIT_SASPATH=C:\Program Files\SASHome\SASFoundation\%SASUNIT_SAS_VERSION%
SET SASUNIT_RUNALL=saspgm/run_all.sas

echo.
echo SASUnit root path     = %SASUNIT_ROOT%
echo Project root Path     = %SASUNIT_PROJECTROOT%
echo Operating system      = %SASUNIT_HOST_OS%
echo SAS Version           = %SASUNIT_SAS_VERSION%
echo SAS Installation Path = %SASUNIT_SASPATH%
echo run_all program       = %SASUNIT_RUNALL%
echo.

echo "Creating script files for starting SASUnit ..."
"%SASUNIT_SASPATH%\sas.exe" -CONFIG "%SASUNIT_SASPATH%\nls\de\SASV9.cfg" -no$syntaxcheck -noovp -nosplash -log "../_tools/setupSASUnit.log" -sysin "../_tools/CreateSASUnitCommandFiles.sas"

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
pause
:normalexit
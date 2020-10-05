@echo off
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GPL license see included file readme.txt
REM or https://sourceforge.net/p/sasunit/wiki/readme/.

REM Call all scripts for self test, examples and test project
echo %CD%
cd ..
set START_PATH=%CD%
set EXAMPLE_PATH=%START_PATH%\example\bin
set SELFTEST_PATH=%START_PATH%\bin
set TESTPROJECT_PATH=%START_PATH%\_tools\TestProject\bin
echo Script has starting path: %START_PATH%
echo.
echo #########################################################################
echo #########################################################################
echo Starting SASUnit example project in path :%EXAMPLE_PATH%
echo #########################################################################
echo.
cd %EXAMPLE_PATH%
call sasunit.9.4.windows.en.overwrite.ci.cmd
echo.
echo #########################################################################
echo #########################################################################
echo.
echo.
echo #########################################################################
echo #########################################################################
echo Starting SASUnit self tests project in path :%SELFTEST_PATH%
echo #########################################################################
echo.
cd %SELFTEST_PATH%
call sasunit.9.4.windows.en.overwrite.ci.cmd
echo.
echo #########################################################################
echo #########################################################################
echo.
echo.
echo #########################################################################
echo #########################################################################
echo Starting SASUnit test project project in path :%TESTPROJECT_PATH%
echo #########################################################################
echo.
cd %TESTPROJECT_PATH%
call sasunit.9.4.windows.de.overwrite.ci.nopgmdoc.cmd
echo #########################################################################
echo.
cd %TESTPROJECT_PATH%
call sasunit.9.4.windows.en.overwrite.ci.cmd
echo.
echo #########################################################################
echo #########################################################################
echo.
echo.
pause
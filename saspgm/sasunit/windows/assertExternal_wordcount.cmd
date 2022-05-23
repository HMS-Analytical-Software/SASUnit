@echo off
rem This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
rem For copyright information and terms of usage under the GPL license see included file readme.txt
rem or https://sourceforge.net/p/sasunit/wiki/readme/.

SET sasunit_file=%1%
SET sasunit_expected=%~2
SET sasunit_count=

echo sasunit_file: %sasunit_file%
echo sasunit_expected: %sasunit_expected%

FOR /F "tokens=3 delims=:" %%i IN ('find /c "Lorem" %sasunit_file%') do (SET sasunit_count=%%i)

echo sasunit_count: %sasunit_count%

IF %sasunit_count% EQU %sasunit_expected% (EXIT /B 0) ELSE (EXIT /B 1)
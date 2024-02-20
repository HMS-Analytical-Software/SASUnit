@echo off
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

SET sasunit_file=%1%
SET sasunit_word=%~2
SET sasunit_expected=%~3
SET sasunit_count=

echo sasunit_file: %sasunit_file%
echo sasunit_word: %sasunit_word%
echo sasunit_expected: %sasunit_expected%

FOR /F "tokens=3 delims=:" %%i IN ('find /c "%sasunit_word%" %sasunit_file%') do (SET sasunit_count=%%i)

echo sasunit_count: %sasunit_count%

IF %sasunit_count% EQU %sasunit_expected% (EXIT /B 0) ELSE (EXIT /B 1)
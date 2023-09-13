@echo off
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

SET sasunit_expected=%1%
SET sasunit_actual=%2%
SET sasunit_diff_dest=%3%
SET sasunit_mod=%~4%
SET sasunit_threshold=%5%

ECHO sasunit_expected: %sasunit_expected%
ECHO sasunit_actual: %sasunit_actual%
ECHO sasunit_mod: %sasunit_mod%
ECHO sasunit_threshold: %sasunit_threshold%
ECHO sasunit_diff_dest: %sasunit_diff_dest%

IF [%sasunit_mod%] EQU [] (
   fc %sasunit_expected% %sasunit_actual% > %sasunit_diff_dest%

)ELSE (
   fc %sasunit_mod% %sasunit_expected% %sasunit_actual% > %sasunit_diff_dest%
)

IF errorlevel 1 (
    SET retCode=1
) ELSE (
    SET retCode=0
)

ECHO retCode: %retCode%
EXIT /B %retCode%
@echo off
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

SET sasunit_image1=%1%
SET sasunit_image2=%2%
SET sasunit_dest=%3%
SET sasunit_mod=%~4
SET sasunit_threshold=%~5

ECHO sasunit_image1: %sasunit_image1%
ECHO sasunit_image2: %sasunit_image2%
ECHO sasunit_mod: %sasunit_mod%
ECHO sasunit_dest: %sasunit_dest%
ECHO sasunit_threshold: %sasunit_threshold%

for /f %%i in ('compare %sasunit_mod% %sasunit_image1% %sasunit_image2% %sasunit_dest% ^2^>^&1') do set RC=%%i
ECHO Pixels different: %RC%

if %rc% GTR 0 (
   if %rc% GTR %sasunit_threshold% (
      SET retCode=1
   ) else (
      SET retCode=0
   )
) else (
    SET retCode=0
)

ECHO retCode: %retCode%
EXIT /B %retCode%
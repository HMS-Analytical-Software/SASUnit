@echo off
rem This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
rem For copyright information and terms of usage under the GPL license see included file readme.txt
rem or https://sourceforge.net/p/sasunit/wiki/readme/.

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
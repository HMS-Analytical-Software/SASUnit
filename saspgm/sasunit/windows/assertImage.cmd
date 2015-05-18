@echo off
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

if "%sasunit_mod%" == "" ( 
   compare %sasunit_image1% %sasunit_image2% %sasunit_dest%
)else (
   compare %sasunit_threshold% %sasunit_mod% %sasunit_image1% %sasunit_image2% %sasunit_dest%
)

if errorlevel 1 (
    SET retCode=1
) else (
    SET retCode=0
)

ECHO retCode: %retCode%
EXIT /B %retCode%
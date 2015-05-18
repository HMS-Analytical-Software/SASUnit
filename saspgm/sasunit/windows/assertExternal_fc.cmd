@echo off
SET sasunit_expected=%1%
SET sasunit_actual=%2%
SET sasunit_mod=%~3%
SET sasunit_threshold=%4%

ECHO sasunit_expected: %sasunit_expected%
ECHO sasunit_actual: %sasunit_actual%
ECHO sasunit_mod: %sasunit_mod%
ECHO sasunit_threshold: %sasunit_threshold%

IF [%sasunit_mod%] EQU [] (
   fc %sasunit_expected% %sasunit_actual%

)ELSE (
   fc %sasunit_mod% %sasunit_expected% %sasunit_actual%
)

IF errorlevel 1 (
    SET retCode=1
) ELSE (
    SET retCode=0
)

ECHO retCode: %retCode%
EXIT /B %retCode%
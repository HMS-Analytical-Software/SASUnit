@echo off
SET sasunit_actual=%1%
SET sasunit_expected=%2%
SET sasunit_mod=%~3%
SET sasunit_threshold=%4%
SET sasunit_diff_dest=%5%

ECHO sasunit_actual: %sasunit_actual%
ECHO sasunit_expected: %sasunit_expected%
ECHO sasunit_mod: %sasunit_mod%
ECHO sasunit_threshold: %sasunit_threshold%
ECHO sasunit_diff_dest: %sasunit_diff_dest%

IF [%sasunit_mod%] EQU [] (
   fc %sasunit_actual% %sasunit_expected% > %sasunit_diff_dest%

)ELSE (
   fc %sasunit_mod% %sasunit_actual% %sasunit_expected% > %sasunit_diff_dest%
)

IF errorlevel 1 (
    SET retCode=1
) ELSE (
    SET retCode=0
)

ECHO retCode: %retCode%
EXIT /B %retCode%
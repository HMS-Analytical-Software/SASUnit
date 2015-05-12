@echo off
SET sasunit_param1=%1%
SET sasunit_param2=%2%
SET sasunit_mod=%~3%
SET sasunit_threshold=%4%

ECHO sasunit_param1: %sasunit_param1%
ECHO sasunit_param2: %sasunit_param2%
ECHO sasunit_mod: %sasunit_mod%
ECHO sasunit_threshold: %sasunit_threshold%

IF [%sasunit_mod%] EQU [] (
   fc %sasunit_param1% %sasunit_param2%

)ELSE (
   fc %sasunit_mod% %sasunit_param1% %sasunit_param2%
)

IF errorlevel 1 (
    SET retCode=1
) ELSE (
    SET retCode=0
)

ECHO retCode: %retCode%
EXIT /B %retCode%
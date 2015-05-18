@echo off

SET sasunit_expected=%1%
SET sasunit_actual=%~2
SET sasunit_count=

echo sasunit_expected: %sasunit_expected%
echo sasunit_actual: %sasunit_actual%

FOR /F "tokens=3 delims=:" %%i IN ('find /c "Lorem" %sasunit_expected%') do (SET sasunit_count=%%i)

echo sasunit_count: %sasunit_count%

IF %sasunit_count% EQU %sasunit_actual% (EXIT /B 0) ELSE (EXIT /B 1)
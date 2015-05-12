@echo off
SET sasunit_file=%1%
SET sasunit_expected=%~2
SET sasunit_actual=

echo sasunit_file: %sasunit_file%
echo sasunit_expected: %sasunit_expected%

FOR /F "tokens=3 delims=:" %%i IN ('find /c "Lorem" %sasunit_file%') do (SET sasunit_actual=%%i)

echo sasunit_actual: %sasunit_actual%

IF %sasunit_actual% EQU %sasunit_expected% (EXIT /B 0) ELSE (EXIT /B 1)
REM @echo off

cd \projects

del SASUnit\SASUnit*.zip

"C:\Program Files\7-Zip\7z.exe" a -tzip SASUnit\SASUnit_v1.2.zip SASUnit\Example\* SASUnit\saspgm\sasunit\* SASUnit\saspgm\template\* SASUnit\*.txt

"C:\Program Files\7-Zip\7z.exe" t SASUnit\SASUnit_v1.2.zip -r


if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
pause
:normalexit

pause
@echo off
rem 				Copyright 2010, 2012 HMS Analytical Software GmbH.
rem         This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
rem         For terms of usage under the GPL license see included file readme.txt
rem         or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
@echo on

"C:\Program Files\doxygen\bin\doxygen.exe" doxygen.cfg

@echo off
if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
pause
:normalexit
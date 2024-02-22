@echo off
REM Start build step for Git Repositories containing SAS macros
REM This commdn file start a SAS program that gathers all changes of the current branch compred to master
REM Each changed file will be scan for SVN keywords and they will be updated
REM Afterwards a commit will be issued
REM
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

cd ../..

SET ROOT_FOLDER=%~dp0%
SET GIT_FOLDER=%cd%
SET SAS_INSTALLATION_FOLDER=C:\Program Files\SASHome\SASFoundation\9.4
SET SAS_PROGRAM=%ROOT_FOLDER%\SASBuildMakro.sas
SET SAS_LOG=%ROOT_FOLDER%\SASBuildMakro.log

echo.
echo Starting build step for SAS Macros 
echo Root Folder = %ROOT_FOLDER%
echo Git Folder  = %GIT_FOLDER%
echo SAS Folder  = %SAS_INSTALLATION_FOLDER%
echo.

"%SAS_INSTALLATION_FOLDER%\sas.exe" -CONFIG "%SAS_INSTALLATION_FOLDER%\nls\en\sasv9.cfg" -sysin %SAS_PROGRAM% -log %SAS_LOG%

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
pause
:normalexit
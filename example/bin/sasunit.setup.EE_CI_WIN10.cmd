@echo off
REM Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
REM or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

cd ..

if /i "%~1" == "" (SET SASUNIT_LANGUAGE=en) else (SET SASUNIT_LANGUAGE=%1)

REM --------------------------------------------------------------------------------
REM --- EnvVars for SAS Configuration ----------------------------------------------
SET SASUNIT_HOST_OS=windows
SET SASUNIT_HOST_ENCODING=PCOEM850
SET SASUNIT_SAS_VERSION=9.4
SET SASUNIT_SASPATH=C:\Program Files\SASHome2\SASFoundation\%SASUNIT_SAS_VERSION%
SET SASUNIT_SAS_EXE=%SASUNIT_SASPATH%\sas.exe
SET SASUNIT_SAS_CFG=%SASUNIT_SASPATH%\nls\%SASUNIT_LANGUAGE%\sasv9.cfg

REM --------------------------------------------------------------------------------
REM --- EnvVars for SAS Unit Configuration -----------------------------------------
SET SASUNIT_ROOT=%WORKSPACE%
SET SASUNIT_PROJECTROOT=%WORKSPACE%\example
SET SASUNIT_TESTDB_PATH=%SASUNIT_PROJECTROOT%\%SASUNIT_LANGUAGE%\testdb
SET SASUNIT_LOG_PATH=%SASUNIT_PROJECTROOT%\%SASUNIT_LANGUAGE%\logs
SET SASUNIT_SCN_LOG_PATH=%SASUNIT_PROJECTROOT%\%SASUNIT_LANGUAGE%\scn_logs
SET SASUNIT_REPORT_PATH=%SASUNIT_PROJECTROOT%\%SASUNIT_LANGUAGE%\doc
SET SASUNIT_RESOURCE_PATH=%SASUNIT_ROOT%\resources
SET SASUNIT_RUNALL=%SASUNIT_PROJECTROOT%\saspgm\run_all.sas
SET SASUNIT_LOG_LEVEL=INFO
SET SASUNIT_SCN_LOG_LEVEL=INFO

echo.
echo --- EnvVars for SAS Configuration ----------------------------------------------
echo Operating system                   = %SASUNIT_HOST_OS%
echo Host OS Encoding                   = %SASUNIT_HOST_ENCODING%
echo SAS Version                        = %SASUNIT_SAS_VERSION%
echo SAS Installation Path              = %SASUNIT_SASPATH%
echo SAS Executable                     = %SASUNIT_SAS_EXE%
echo SAS Config File                    = %SASUNIT_SAS_CFG%
echo --- EnvVars for SAS Unit Configuration -----------------------------------------
echo SASUnit root path                  = %SASUNIT_ROOT%
echo Project root Path                  = %SASUNIT_PROJECTROOT%
echo Path to SASUnit test database      = %SASUNIT_TESTDB_PATH%
echo Path to SASUnit log files          = %SASUNIT_LOG_PATH%
echo Path to SASUnit scenario log files = %SASUNIT_SCN_LOG_PATH%
echo Path to SASUnit documentation      = %SASUNIT_REPORT_PATH%
echo Name and path of run_all program   = %SASUNIT_RUNALL%
echo Logging level for SASUnit Suite    = %SASUNIT_LOG_LEVEL%
echo logging Level for Scenarios        = %SASUNIT_SCN_LOG_LEVEL%
echo -----------------------------------------------------------
echo.

echo "Creating script files for starting SASUnit ..."
"%SASUNIT_SAS_EXE%" -CONFIG "%SASUNIT_SAS_CFG%" -no$syntaxcheck -noovp -nosplash -log "bin/sasunit.setup.%SASUNIT_SAS_VERSION%.%SASUNIT_LANGUAGE%.log" -sysin "%SASUNIT_ROOT%/saspgm/sasunit/runsasunitsetup.sas"

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
pause
:normalexit
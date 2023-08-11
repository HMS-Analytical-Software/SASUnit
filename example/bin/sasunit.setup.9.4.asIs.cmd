@echo off
REM This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
REM For copyright information and terms of usage under the GPL license see included file readme.txt
REM or https://sourceforge.net/p/sasunit/wiki/readme/.

if /i "%~1" == "" (SET SASUNIT_LANGUAGE=en) else (SET SASUNIT_LANGUAGE=%1)

REM --------------------------------------------------------------------------------
REM --- EnvVars for SAS Configuration ----------------------------------------------
SET SASUNIT_HOST_OS=windows
SET SASUNIT_HOST_ENCODING=PCOEM850
SET SASUNIT_SAS_VERSION=9.4
SET SASUNIT_SASPATH=C:\Program Files\SASHome\SASFoundation\%SASUNIT_SAS_VERSION%
SET SASUNIT_SAS_EXE=%SASUNIT_SASPATH%\sas.exe
SET SASUNIT_SAS_CFG=%SASUNIT_SASPATH%\nls\%SASUNIT_LANGUAGE%\sasv9.cfg

SET cmd_folder=%~dp0
FOR %%f in ("%cmd_folder:~0,-1%") do set prj_folder=%%~dpf
FOR %%f in ("%prj_folder:~0,-1%") do set root_folder=%%~dpf

REM --------------------------------------------------------------------------------
REM --- EnvVars for SAS Unit Configuration -----------------------------------------
SET SASUNIT_ROOT=%root_folder%
SET SASUNIT_PROJECTROOT=%prj_folder%
SET SASUNIT_TESTDB_PATH=%SASUNIT_PROJECTROOT%\doc\sasunit\%SASUNIT_LANGUAGE%
SET SASUNIT_LOG_PATH=%SASUNIT_PROJECTROOT%\doc\sasunit\%SASUNIT_LANGUAGE%
SET SASUNIT_SCN_LOG_PATH=%SASUNIT_PROJECTROOT%\doc\sasunit\%SASUNIT_LANGUAGE%\log
SET SASUNIT_REPORT_PATH=%SASUNIT_PROJECTROOT%\doc\sasunit\%SASUNIT_LANGUAGE%\doc
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
echo Path to SASUnit resource files     = %SASUNIT_RESOURCE_PATH%
echo Name and path of run_all program   = %SASUNIT_RUNALL%
echo Logging level for SASUnit Suite    = %SASUNIT_LOG_LEVEL%
echo logging Level for Scenarios        = %SASUNIT_SCN_LOG_LEVEL%
echo --------------------------------------------------------------------------------
echo.

echo "Creating script files for starting SASUnit ..."
"%SASUNIT_SAS_EXE%" -CONFIG "%SASUNIT_SAS_CFG%" -no$syntaxcheck -noovp -nosplash -log "%SASUNIT_PROJECTROOT%/bin/sasunit.setup.%SASUNIT_SAS_VERSION%.%SASUNIT_LANGUAGE%.log" -sysin "%SASUNIT_ROOT%/saspgm/sasunit/runsasunitsetup.sas"

if %ERRORLEVEL%==0 goto normalexit
@echo. 
@echo Exit code: %ERRORLEVEL%
@echo. 
if %ERRORLEVEL%==1 @echo SAS ended with warnings. Review run_all.log for details.
if %ERRORLEVEL%==2 @echo SAS ended with errors! Check run_all.log for details!
@echo. 
pause
:normalexit
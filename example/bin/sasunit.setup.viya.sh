#!/bin/bash
# Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
# or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

cd ..

if [ -z "$1" ]; then
   export SASUNIT_LANGUAGE=en
else
   export SASUNIT_LANGUAGE=$1
fi

# --------------------------------------------------------------------------------
# --- EnvVars for SAS Configuration ----------------------------------------------
export SASUNIT_HOST_OS=linux
export SASUNIT_HOST_ENCODING=UTF8
export SASUNIT_SAS_VERSION=V.04.00
export SASUNIT_SASPATH=/opt/sas/viya/home/SASFoundation/bin
export SASUNIT_SAS_EXE=$SASUNIT_SASPATH/sas_$SASUNIT_LANGUAGE
export SASUNIT_SAS_CFG=/opt/sas/viya/home/SASFoundation/nls/$SASUNIT_LANGUAGE/sasv9.cfg

# --------------------------------------------------------------------------------
# --- EnvVars for SAS Unit Configuration -----------------------------------------
PRJ_ROOT=$(dirname $(dirname $(readlink -f "$0")))
export SASUNIT_ROOT=$(dirname $PRJ_ROOT)
export SASUNIT_PROJECT_ROOT=$PRJ_ROOT
export SASUNIT_AUTOCALL_ROOT=$PRJ_ROOT
export SASUNIT_TEST_SCENARIO_ROOT=$PRJ_ROOT
export SASUNIT_TESTDB_PATH=$SASUNIT_PROJECT_ROOT/$SASUNIT_LANGUAGE/testdb
export SASUNIT_LOG_PATH=$SASUNIT_PROJECT_ROOT/$SASUNIT_LANGUAGE/logs
export SASUNIT_SCN_LOG_PATH=$SASUNIT_PROJECT_ROOT/$SASUNIT_LANGUAGE/scn_logs
export SASUNIT_REPORT_PATH=$SASUNIT_PROJECT_ROOT/$SASUNIT_LANGUAGE/doc
export SASUNIT_RESOURCE_PATH=$SASUNIT_ROOT/resources
export SASUNIT_RUNALL=${SASUNIT_PROJECT_ROOT}saspgm/run_all.sas
export SASUNIT_LOG_LEVEL=INFO
export SASUNIT_SCN_LOG_LEVEL=INFO

echo "--- EnvVars for SAS Configuration ----------------------------------------------"
echo "Operating system                   = $SASUNIT_HOST_OS"
echo "Host OS encoding                   = $SASUNIT_HOST_ENCODING"
echo "SAS version                        = $SASUNIT_SAS_VERSION"
echo "SAS installation path              = $SASUNIT_SASPATH"
echo "SAS executable                     = $SASUNIT_SAS_EXE"
echo "SAS config file                    = $SASUNIT_SAS_CFG"
echo "--- EnvVars for SAS Unit Configuration -----------------------------------------"
echo "SASUnit root path                  = $SASUNIT_ROOT"
echo "Project root path                  = $SASUNIT_PROJECT_ROOT"
echo "Autocall Root Path                 = $SASUNIT_AUTOCALL_ROOT"
echo "Test Scenario Root Path            = $SASUNIT_TEST_SCENARIO_ROOT"
echo "Path to SASUnit test database      = $SASUNIT_TESTDB_PATH"
echo "Path to SASUnit log files          = $SASUNIT_LOG_PATH"
echo "Path to SASUnit scenario log files = $SASUNIT_SCN_LOG_PATH"
echo "Path to SASUnit documentation      = $SASUNIT_REPORT_PATH"
echo "Path to SASUnit resource files     = $SASUNIT_REPORT_PATH"
echo "Name and path of run_all program   = $SASUNIT_RUNALL"
echo "Logging level for SASUnit Suite    = $SASUNIT_LOG_LEVEL"
echo "Logging level for scenarios        = $SASUNIT_SCN_LOG_LEVEL"
echo "--------------------------------------------------------------------------------"

echo "Creating script files for starting SASUnit ..."
"$SASUNIT_SAS_EXE" -nosyntaxcheck -noovp -log "${SASUNIT_PROJECT_ROOT}bin/sasunit.setup.$SASUNIT_SAS_VERSION.$SASUNIT_LANGUAGE.log" -sysin "${SASUNIT_ROOT}saspgm/sasunit/runsasunitsetup.sas"

# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review run_all.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check run_all.log for details!\n"
fi
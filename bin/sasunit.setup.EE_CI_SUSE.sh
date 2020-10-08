#!/bin/bash
# 	     Copyright 2010, 2012 HMS Analytical Software GmbH.
#       This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
#       For terms of usage under the GPL license see included file readme.txt
#       or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

cd ..

if [ -z "$1" ]; then
   export SASUNIT_LANGUAGE=en
else
   export SASUNIT_LANGUAGE=$1
fi

# --------------------------------------------------------------------------------
# --- EnvVars for SAS Configuration ----------------------------------------------
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.3
export SASUNIT_SASPATH=/opt/sas/sas94/SASFoundation/$SASUNIT_SAS_VERSION/bin
export SASUNIT_SAS_EXE=$SASUNIT_SASPATH/sas_$SASUNIT_LANGUAGE
export SASUNIT_SAS_CFG=/opt/sas/sas94/SASFoundation/$SASUNIT_SAS_VERSION/nls/$SASUNIT_LANGUAGE/sasv9.cfg

# --------------------------------------------------------------------------------
# --- EnvVars for SAS Unit Configuration -----------------------------------------
export SASUNIT_ROOT=/usr/exchange/sasunit
export SASUNIT_PROJECTROOT=/usr/exchange/sasunit
export SASUNIT_TESTDB_PATH=$SASUNIT_PROJECTROOT/$SASUNIT_LANGUAGE/testdb
export SASUNIT_LOG_PATH=$SASUNIT_PROJECTROOT/$SASUNIT_LANGUAGE/logs
export SASUNIT_SCN_LOG_PATH=$SASUNIT_PROJECTROOT/$SASUNIT_LANGUAGE/scn_logs
export SASUNIT_REPORT_PATH=$SASUNIT_PROJECTROOT/$SASUNIT_LANGUAGE/doc
export SASUNIT_RUNALL=$SASUNIT_PROJECTROOT/saspgm/run_all.sas
export SASUNIT_LOG_LEVEL=INFO
export SASUNIT_SCN_LOG_LEVEL=INFO

echo "--- EnvVars for SAS Configuration ----------------------------------------------"
echo "Operating system                   = $SASUNIT_HOST_OS"
echo "SAS version                        = $SASUNIT_SAS_VERSION"
echo "SAS installation path              = $SASUNIT_SASPATH"
echo "SAS executable                     = $SASUNIT_SAS_EXE"
echo "SAS config file                    = $SASUNIT_SAS_CFG"
echo "--- EnvVars for SAS Unit Configuration -----------------------------------------"
echo "SASUnit root path                  = $SASUNIT_ROOT"
echo "Project root path                  = $SASUNIT_PROJECTROOT"
echo "Path to SASUnit test database      = $SASUNIT_TESTDB_PATH"
echo "Path to SASUnit log files          = $SASUNIT_LOG_PATH"
echo "Path to SASUnit scenario log files = $SASUNIT_SCN_LOG_PATH"
echo "Path to SASUnit documentation      = $SASUNIT_REPORT_PATH"
echo "Name and path of run_all program   = $SASUNIT_RUNALL"
echo "Logging level for SASUnit Suite    = $SASUNIT_LOG_LEVEL"
echo "Logging level for scenarios        = $SASUNIT_SCN_LOG_LEVEL"
echo "--------------------------------------------------------------------------------"

echo "Creating script files for starting SASUnit ..."
"$SASUNIT_SAS_EXE" -nosyntaxcheck -noovp -log "./bin/sasunit.setup.$SASUNIT_SAS_VERSION.$SASUNIT_LANGUAGE.log" -sysin "$SASUNIT_ROOT/saspgm/sasunit/runsasunitsetup.sas"

# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review run_all.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check run_all.log for details!\n"
fi
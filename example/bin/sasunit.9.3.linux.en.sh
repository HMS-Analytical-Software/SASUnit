#!/bin/bash
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GPL license see included file readme.txt
# or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

cd ..
export SASUNIT_ROOT=$(readlink -f ../.)
export SASUNIT_OVERWRITE=0
export SASUNIT_COVERAGEASSESSMENT=1
export SASUNIT_LANGUAGE=en
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.3
export SASUNIT_PGMDOC=1
export SASUNIT_PGMDOC_SASUNIT=0
export SASUNIT_CROSSREFERENCE=1
export SASUNIT_CROSSREFERENCE_SASUNIT=0
export SASUNIT_VERBOSE=0
export SASCFGPATH=./bin/sasunit.$SASUNIT_SAS_VERSION.$SASUNIT_HOST_OS.$SASUNIT_LANGUAGE.cfg

echo SASUnit root path     = $SASUNIT_ROOT
echo SASUnit config        = $SASCFGPATH
echo Overwrite             = $SASUNIT_OVERWRITE
echo Testcoverage          = $SASUNIT_COVERAGEASSESSMENT
echo Program Documentation = $SASUNIT_PGMDOC
echo PgmDoc for SASUnit    = $SASUNIT_PGMDOC_SASUNIT
echo Crossreference        = $SASUNIT_CROSSREFERENCE
echo Crossref for SASUnit  = $SASUNIT_CROSSREFERENCE_SASUNIT
echo Verbose               = $SASUNIT_VERBOSE
echo

echo "Starting SASUnit ..."
/usr/local/SASHome/SASFoundation/$SASUNIT_SAS_VERSION/bin/sas_$SASUNIT_LANGUAGE -nosyntaxcheck -noovp

# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review run_all.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check run_all.log for details!\n"
fi

if [ -f  doc/sasunit/$SASUNIT_LANGUAGE/rep/index.html ]          
  then read -p "Would you like to see the results [y|n]? "
  case "$REPLY" in
   y|Y) xdg-open doc/sasunit/$SASUNIT_LANGUAGE/rep/index.html;;
  esac
fi
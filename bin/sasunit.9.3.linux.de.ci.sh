#!/bin/bash
#						Copyright 2010, 2012 HMS Analytical Software GmbH.
#           This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
#           For terms of usage under the GPL license see included file readme.txt
#           or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

cd ..
export SASUNIT_ROOT=$(readlink -f .)
export SASUNIT_OVERWRITE=0
export SASUNIT_COVERAGEASSESSMENT=1
export SASUNIT_LANGUAGE=de
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.3
export SASCFGPATH=./bin/sasunit.$SASUNIT_SAS_VERSION.$SASUNIT_HOST_OS.$SASUNIT_LANGUAGE.cfg
echo "Starting SASUnit ..."
/usr/local/SASHome/SASFoundation/$SASUNIT_SAS_VERSION/bin/sas_$SASUNIT_LANGUAGE -nosyntaxcheck -noovp

# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review run_all.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check run_all.log for details!\n"
fi
#!/bin/bash
cd ..
export SASUNIT_ROOT=$(readlink -f ../.)
export SASUNIT_OVERWRITE=1
export SASUNIT_LANGUAGE=en
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.2
export SASCFGPATH=./bin/sasunit.$SASUNIT_SAS_VERSION.$SASUNIT_HOST_OS.$SASUNIT_LANGUAGE.cfg
echo "Starting SASUnit Examples in Overwrite Mode ..."
/usr/local/SAS/SASFoundation/$SASUNIT_SAS_VERSION/bin/sas_$SASUNIT_LANGUAGE -nosyntaxcheck -noovp
echo "SAS Exit Status: $?"          # Show SAS exit status
if [ -f  doc/sasunit/$SASUNIT_LANGUAGE/rep/index.html ]          
  then read -p "Would you like to see the results [y|n]? "
  case "$REPLY" in
   y|Y) xdg-open doc/sasunit/$SASUNIT_LANGUAGE/rep/index.html;;
  esac
fi
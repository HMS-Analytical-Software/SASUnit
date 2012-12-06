#!/bin/bash
cd ..
export SASUNIT_ROOT=$(readlink -f ../.)
export SASUNIT_OVERWRITE=0
export SASUNIT_LANGUAGE=de
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.2
export SASCFGPATH=./bin/sasunit.$SASUNIT_SAS_VERSION.$SASUNIT_HOST_OS.$SASUNIT_LANGUAGE.cfg
/usr/local/SAS/SASFoundation/$SASUNIT_SAS_VERSION/bin/sas_$SASUNIT_LANGUAGE -nosyntaxcheck -noovp 

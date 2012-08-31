#!/bin/sh
cd ..
export SASUNIT_ROOT=./
export SASUNIT_OVERWRITE=0
export SASUNIT_LANGUAGE=en
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.2
/usr/local/SAS/SASFoundation/9.2/sasexe/sas -config ./bin/sasunit.$SASUNIT_SAS_VERSION.$SASUNIT_HOST_OS.$SASUNIT_LANGUAGE.cfg -nosyntaxcheck -noovp

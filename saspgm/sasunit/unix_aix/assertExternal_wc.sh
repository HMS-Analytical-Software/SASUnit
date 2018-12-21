#!/bin/bash
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GPL license see included file readme.txt
# or https://sourceforge.net/p/sasunit/wiki/readme/.

sasunit_actual=$1
sasunit_expected=$2

echo "sasunit_actual: $sasunit_actual"
echo "sasunit_expected: $sasunit_expected"

sasunit_actual=`grep -o "Lorem" $sasunit_actual | wc -w`

echo "sasunit_actual: $sasunit_actual"

if [ "$sasunit_actual" = $sasunit_expected ]; then
   exit 0
else 
   exit 1
fi
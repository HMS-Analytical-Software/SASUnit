#!/bin/bash
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GPL license see included file readme.txt
# or https://sourceforge.net/p/sasunit/wiki/readme/.

sasunit_file=$1
sasunit_expected=$2

echo "sasunit_file: $sasunit_file"
echo "sasunit_expected: $sasunit_expected"

sasunit_count=`grep -o "Lorem" $sasunit_file | wc -w`

echo "sasunit_count: $sasunit_count"

if [ "$sasunit_count" = $sasunit_expected ]; then
   exit 0
else 
   exit 1
fi
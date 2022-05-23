#!/bin/bash
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GPL license see included file readme.txt
# or https://sourceforge.net/p/sasunit/wiki/readme/.

sasunit_expected=$1
sasunit_actual=$2
sasunit_mod=$3
sasunit_threshold=$4

echo "sasunit_actual: $sasunit_actual"
echo "sasunit_expected: $sasunit_expected"
echo "sasunit_mod: $sasunit_mod"
echo "sasunit_threshold: $sasunit_threshold"
echo "sasunit_diff_dest: $sasunit_diff_dest"

if [ "$sasunit_mod" = "" ]; then
   diff "$sasunit_expected" "$sasunit_actual"
else 
   diff $sasunit_mod "$sasunit_expected" "$sasunit_actual"
fi

rc=$?
echo "rc: $rc"
echo "Exit status of diff: 0 if inputs are the same, 1 if different, 2 if trouble."

exit $rc

#!/bin/bash

sasunit_actual=$1
sasunit_expected=$2
sasunit_mod=$3
sasunit_threshold=$4

echo "sasunit_actual: $sasunit_actual"
echo "sasunit_expected: $sasunit_expected"
echo "sasunit_mod: $sasunit_mod"
echo "sasunit_threshold: $sasunit_threshold"
echo "sasunit_diff_dest: $sasunit_diff_dest"

if [ "$sasunit_mod" = "" ]; then
   diff $sasunit_actual $sasunit_expected
else 
   diff $sasunit_mod $sasunit_actual $sasunit_expected
fi

rc=$?
echo "rc: $rc"
echo "Exit status of diff: 0 if inputs are the same, 1 if different, 2 if trouble."

exit $rc

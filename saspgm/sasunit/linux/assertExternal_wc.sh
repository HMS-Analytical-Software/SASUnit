#!/bin/bash 

sasunit_file=$1
sasunit_expected=$2

echo "sasunit_file: $sasunit_file"
echo "sasunit_expected: $sasunit_expected"

sasunit_actual=`grep -o "Lorem" $sasunit_file | wc -w`

echo "sasunit_actual: $sasunit_actual"

if [ "$sasunit_actual" = $sasunit_expected ]; then
   exit 0
else 
   exit 1
fi
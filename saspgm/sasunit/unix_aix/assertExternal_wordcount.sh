#!/bin/bash
# Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
# or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

sasunit_file=$1
sasunit_word=$2
sasunit_expected=$3

echo "sasunit_file: $sasunit_file"
echo "sasunit_word: $sasunit_word"
echo "sasunit_expected: $sasunit_expected"

sasunit_count=`grep -o $sasunit_word $sasunit_file | wc -w`

echo "sasunit_count: $sasunit_count"

if [ "$sasunit_count" = $sasunit_expected ]; then
   exit 0
else 
   exit 1
fi
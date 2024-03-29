#!/bin/bash
# Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
# or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

sasunit_image1=$1
sasunit_image2=$2
sasunit_dest=$3
sasunit_mod=$4
sasunit_threshold=$5

echo "sasunit_image1: $sasunit_image1"
echo "sasunit_image2: $sasunit_image2"
echo "sasunit_mod: $sasunit_mod"
echo "sasunit_dest: $sasunit_dest"
echo "sasunit_threshold: $sasunit_threshold"

compare $sasunit_mod "$sasunit_image1" "$sasunit_image2" "$sasunit_dest" >/dev/null 2>&1
rc=$?

if [[ "$rc" -ne "0" && "$rc" -gt "$sasunit_threshold" ]]
then
   result="1"
else
   result="0"
fi

echo "rc: $rc"
echo "result: $result"
echo "Exit status of image comparence: 0 if images are the same, >0 if different"

exit $result
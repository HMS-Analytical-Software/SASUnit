#!/bin/bash
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GPL license see included file readme.txt
# or https://sourceforge.net/p/sasunit/wiki/readme/.

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
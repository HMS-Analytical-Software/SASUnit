#!/bin/bash

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

compare $sasunit_threshold $sasunit_mod "$sasunit_image1" "$sasunit_image2" "$sasunit_dest" >/dev/null 2>&1
rc=$?

echo "rc: $rc"
echo "Exit status of image comparence: 0 if images are the same, >0 if different"

exit $rc
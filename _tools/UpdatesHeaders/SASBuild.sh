#!/bin/bash
#
# Start build step for Git Repositories containing SAS macros
# This shell script starts a SAS program that gathers all changes programs of the current branch compared to default branch
# Each changed file will be scan for SVN keywords and they will be updated
# Afterwards a commit shall be issued
#
# Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
# or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

export ROOT_FOLDER=~/git_test
export GIT_FOLDER=~/git_test
export SAS_INSTALLATION_FOLDER=/opt/sas/sas94M7/SASFoundation/9.4
export SASCFGPATH=$SAS_INSTALLATION_FOLDER/nls/en/sasv9.cfg
export SAS_PROGRAM=$ROOT_FOLDER/SASBuildMakro.sas
export SAS_LOG=$ROOT_FOLDER/SASBuildMakro.log

echo Starting build step for SAS Macros 
echo Root Folder = $ROOT_FOLDER
echo Git Folder  = $GIT_FOLDER
echo SAS Folder  = $SAS_INSTALLATION_FOLDER

"$SAS_INSTALLATION_FOLDER/bin/sas_en" -sysin $SAS_PROGRAM -log $SAS_LOG

# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review run_all.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check run_all.log for details!\n"
fi

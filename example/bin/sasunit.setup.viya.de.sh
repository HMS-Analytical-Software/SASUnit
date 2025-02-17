#!/bin/bash
# Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
# This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
# For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
# or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme.

SHELL_DIR=$(dirname $(readlink -f "$0"))

$SHELL_DIR/sasunit.setup.viya.sh de
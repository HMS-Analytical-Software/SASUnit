Documentation of SASUnit, the unit testing framework for SAS(TM)-programs on Microsoft Windows (TM). 
Version 0.910 - beta for 1.0

Copyright:
Copyright (C) 2010 HMS Analytical Software GmbH, Heidelberg, Deutschland (http://www.analytical-software.de). You can use, copy, redistribute and/or modify this software under the terms of the GNU General Public License as published by the Free Software Foundation. This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details (http://www.gnu.org/licenses/). 
SASUnit contains parts of Doxygen, see http://www.doxygen.org

System requirements:
SASUnit Version 0.910 runs on SAS(R) 9.1.3 Service Pack 4 and SAS 9.2 for Microsoft Windows(R) and on SAS 9.2 for Linux.
SAS is a product and registered trademark of SAS Institute, Cary, NC (http://www.sas.com).

Installation und windows: 
SASUnit is obtainable at http://sourceforge.net/projects/sasunit/ Unzip the contents of the ZIP-File to c:\projects\sasunit or to a directory of your choice. If you change the directory, you have to change two paths in example\saspgm\run_all.sas. Check the sasunit.xxx.cmd-files in the examples\bin directory for the correct path to the SAS executable.

Getting started:
Have a look at the documentation of SASUnit and the examples at example\doc\doxygen\html\index.html.
Have a look at the SASUnit example output at example\doc\sasunit\rep\index.html.
Write your own examples and test scenarios in example\saspgm. Test scenarios have the postfix _test.sas. If applicable, save your test data in example\dat.
Start SASUnit using example\bin\sasunit.xxx.cmd (xxx is your SAS version). SASUnit is executed in a batch SAS session that invokes each test scenario in an own SAS session.
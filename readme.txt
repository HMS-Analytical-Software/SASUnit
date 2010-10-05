Documentation of SASUnit, the unit testing framework for SAS(TM)-programs

Version 1.000 - first version with full support for SAS 9.2 under LINUX

Copyright:
Copyright (C) 2010 HMS Analytical Software GmbH, Heidelberg, Deutschland (http://www.analytical-software.de). You can use, copy, redistribute and/or modify this software under the terms of the GNU General Public License as published by the Free Software Foundation. This program is distributed WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public License for more details (http://www.gnu.org/licenses/).
SASUnit contains parts of Doxygen, see http://www.doxygen.org

System requirements:
SASUnit Version 1.000 runs on SAS(R) 9.1.3 Service Pack 4 and SAS 9.2 for Microsoft Windows(R) and on SAS 9.2 for Linux.
SAS is a product and registered trademark of SAS Institute, Cary, NC (http://www.sas.com).

Installation for SAS-programmers who want to use SASUnit and do not want to change the framework itself:
- Download ZIP-file from http://sourceforge.net/projects/sasunit
- If using ZIP-file, unzip the contents to c:\\projects\\sasunit (Windows) or to a directory of your choice (Windows or Linux).
- If you changed the directory from c:\\projects\\sasunit or under Linux, you have to change two paths in example/saspgm/run_all.sas.
- if you want to use generation of source code documentation, install doxygen from http://www.doxygen.org.
- Check the sasunit.xxx.cmd-files (windows) or SASUnit.sh (Linux) in the examples/bin directory for the correct path to the SAS (and doxygen if applicable) executable.

Getting started:
- Have a look at the documentation of SASUnit and the examples at example/doc/doxygen/html/index.html. An online version can be found at http://sasunit.sourceforge.net/doc/index.html 
- Have a look at the pre-generated example output of SASUnit at example/doc/sasunit/rep/index.html. An online version can be found at http://sasunit.sourceforge.net/rep/index.html 
- Build your own test scenarios, give them a name ending in _test.sas and store them in folder example/saspgm. Save your test data in example\\dat when needed.
- Start SASUnit with the example/bin/sasunit.xxx.cmd corresponding to your SAS version. SASUnit is executed in a batch SAS session that invokes each test scenario in an own SAS session. If you have problems, you can find the SAS log at example/doc/sasunit/run_all.log. 
- Have a look at the SASUnit example output at example/doc/sasunit/rep/index.html.

Getting the latest version of SASUnit from the SourceForge subversion repository:
The subversion repository can be found at https://sasunit.svn.sourceforge.net/svnroot/sasunit
No pre-generated source code documentation and no pre-generated output is included in the svn repository.

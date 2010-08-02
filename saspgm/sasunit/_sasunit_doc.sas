/**
   \file
   \ingroup    SASUNIT 

   \brief      Documentation of SASUnit, the unit testing framework for SAS(TM)-programs

               Version 0.910 - beta for 1.0

               Copyright:\n
               Copyright (C) 2010 HMS Analytical Software GmbH, Heidelberg, Deutschland (http://www.analytical-software.de).
               You can use, copy, redistribute and/or modify this software under the terms of the GNU General Public License
               as published by the Free Software Foundation. This program is distributed WITHOUT ANY WARRANTY; without even 
               the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
               See the GNU General Public License for more details (http://www.gnu.org/licenses/). \n
               SASUnit contains parts of Doxygen, see http://www.doxygen.org

               System requirements:\n
               SASUnit Version 0.910 runs on SAS(R) 9.1.3 Service Pack 4 and SAS 9.2 for Microsoft Windows(R) 
               and on SAS 9.2 for Linux.\n
               SAS is a product and registered trademark of SAS Institute, Cary, NC (http://www.sas.com).

               Installation under windows for programmers who want to use SASUnit 
               and do not want to change the framework itself:
               - Download SASUnit at http://sourceforge.net/projects/sasunit or with svn from 
                 https://sasunit.svn.sourceforge.net/svnroot/sasunit. When you download from svn, 
                 no pre-generated source code documentation is included.
               - Unzip the contents of the ZIP-File to c:\\projects\\sasunit or to a directory of your choice.
               - If you change the directory, you have to change two paths in example\\saspgm\\run_all.sas.\n
               - if you want to use source code documentation, install doxygen from http://www.doxygen.org.
               - Check the sasunit.xxx.cmd-files in the examples\\bin directory for the correct path to the 
                 SAS (and doxygen if applicable) executable.

               Getting started under Windows:\n
               - Have a look at the documentation of SASUnit and the examples at example\\doc\\doxygen\\html\\index.html. 
                 This is only available if you installed from a zip-download, not from svn. An online version 
                 can be found at http://sasunit.sourceforge.net/doc/index.html. 
               - run SASUnit with the example\\bin\\sasunit.xxx.cmd corresponding to your SAS version. 
                 If you have problems, you can find the SAS log at example\\doc\\sasunit\\run_all.log. 
               - Have a look at the SASUnit example output at example\\doc\\sasunit\\rep\\index.html.
               - Write your own examples and test scenarios in example\\saspgm. Test scenarios have the postfix
                 _test.sas. If applicable, save your test data in example\\dat.
               - Start SASUnit using example\\bin\\sasunit.xxx.cmd (xxx is your SAS version). 
                 SASUnit is executed in a batch SAS session that invokes each test scenario in an own SAS session. 

               Instruction for Linux: to be done. 

               Instructions for users who want to change the SASUnit framework itself: to be done. 

               Structure of a test suite (see run_all.sas):

               - \%initSASUnit (initSASUnit.sas) opens a test repository or, in case it does not yet exist, creates one.
                 Steps of \%initSASUnit:
                 - Check parameters
                 - Check whether in the path that is defined in io_target a test repository exists
                   or whether it was requested by i_overwrite to recreate the test repository. 
                   In case a test repository already exists:
                   - test repository is updated with parameters
                   Else:
                   - test repository is newly created and updated with parameters
                 - Libref target for the test repository is kept assigned

               - \%runSASUnit (runSASUnit.sas) executes one or more test scenarios.
                 The parameter i_source determines, which SAS programm is executed as a test scenario. 
                 It is possible to use DOS wildcards (e.g. *_test.sas) to execute all test scenarios
                 that match the pattern.
                 Procedure of \%runSASUnit:
                 - Check whether test repository was already initialized with \%initSASUnit, if not: End.
                 - Determination of the test scenarios to be invoked.
                 - For every test scenario:
                   - Check whether it already exists in the test repository.
                   - if yes: Check whether the test scenario was changed since last invocation.
                   - if no:  Creation of the test scenario in the test repository.
                   - In case the test scenario is new or changed:
                     - The test scenario is executed in an own SAS session which is initialized
                       by _sasunit_scenario.sas .
                       All test results are gathered in the test repository. 

               - \%reportSASUnit (reportSASUnit.sas)
                 - Check whether test repository was already initialized with \%initSASUnit, if not: End.
                 - Determination of the necessary informations out of the test repository
                 - Creation of the test report in HTML or RTF format

               - Every test scenario is a SAS program that comprises one or more
                 test cases and that is executed in an own SAS session.
                 Procedure:
                 - if applicable: prepare test data for the following test cases
                 - test case 1
                 - test case 2
                 - ...
                 - test case n
                 The test scenarios are executed by \%runSASUnit (see above).

               - Every test case comprises the following steps: 
                 - \%beginTestcase (beginTestcase.sas)
                 - test setup: if applicable, prepare test data
                 - Invocation of the program under test
                 - \%endTestcall (endTestcall.sas)
                 - Assertions, i.e. comparison of expected and actual results:
                   - \%assertEquals - Check macro variables (assertEquals.sas)
                   - \%assertColumns - Check table columns (assertColumns.sas)
                   - \%assertLog - Check the number of error and warning messages in the SAS Log (assertLog.sas)
                   - \%assertLogMsg - Check whether a certain message appears in the log (assertLogMsg.sas)
                   - \%assertReport - Check whether a report file exists and was created during the current SAS session.
                                      Optionally it is possible to write an instruction into the test protocol indicating 
                                      the need to perform a manual check of the report (assertReport.sas)
                   - \%assertLibrary - Check whether all files are identical in different libraries (assertLibrary.sas)
                 - \%endTestcase (endTestcase.sas)
 
               For creation of test scenarios, it is possible to use the following global macro variables, filenames and libnames.
               Their values are initialized by invocation of initSASUnit:
               - macro variables
                 - g_project - see parameter i_project
                 - g_target - see parameter io_target 
                 - g_root - see parameter i_root
                 - g_sasunit - see parameter i_sasunit - absolute path
                 - g_sasautos - see parameter i_sasautos - absolute path
                 - g_sasautos1..9 - see parameter i_sasautos1..9 - absolute path
                 - g_testdata - see parameter i_testdata - absolute path
                 - g_refdata - see parameter i_refdata - absolute path
                 - g_doc - see parameter i_doc - absolute path
                 - g_error - symbol for error - ERROR or FEHLER
                 - g_warning - symbol for warning - WARNING or WARNUNG
                 - g_scnid - Id number of test scenario
                 - g_work - path of work directory
                 - g_testout - see parameter io_target, subdirectory tst
                 - g_version - current version of SASUnit
                 - g_revision - current Subversion revision number
               - Libnames
                  - target - see parameter io_target
                  - testout - see parameter io_target, subdirectory tst
                  - testdata - see parameter i_testdata
                  - refdata - see parameter i_refdata
               - Filenames
                  - target - see parameter io_target
                  - testout - see parameter io_target, subdirectory tst
                  - testdata - see parameter i_testdata
                  - refdata - see parameter i_refdata
                  - doc - see parameter i_doc
               
               Structure of the test repository (directory io_target)
                  - test repository based on the following SAS files (Libref target)
                     - tsu .. one observation with the preferences for the whole test suite
                     - scn .. one observation per test scenario
                     - cas .. one observation per test case
                     - tst .. one observation per assertion
                  - subdirectories:
                     - log .. SAS logs and HTML files created out of the HTML files
                       <scenario-id>.log .. SAS log of every test scenario
                       <scenario-id>_<testcase-id>.log .. SAS log of every test case
                     - tst .. result files generated by checks of assertions (e.g. proc compare report)
                     - rep .. files generated by the report generator

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

*/

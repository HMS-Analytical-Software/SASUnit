/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST 

   \brief      Test examples for assertExternal.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
*/ /** \cond */ 

%initScenario(i_desc=Test examples for assertExternal.sas);

%MACRO _createtestfiles;
   DATA _NULL_;
      FILE "&g_work./text1.txt";
      PUT "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.";
      PUT "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute";
      PUT "iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat";
      PUT "non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
      PUT "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat";
      PUT "nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis";
      PUT "dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod";
      PUT "tincidunt ut laoreet dolore magna aliquam erat volutpat.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text1_copy.txt";
      PUT "Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.";
      PUT "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute";
      PUT "iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat";
      PUT "non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
      PUT "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat";
      PUT "nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis";
      PUT "dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod";
      PUT "tincidunt ut laoreet dolore magna aliquam erat volutpat.";
   RUN;
   
   DATA _NULL_;
      FILE "&g_work./text2.txt";
      PUT "LOREM IPSUM DOLOR SIT AMET, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua.";
      PUT "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute";
      PUT "iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat";
      PUT "non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
      PUT "Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat";
      PUT "nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis";
      PUT "dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod";
      PUT "tincidunt ut laoreet dolore magna aliquam erat volutpat.";
   RUN;
%MEND _createtestfiles;

/* create test files */
%_createtestfiles;
%LET assertExternal_work1        =&g_work./text1.txt;
%LET assertExternal_work1Copy    =&g_work./text1_copy.txt;
%LET assertExternal_work2        =&g_work./text2.txt;
%LET assertExternal_NotExistend  =&g_work./NotExistendFile;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(i_object   = assertexternal.sas
             ,i_desc     = Successful test with one path and one variable
             );
%endTestcall();

%assertExternal (i_script             =&g_sasunit_os./assertExternal_wordcount.&g_osCmdFileSuffix.
                ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) "2"
                ,i_expected_shell_rc  =0
                ,i_desc               =Word count of "Lorem" equals 2
                );
                
%assertExternal (i_script             =&g_sasunit_os./assertExternal_wordcount.&g_osCmdFileSuffix.
                ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) "3"
                ,i_expected_shell_rc  =1
                ,i_desc               =%str(Word count of "Lorem" equals 2, but i_actual=3, so i_expected_shell_rc must be 1)
                );
%endTestcase();

/* test case 2 ------------------------------------ */
%initTestcase(i_object   = assertexternal.sas
             ,i_desc     = Tests with with two paths as params und file compare command 
             );
%endTestcall();

%assertExternal (i_script             =&g_sasunit_os./assertExternal_textdiff.&g_osCmdFileSuffix.
                ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) %_adaptSASUnitPathToOS(&assertExternal_work1Copy.)
                ,i_expected_shell_rc  =0
                ,i_desc               =Compared files match
                );
                
%assertExternal (i_script             =&g_sasunit_os./assertExternal_textdiff.&g_osCmdFileSuffix.
                ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) %_adaptSASUnitPathToOS(&assertExternal_work2.)
                ,i_expected_shell_rc  =1
                ,i_desc               =Compared files do not match
                );
                
%assertExternal (i_script             =&g_sasunit_os./assertExternal_textdiff.&g_osCmdFileSuffix.
                ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) %_adaptSASUnitPathToOS(&assertExternal_work2.) &g_assertTextIgnoreCase.
                ,i_expected_shell_rc  =0
                ,i_desc               =%str(Compared files do not match, but modifier ignore case used -> test is OK)
                );
%endTestcase();

%endScenario();
/** \endcond */
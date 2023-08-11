/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertExternal.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test Test case with NOXCMD
*//** \cond */ 

%MACRO _createTestfiles;
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
%MEND _createTestfiles;

%MACRO markTestIfNOXCMD(exp,act,res);
   %if ((%sysfunc(getoption(XCMD)) = NOXCMD)) %then %do;
      %markTest()
         %assertDBValue(tst,exp,&exp.);
         %assertDBValue(tst,act,&act.);
         %assertDBValue(tst,res,&res.);
         %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
   %end;
%MEND;

%initScenario(i_desc =Test of assertExternal.sas);

/* create test files */
%_createTestfiles;
%LET assertExternal_work1        =&g_work./text1.txt;
%LET assertExternal_work1Copy    =&g_work./text1_copy.txt;
%LET assertExternal_work2        =&g_work./text2.txt;
%LET assertExternal_NotExistend  =&g_work./NotExistendFile;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(i_object   = assertexternal.sas
             ,i_desc     = Check of parameters
             );
%endTestcall()

   %assertExternal (i_script             =&assertExternal_NotExistend..&g_osCmdFileSuffix.
                   ,i_parameters         =&assertExternal_work1. whatever
                   ,i_expected_shell_rc  =Shell-Script nicht gefunden!
                   ,i_desc               =Script does not exist
                   );
   %markTest()
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
                
%assertLog (i_errors=0, i_warnings=0);
%endTestcase();


/* test case 2 ------------------------------------ */
%initTestcase(i_object   = assertexternal.sas
             ,i_desc     = Successful test with one path and one variable
             );
%endTestcall()

   %assertExternal (i_script             =&g_sasunit_os./assertExternal_wordcount.&g_osCmdFileSuffix.
                   ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) "2"
                   ,i_expected_shell_rc  =0
                   ,i_desc               =Word count of "Lorem" equals 2
                   );
   %markTestIfNOXCMD(0,0,2);
                
   %assertExternal (i_script             =&g_sasunit_os./assertExternal_wordcount.&g_osCmdFileSuffix.
                   ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) "3"
                   ,i_expected_shell_rc  =1
                   ,i_desc               =%str(Word count of "Lorem" equals 2, but i_actual=3, so i_expected_shell_rc must be 1)
                   );
   %markTestIfNOXCMD(1,0,2);

%assertLog (i_errors=0, i_warnings=0);
%endTestcase();


/* test case 3 ------------------------------------ */
%initTestcase(i_object   = assertexternal.sas
             ,i_desc     = Tests with with two paths as params und file compare command 
             );
%endTestcall()

   %assertExternal (i_script             =&g_sasunit_os./assertExternal_textdiff.&g_osCmdFileSuffix.
                   ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) %_adaptSASUnitPathToOS(&assertExternal_work1Copy.)
                   ,i_expected_shell_rc  =0
                   ,i_desc               =Compared files match
                   );
   %markTestIfNOXCMD(0,0,2);
                
   %assertExternal (i_script             =&g_sasunit_os./assertExternal_textdiff.&g_osCmdFileSuffix.
                   ,i_parameters         =%_adaptSASUnitPathToOS(&assertExternal_work1.) %_adaptSASUnitPathToOS(&assertExternal_work2.)
                   ,i_expected_shell_rc  =1
                   ,i_desc               =Compared files do not match
                   );
   %markTestIfNOXCMD(1,0,2);
                
%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

%endScenario(); 
/** \endcond */
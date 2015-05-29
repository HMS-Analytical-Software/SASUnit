/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertExternal.sas

   \version    \$Revision: 190 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-05-29 18:04:27 +0200 (Mi, 29 Mai 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/asserttableexists_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 
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

%MACRO _adaptToOS;
   %GLOBAL 
      assertExternal_script1
      assertExternal_script2
      assertExternal_NotExistend
      assertExternal_CompTool
      assertExternal_OS
      assertExternal_mod1
      assertExternal_work1
      assertExternal_work1Copy
      assertExternal_work2
   ;
   /* Prepare macro variables to adapt to OS specific test */
   %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      %LET assertExternal_script1        =%sysfunc(translate(&g_sasunit_os.\assertExternal_cnt.cmd,\,/));
      %LET assertExternal_script2        =%sysfunc(translate(&g_sasunit_os.\assertExternal_fc.cmd,\,/));
      %LET assertExternal_NotExistend    = NotExistendFile.cmd;
      %LET assertExternal_CompTool       = fc;
      %LET assertExternal_OS             =Windows;
      %LET assertExternal_mod1           =/C;
      %LET assertExternal_work1          =%sysfunc(translate(&g_work.\text1.txt,\,/));
      %LET assertExternal_work1Copy      =%sysfunc(translate(&g_work.\text1_copy.txt,\,/));
      %LET assertExternal_work2          =%sysfunc(translate(&g_work.\text2.txt,\,/));
   %END;
   %ELSE %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ linux %THEN %DO;
      %LET assertExternal_script1        = %_abspath(&g_sasunit_os.,assertExternal_wc.sh);
      %LET assertExternal_script2        = %_abspath(&g_sasunit_os.,assertExternal_diff.sh);
      %LET assertExternal_NotExistend    = NotExistendFile.sh;
      %LET assertExternal_CompTool       = diff;
      %LET assertExternal_OS             =Linux;
      %LET assertExternal_mod1           =-i;
      %LET assertExternal_work1          =%_abspath(&g_work.,text1.txt);
      %LET assertExternal_work1Copy      =%_abspath(&g_work.,text1_copy.txt);
      %LET assertExternal_work2          =%_abspath(&g_work.,text2.txt);
   %END;
%MEND _adaptToOS;


/* create test files */
%_createtestfiles;
%_adaptToOS;
%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(
             i_object   = assertexternal.sas
            ,i_desc     = Check of parameters
            );
%endTestcall()

%assertExternal (i_script             =&assertExternal_NotExistend.
                ,i_expected           =&assertExternal_work1.
                ,i_actual             =whatever
                ,i_expected_shell_rc  =Shell-Script nicht gefunden!
                ,i_expectedIsPath     =Y
                ,i_desc               =Script does not exist
                ,i_threshold          =NONE
                );
   %markTest()
      %assertDBValue(tst,act,-2)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
                
%assertExternal (i_script             =&assertExternal_script1.
                ,i_expected           =&assertExternal_NotExistend.
                ,i_actual             =whatever
                ,i_expected_shell_rc  =-3
                ,i_expectedIsPath     =Y
                ,i_desc               =Param1 is path and does not exist
                ,i_threshold          =NONE
                );
   %markTest()
      %assertDBValue(tst,act,-3)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
                
%assertExternal (i_script             =&assertExternal_script1.
                ,i_expected           =whatever
                ,i_actual             =&assertExternal_NotExistend.
                ,i_expected_shell_rc  =-4
                ,i_actualIsPath       =Y
                ,i_desc               =Param2 is path and does not exist
                ,i_threshold          =NONE
                );
   %markTest()
      %assertDBValue(tst,act,-4)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);


%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

/* test case 2 ------------------------------------ */
%initTestcase(
             i_object   = assertexternal.sas
            ,i_desc     = Successful test with one path and one variable
            );
%endTestcall()

%assertExternal (i_script             =&assertExternal_script1.
                ,i_expected           =&assertExternal_work1.
                ,i_actual             =2
                ,i_expected_shell_rc  =0
                ,i_expectedIsPath     =Y
                ,i_desc               =Word count of "Lorem" equals 2
                ,i_threshold          =NONE
                );
                
%assertExternal (i_script             =&assertExternal_script1.
                ,i_expected           =&assertExternal_work1.
                ,i_actual             =3
                ,i_expected_shell_rc  =1
                ,i_expectedIsPath     =Y
                ,i_desc               =%str(Word count of "Lorem" equals 2, but i_actual=3, so i_expected_shell_rc must be)
                ,i_threshold          =NONE
                );

/* test case 3 ------------------------------------ */
%initTestcase(
             i_object   = assertexternal.sas
            ,i_desc     = Tests with with two paths as params und file compare command 
            );
%endTestcall()

%assertExternal (i_script             =&assertExternal_script2.
                ,i_expected           =&assertExternal_work1.
                ,i_actual             =&assertExternal_work1Copy.
                ,i_expected_shell_rc  =0
                ,i_expectedIsPath     =Y
                ,i_actualIsPath       =Y
                ,i_desc               =Compared files match
                ,i_threshold          =NONE
                );
                
%assertExternal (i_script             =&assertExternal_script2.
                ,i_expected           =&assertExternal_work1.
                ,i_actual             =&assertExternal_work2.
                ,i_expected_shell_rc  =1
                ,i_expectedIsPath     =Y
                ,i_actualIsPath       =Y
                ,i_desc               =Compared files do not match
                ,i_threshold          =NONE
                );
                
%assertExternal (i_script             =&assertExternal_script2.
                ,i_expected           =&assertExternal_work1.
                ,i_actual             =&assertExternal_work2.
                ,i_expected_shell_rc  =0
                ,i_expectedIsPath     =Y
                ,i_actualIsPath       =Y
                ,i_modifier           =&assertExternal_mod1.
                ,i_desc               =%str(Compared files do not match, but modifier ignore case used -> test is OK)
                ,i_threshold          =NONE
                );
                
/** \endcond */
/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      AssertExternal allows to specify a script file that holds the logic of this assert.
               The expected return code of the script is specified in i_expected_shell_rc. All other
               return codes are treated as failed tests.

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertRecordCount.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_script               Path of shell script
   \param     i_param1               First parameter for script
   \param     i_param2               Second parameter for script
   \param     i_expected_shell_rc    Expected return code of scipt. The shell return code and i_expected_shell_rc are compared to determined 
                                     success of assert
   \param     i_modifier             Optional parameter: modifier used in script
   \param     i_threshold            Optional parameter: threshold above which the test is successful
   \param     i_param1IsPath         If put to Y, i_param1 is checked if it is a valid path
   \param     i_param2IsPath         If put to Y, i_param2 is checked if it is a valid path
   \param     i_desc                 Optional parameter: description of the assertion to be checked

*/ /** \cond */ 

%MACRO assertExternal (i_script             =
                      ,i_param1             =
                      ,i_param2             =
                      ,i_expected_shell_rc  =0
                      ,i_modifier           =
                      ,i_threshold          = NONE
                      ,i_param1IsPath       =N
                      ,i_param2IsPath       =N
                      ,i_desc               = External comparison
                      );

   %*** verify correct sequence of calls ***/
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL  l_actual
           l_cmdFile
           l_errmsg
           l_expected
           retVal
           l_rc
           l_casid
           l_tstid
           l_path
   ;
  
  %LET l_errmsg   =;
  %LET l_result   = 2;
  %LET l_rc       = 2;
  
   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** Check if i_script file exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_script.)) %THEN %DO;
      %LET l_rc = -2;
      %LET l_errMsg=Script file &i_script. does not exist!;
      %GOTO Update;
   %END;

   %*** Check if i_param1 is a path and if so, whether it exists ***;
   %IF &i_param1IsPath. EQ Y %THEN %DO; 
      %IF NOT %SYSFUNC(FILEEXIST(&i_param1.)) %THEN %DO;
         %LET l_rc = -3;
         %LET l_errMsg=Path &i_param1. does not exist!;
         %GOTO Update;
      %END;
   %END;

   %*** Check if i_param2 is a path and if so, whether it exists ***;
   %IF &i_param2IsPath. EQ Y %THEN %DO; 
      %IF NOT %SYSFUNC(FILEEXIST(&i_param2.)) %THEN %DO;
         %LET l_rc = -4;
         %LET l_errMsg=Path &i_param2. does not exist!;
         %GOTO Update;
      %END;
   %END;

   %*** get current ids for test case and test ***;
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType   =assertexternal
                         ,i_scnid        =&g_scnid.
                         ,i_casid        =&l_casid.
                         ,i_tstid        =&l_tstid.
                         ,r_path         =l_path
                         );

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;
   
   %IF %lowcase(%sysget(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      %LET xwait=%sysfunc(getoption(xwait));
      %LET xsync=%sysfunc(getoption(xsync));
      %LET xmin =%sysfunc(getoption(xmin));
      OPTIONS noxwait xsync xmin;
   %END;
   %SYSEXEC("&i_script." "&i_param1." "&i_param2." "&i_modifier." "&i_threshold.");
   %LET l_rc = &sysrc.;
   
   %IF %lowcase(%sysget(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      OPTIONS &xwait &xsync &xmin;
   %END;
   
   %IF &l_rc. = &i_expected_shell_rc. %THEN %DO;
      %LET l_result = 0;
   %END;

%UPDATE:
   %*** update result in test database ***;
   %_ASSERTS(i_type     = assertExternal
            ,i_expected = &i_expected_shell_rc.
            ,i_actual   = &l_rc.
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,i_errmsg   = &l_errmsg.
            );

%MEND assertExternal;
/** \endcond */

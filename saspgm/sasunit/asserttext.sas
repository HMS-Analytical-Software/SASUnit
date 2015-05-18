/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      This assert does a text compare 

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertRecordCount.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_script               Path of shell script
   \param     i_expected             Path of first text file (expected)
   \param     i_actual               Path of second text file (actual)
   \param     i_expected_shell_rc    Expected return value of called script i_script
   \param     i_desc                 Optional parameter: description of the assertion to be checked
   \param     i_threshold            Optional parameter: further parameter to be passed to the script
   \param     i_modifier             Optional parameter: modifiers for the compare

*/ /** \cond */ 

   %MACRO assertText (i_script            =
                     ,i_expected          =
                     ,i_actual            =
                     ,i_expected_shell_rc =0
                     ,i_modifier          =
                     ,i_desc              =Comparison of texts
                     ,i_threshold         =1
                     );

   %*** verify correct sequence of calls ***;
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL  l_actual
           l_casid 
           l_cmdFile
           l_errmsg
           l_expected
           l_path
           retVal
           l_result
           l_rc
           l_tstid
   ;

  %LET l_errmsg =;
  %LET l_result = 2;

   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** Check if i_script file exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_script.)) %THEN %DO;
      %LET l_rc = -2;
      %LET l_errMsg=Script file &i_script. does not exist!;
      %GOTO Update;
   %END;

   %*** Check if i_expected is a path and if so, whether it exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_expected.)) %THEN %DO;
      %LET l_rc = -3;
      %LET l_errMsg=Path &i_expected. does not exist!;
      %GOTO Update;
   %END;
   
   %*** Check if i_actual is a path and if so, whether it exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_actual.)) %THEN %DO;
      %LET l_rc = -4;
      %LET l_errMsg=Path &i_actual. does not exist!;
      %GOTO Update;
   %END;
   
   %*** get current ids for test case and test ***;
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType   =asserttext
                         ,i_scnid        =&g_scnid.
                         ,i_casid        =&l_casid.
                         ,i_tstid        =&l_tstid.
                         ,r_path         =l_path
                         );

   %_copyFile(i_file = &i_expected.                       /* input file */
             ,o_file = &l_path./_text_exp.txt             /* output file */
             );
   %_copyFile(i_file = &i_actual.                         /* input file */
             ,o_file = &l_path./_text_act.txt             /* output file */
             );

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;
   
   %_xcmdWithPath(i_cmd_path ="&i_script." "&i_expected." "&i_actual." "&l_path./_text_diff.txt"
                 ,i_cmd      ="&i_modifier." "&i_threshold."
                 ,r_rc       =l_rc
                 );
   
   %IF &l_rc. = &i_expected_shell_rc. %THEN %DO;
      %LET l_result = 0;
   %END;

%UPDATE:
   %*** update result in test database ***;
   %_ASSERTS(i_type     = assertText
            ,i_expected = &i_expected_shell_rc.
            ,i_actual   = &l_rc.
            ,i_desc     = &i_desc. ^nCompared files:^n&i_expected.^nand^n&i_actual.
            ,i_result   = &l_result.
            ,i_errmsg   = &l_errmsg.
            );

%MEND assertText;
/** \endcond */

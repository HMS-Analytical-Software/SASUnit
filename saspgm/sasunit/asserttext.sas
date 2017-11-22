/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      This assert does a text compare for text files. The logic doing the compare is found in a script file.

   \details    The actual compare is done via a script file found in folder saspgm/sasunit/OS.
               For windows the script file is assertText_fc.cmd. The fc command is used to do the compare.
               For Linux the script file is called assertText_diff.sh. Here the diff command is used to do the compare.
               Usage of other diff-tools is possible by changing the implementation of the script file.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_script               Path of shell script
   \param      i_expected             Path of first text file (expected)
   \param      i_actual               Path of second text file (actual)
   \param      i_expected_shell_rc    Optional parameter: Expected return value of called script i_script (default = 0)
   \param      i_modifier             Optional parameter: modifiers for the compare (default = ' ')
   \param      i_desc                 Optional parameter: description of the assertion to be checked (default = "Comparion of texts")
   \param      i_threshold            Optional parameter: further parameter to be passed to the script (default = 1)

*/ /** \cond */ 

   %MACRO assertText (i_script            =
                     ,i_expected          =
                     ,i_actual            =
                     ,i_expected_shell_rc =0
                     ,i_modifier          =
                     ,i_desc              =Comparison of texts
                     ,i_threshold         =1
                     );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase g_inTestCall;
   %IF &g_inTestCall EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %IF &g_inTestCase NE 1 %THEN %DO;
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
           l_macname
   ;

   %LET l_errmsg  =;
   %LET l_rc      =2;
   %LET l_result  =2;
   %LET l_macname =&sysmacroname;

   %*************************************************************;
   %*** Check if XCMD is allowed                              ***;
   %*************************************************************;
   %IF %_handleError(&l_macname.
                 ,NOXCMD
                 ,(%sysfunc(getoption(XCMD)) = NOXCMD)
                 ,Your SAS Session does not allow XCMD%str(,) therefore assertExternal cannot be run.
                 ,i_verbose=&g_verbose.
                 ) 
   %THEN %DO;
      %LET l_rc    =2;
      %LET l_result=2;
      %LET l_errmsg=Your SAS Session does not allow XCMD%str(,) therefore assertExternal cannot be run.;
      %GOTO Update;
   %END;

   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** Check if i_script file exists ***;
   %IF (%length(&i_script.) <= 0) %THEN %DO;
      %LET l_rc = -2;
      %LET l_errMsg=Parameter i_script is empty!;
      %GOTO Update;
   %END;
   %IF NOT %SYSFUNC(FILEEXIST(&i_script.)) %THEN %DO;
      %LET l_rc = -3;
      %LET l_errMsg=Script file &i_script. does not exist!;
      %GOTO Update;
   %END;

   %*** Check if i_expected is a path ***;
   %IF (%length(&i_expected.) <= 0) %THEN %DO;
      %LET l_rc = -4;
      %LET l_errMsg=Parameter i_expected is empty!;
      %GOTO Update;
   %END;

   %*** Check if i_actual is a path ***;
   %IF (%length(&i_actual.) <= 0) %THEN %DO;
      %LET l_rc = -6;
      %LET l_errMsg=Parameter i_actual is empty!;
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

   %IF %SYSFUNC(FILEEXIST(&i_expected.)) %THEN %DO;
      %_copyFile(i_file = &i_expected.                       /* input file */
                ,o_file = &l_path./_text_exp.txt             /* output file */
                );
   %END;

   %IF %SYSFUNC(FILEEXIST(&i_actual.)) %THEN %DO;
      %_copyFile(i_file = &i_actual.                         /* input file */
                ,o_file = &l_path./_text_act.txt             /* output file */
                );
   %END;

   %*** Check if i_expected exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_expected.)) %THEN %DO;
      %LET l_rc = -5;
      %LET l_errMsg=Path &i_expected. does not exist!;
      %GOTO Update;
   %END;
   
   %*** Check if i_actual exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_actual.)) %THEN %DO;
      %LET l_rc = -7;
      %LET l_errMsg=Path &i_actual. does not exist!;
      %GOTO Update;
   %END;
   
   %*** Check if i_expected_shell_rc is given ***;
   %IF (%length(&i_expected_shell_rc.) <= 0) %THEN %DO;
      %LET l_rc = -8;
      %LET l_errMsg=Parameter i_expected_shell_rc is empty!;
      %GOTO Update;
   %END;

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

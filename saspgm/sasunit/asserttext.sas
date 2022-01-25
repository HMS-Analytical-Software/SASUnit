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
            
   \param      i_script               Optional Parameter: Path of shell script (default=&g_sasunit_os.,assertText.&g_osCmdFileSuffix.)
   \param      i_expected             Path of first text file (expected)
   \param      i_actual               Path of second text file (actual)
   \param      i_expected_shell_rc    Optional parameter: Expected return value of called script i_script (default = 0)
   \param      i_modifier             Optional parameter: modifiers for the compare (default = ' ')
   \param      i_desc                 Optional parameter: description of the assertion to be checked (default = "Comparison of texts")
   \param      i_threshold            Optional parameter: further parameter to be passed to the script (default = 1)
*/ /** \cond */ 
%MACRO assertText (i_script            =_NONE_
                  ,i_expected          =
                  ,i_actual            =
                  ,i_expected_shell_rc =0
                  ,i_modifier          =
                  ,i_desc              =Comparison of texts
                  ,i_threshold         =1
                  );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase;
   %endTestCall(i_messageStyle=NOTE);
   %IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
      %RETURN;
   %END;

   %LOCAL  l_casid 
           l_cmdFile
           l_errmsg           
           l_expected
           l_actual
           l_path
           l_result
           l_rc
           l_tstid
           l_macname
           l_script
           l_diff_file
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
                 ,Your SAS Session does not allow XCMD%str(,) therefore assertText cannot be run.
                 ) 
   %THEN %DO;
      %LET l_rc    =0;
      %LET l_result=2;
      %LET l_errmsg=Your SAS Session does not allow XCMD%str(,) therefore assertText cannot be run.;
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
   
   %LET l_script = &i_script.;
   %IF ("&i_script." = "_NONE_") %THEN %DO;
       %LET l_script = &g_sasunit_os./assertText.&g_osCmdFileSuffix.;
   %END;
   %IF NOT %SYSFUNC(FILEEXIST(&l_script.)) %THEN %DO;
      %LET l_rc = -3;
      %LET l_errMsg=Script file &l_script. does not exist!;
      %GOTO Update;
   %END;
   %LET l_script = %_makeSASUnitPath (&l_script.);
   %LET l_script = %_adaptSASUnitPathToOS (&l_script.);

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
   %if (&g_runMode.=SASUNIT_BATCH) %then %do;
      %_createTestSubfolder (i_assertType   =asserttext
                            ,i_scnid        =&g_scnid.
                            ,i_casid        =&l_casid.
                            ,i_tstid        =&l_tstid.
                            ,r_path         =l_path
                            );

   %end;
   %else %do;
      %let l_path=%sysfunc(pathname(WORK));
   %end;
   
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
   %LET l_expected = %_makeSASUnitPath (&i_expected.);
   %LET l_expected = %_adaptSASUnitPathToOS (&l_expected.);
   
   %*** Check if i_actual exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_actual.)) %THEN %DO;
      %LET l_rc = -7;
      %LET l_errMsg=Path &i_actual. does not exist!;
      %GOTO Update;
   %END;
   %LET l_actual = %_makeSASUnitPath (&i_actual.);
   %LET l_actual = %_adaptSASUnitPathToOS (&l_actual.);
   
   %*** Check if i_expected_shell_rc is given ***;
   %IF (%length(&i_expected_shell_rc.) <= 0) %THEN %DO;
      %LET l_rc = -8;
      %LET l_errMsg=Parameter i_expected_shell_rc is empty!;
      %GOTO Update;
   %END;
   
   %LET l_diff_file = %_makeSASUnitPath (&l_path./_text_diff.txt);
   %LET l_diff_file = %_adaptSASUnitPathToOS (&l_diff_file.);

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;
   %let l_rc=HUGO;
   %PUT ------>;
   %PUT _LOCAL_;
   %_xcmdWithPath(i_cmd_path           =&l_script.
                 ,i_cmd                =&l_expected. &l_actual. &l_diff_file. "&i_modifier." "&i_threshold."
                 ,i_expected_shell_rc  =&i_expected_shell_rc.
                 ,r_rc                 =l_rc
                 );
   %PUT ------>>;
   %PUT _LOCAL_;
   
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
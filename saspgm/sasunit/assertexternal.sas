/**
   \file
   \ingroup    SASUNIT_ASSERT 

   \brief      assertExternal allows to specify a script file that holds the logic of this assert.

   \details    The expected return code of the script is specified in i_expected_shell_rc. All other
               return codes are treated as failed tests.
               The assert checks if the return code of the script matches the expected return code.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param     i_script               Path of shell script
   \param     i_parameters           Parameter for script
   \param     i_expected_shell_rc    Optional parameter: Expected return code of script. The shell return code and i_expected_shell_rc are compared 
                                     to determine success of assert (default = 0)
   \param     i_desc                 Optional parameter: description of the assertion to be checked Default = "External comparison")
*/ 
/** \cond */ 
%MACRO assertExternal (i_script             =
                      ,i_parameters         =
                      ,i_expected_shell_rc  =0
                      ,i_desc               =External comparison
                      );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase;
   %endTestCall(i_messageStyle=NOTE);
   %IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
      %RETURN;
   %END;

   %LOCAL  l_errmsg
           l_rc
           l_result
           l_macname
           l_script
   ;
  
   %LET l_errmsg   =;
   %LET l_result   =2;
   %LET l_rc       =2;
   %LET l_macname  =&sysmacroname;
  
   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** Check if i_script file exists ***;
   %let l_script = %_adaptSASUnitPathToOS(&i_script.);
   %IF NOT %SYSFUNC(FILEEXIST(&l_script.)) %THEN %DO;
      %LET l_rc = -2;
      %LET l_errMsg=Script file &i_script. (&l_script) does not exist!;
      %GOTO Update;
   %END;

   %*************************************************************;
   %*** Check if XCMD is allowed                              ***;
   %*************************************************************;
   %IF %_handleError(&l_macname.
                 ,NOXCMD
                 ,(%sysfunc(getoption(XCMD)) = NOXCMD)
                 ,Your SAS Session does not allow XCMD%str(,) therefore assertExternal cannot be run.
                 ) %THEN %DO;
      %LET l_rc    =0;
      %LET l_result=2;
      %LET l_errmsg=Your SAS Session does not allow XCMD%str(,) therefore assertExternal cannot be run.;
      %GOTO Update;
   %END;

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;
   %_xcmdWithPath(i_cmd_path           =&l_script. 
                 ,i_cmd                =&i_parameters.
                 ,i_expected_shell_rc  =&i_expected_shell_rc.
                 ,r_rc                 =l_rc
                 );

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
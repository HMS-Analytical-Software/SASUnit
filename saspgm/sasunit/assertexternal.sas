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
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_script               Path of shell script
   \param     i_expected             First parameter for script
   \param     i_actual               Second parameter for script
   \param     i_expected_shell_rc    Expected return code of scipt. The shell return code and i_expected_shell_rc are compared to determined 
                                     success of assert
   \param     i_modifier             Optional parameter: modifier used in script
   \param     i_threshold            Optional parameter: threshold above which the test is successful
   \param     i_expectedIsPath       If set to Y, i_expected is checked if it is a valid path
   \param     i_actualIsPath         If put to Y, i_actual is checked if it is a valid path
   \param     i_desc                 Optional parameter: description of the assertion to be checked

*/ /** \cond */ 

%MACRO assertExternal (i_script             =
                      ,i_expected           =
                      ,i_actual             =
                      ,i_expected_shell_rc  =0
                      ,i_modifier           =
                      ,i_threshold          =NONE
                      ,i_expectedIsPath     =N
                      ,i_actualIsPath       =N
                      ,i_desc               =External comparison
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
           l_rc
           l_result
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

   %*** Check if i_expected is a path and if so, whether it exists ***;
   %IF &i_expectedIsPath. EQ Y %THEN %DO; 
      %IF NOT %SYSFUNC(FILEEXIST(&i_expected.)) %THEN %DO;
         %LET l_rc = -3;
         %LET l_errMsg=Path &i_expected. does not exist!;
         %GOTO Update;
      %END;
   %END;

   %*** Check if i_actual is a path and if so, whether it exists ***;
   %IF &i_actualIsPath. EQ Y %THEN %DO; 
      %IF NOT %SYSFUNC(FILEEXIST(&i_actual.)) %THEN %DO;
         %LET l_rc = -4;
         %LET l_errMsg=Path &i_actual. does not exist!;
         %GOTO Update;
      %END;
   %END;

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;
   
   %_xcmdWithPath(i_cmd_path ="&i_script." "&i_expected." "&i_actual."
                 ,i_cmd      ="&i_modifier." "&i_threshold."
                 ,r_rc       =l_rc
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

/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether there are differences between the value of a macro variable and an expected value. 
   
               The values can be character string or numerical. <br />
               Optionally one can define a deviation for numerical values so that the  values can be deviating from each other less than a maximal deviation of i_fuzz.

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_expected     expected value
   \param   i_actual       actual value
   \param   i_desc         description of the assertion to be checked \n
                           default: "Compare Values"
   \param   i_fuzz         optional: maximal deviation of expected and actual values, 
                           only for numerical values 
                           
*/ /** \cond */ 

%MACRO assertEquals (i_expected =      
                    ,i_actual   =      
                    ,i_desc     = Compare Values
                    ,i_fuzz     =      
                    );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_expected;
   %LET l_expected = &i_expected;
   %LOCAL l_result;

   /* alphanumerical value? */
   %IF   %sysfunc(prxmatch("^[0-9]*.?[0-9]*$",&i_expected))=0 
      OR %sysfunc(prxmatch("^[0-9]*.?[0-9]*$",&i_actual))=0 %THEN %DO; 
      %LET l_result = %eval(("&i_expected" NE "&i_actual")*2);
   %END; 
   /* numerical value and fuzz specified ? */
   %ELSE %IF %quote(&i_fuzz) NE %THEN %DO;
      %LET l_expected = %quote(&l_expected(+-&i_fuzz)); 
      %IF %sysevalf(%sysfunc(abs(%sysevalf(&i_expected - &i_actual))) <= &i_fuzz) 
         %THEN %LET l_result = 0;
      %ELSE %LET l_result = 2;
   %END;
   /* numerical without fuzz */
   %ELSE %DO;
      %IF %quote(&i_expected) = %quote(&i_actual)
         %THEN %LET l_result = 0;
      %ELSE %LET l_result = 2;
   %END;

   %_asserts(
       i_type     = assertEquals
      ,i_expected = &l_expected
      ,i_actual   = &i_actual
      ,i_desc     = &i_desc
      ,i_result   = &l_result
   )
%MEND assertEquals;
/** \endcond */

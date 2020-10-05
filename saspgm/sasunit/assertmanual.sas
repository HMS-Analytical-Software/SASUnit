/** 
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether there are differences between the value of a macro variable and an expected value. 
   
               The values can be character string or numerical.
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
            
   \param   i_desc         description of the assertion to be checked \n
                           default: "Manual assert (placeholder)"
                           
*/ /** \cond */ 
%MACRO assertManual (i_desc =Manual assert serves as placeholder);

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase;
   %endTestCall(i_messageStyle=NOTE);
   %IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
      %RETURN;
   %END;

   %_asserts(
       i_type     =assertManual
      ,i_expected =
      ,i_actual   =
      ,i_desc     =&i_desc.
      ,i_result   =1
   )
%MEND assertManual;
/** \endcond */
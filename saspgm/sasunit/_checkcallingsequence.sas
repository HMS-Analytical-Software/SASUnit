/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      check for correct calling sequence

   \version    \$Revision: 635 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-02-28 16:50:25 +0100 (Do, 28 Feb 2019) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_checklog.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param    i_callerType  Type of macro calling (scenario, asssert)

*/
/** \cond */ 
%MACRO _checkCallingSequence(i_callerType  =);

   %global g_inScenario g_inTestCase g_inTestCall;
   
   %let l_callerType = %lowcase (&i_callerType.);

   %if (&l_callertype.=scenario) %then %do;
      %if (&g_inScenario. = 1) %then %do;
         %PUT &g_error.: initScenario must not be called twice!;
         1
         %RETURN;
      %end;
      %if (&g_inTestCall. = 1) %then %do;
         %PUT &g_error.: initScenario must not be called within a test call!;
         1
         %RETURN;
      %end;
      %if (&g_inTestcase. = 1) %then %do;
         %PUT &g_error.: initScenario must not be called within a test case!;
         1
         %RETURN;
      %end;
      0
      %RETURN;
   %end;
   %if (&l_callertype.=assert) %then %do;
      %if (&g_inScenario. = 0) %then %do;
         %PUT &g_error.: Assert must be called after initScenario!;
         1
         %RETURN;
      %end;
      %if (&g_inTestcase. = 0) %then %do;
         %PUT &g_error.: Assert must be called after initTestCase!;
         1
         %RETURN;
      %end;
      0
      %RETURN;
   %end;
   -1
%MEND _checkcallingSequence;
/** \endcond */

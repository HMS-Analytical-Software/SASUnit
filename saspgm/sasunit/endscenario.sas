/**
   \file
   \ingroup  SASUNIT_UTIL

   \brief    ends scenario call in interactive sessions

   \version    \$Revision: 451 $
   \author     \$Author: klandwich $
   \date       \$Date: 2015-09-07 08:49:43 +0200 (Mo, 07 Sep 2015) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_checklog.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param    o_environment
   \param    o_starttype
*/
/** \cond */ 
%MACRO endScenario();
   %global g_inTestCase g_inTestCall g_scnID;
   
/* Geht erst ab SAS Version 9.3
   %endTestcase
*/
/* Wegen SAS Version 9.2 muss es noch so gemacht werden */
   %IF &g_inTestCase. EQ 1 %THEN %DO;
      %endTestcase
   %END;
/* Wegen SAS Version 9.2 muss es noch so gemacht werden */

   %if (&g_runmode. = SASUNIT_INTERACTIVE) %then %do;
      proc print data=target.scn noobs label;
         where scn_id = &G_SCNID.;
      run;
      proc print data=target.cas noobs label;
         where cas_scnid = &G_SCNID.;
      run;
      proc print data=target.tst noobs label;
         where tst_scnid = &G_SCNID.;
      run;
   %end;
%MEND endScenario;
/** \endcond */

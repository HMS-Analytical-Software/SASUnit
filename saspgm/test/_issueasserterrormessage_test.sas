/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _issueasserterrormessage.sas

   \version    \$Revision: 659 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-04-25 16:01:34 +0200 (Do, 25 Apr 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_createrepdata_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _issueasserterrormessage.sas);

%macro testcase(i_object=_issueasserterrormessage.sas, i_desc=%str(Call with logging level Info, which is default));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   %let g_UseLog4SAS = 1;
   
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueasserterrormessage(Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=1, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();
/** \endcond */
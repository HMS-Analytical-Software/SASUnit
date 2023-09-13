/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _issueassertwarningmessage.sas

   \version    \$Revision: 659 $
   \author     \$Author: klandwich $
   \date       \$Date: 2019-04-25 16:01:34 +0200 (Do, 25 Apr 2019) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_createrepdata_test.sas $
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
   \test Add test cases to check all error messages
*/ /** \cond */ 

%initScenario (i_desc=Test of _issueassertwarningmessage.sas);

%macro testcase(i_object=_issueassertwarningmessage.sas, i_desc=%str(Correct call of examinee));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueassertwarningmessage(Dies ist meine Warnmeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=1);
   %assertLogMsg  (i_logMsg=^WARNING: Dies ist meine Warnmeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();
/** \endcond */
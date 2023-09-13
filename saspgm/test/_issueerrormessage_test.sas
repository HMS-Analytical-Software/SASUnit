/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _issueerrormessage.sas

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

%initScenario (i_desc=Test of _issueerrormessage.sas);

%macro testcase(i_object=_issueerrormessage.sas, i_desc=%str(Call with logging level Fatal));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local l_localLogger;
   %let l_localLogger = App.Program.SASUnit.TestLogger;
   %_createLog4SASLogger(loggername=&l_localLogger.
                        ,additivity=FALSE
                        ,level=FATAL
                        );

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueerrormessage(&l_localLogger., Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=0, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!
                  ,i_not   =1
                  );

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_issueerrormessage.sas, i_desc=%str(Call with logging level Error));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local l_localLogger;
   %let l_localLogger = App.Program.SASUnit.TestLogger;
   %_createLog4SASLogger(loggername=&l_localLogger.
                        ,additivity=FALSE
                        ,level=ERROR
                        );

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueerrormessage(&l_localLogger., Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=1, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_issueerrormessage.sas, i_desc=%str(Call with logging level Warning));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local l_localLogger;
   %let l_localLogger = App.Program.SASUnit.TestLogger;
   %_createLog4SASLogger(loggername=&l_localLogger.
                        ,additivity=FALSE
                        ,level=WARN
                        );

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueerrormessage(&l_localLogger., Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=1, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_issueerrormessage.sas, i_desc=%str(Call with logging level Info, which is default));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local l_localLogger;
   %let l_localLogger = App.Program.SASUnit.TestLogger;
   %_createLog4SASLogger(loggername=&l_localLogger.
                        ,additivity=FALSE
                        ,level=INFO
                        );

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueerrormessage(&l_localLogger., Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=1, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_issueerrormessage.sas, i_desc=%str(Call with logging level Debug));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local l_localLogger;
   %let l_localLogger = App.Program.SASUnit.TestLogger;
   %_createLog4SASLogger(loggername=&l_localLogger.
                        ,additivity=FALSE
                        ,level=DEBUG
                        );

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueerrormessage(&l_localLogger., Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=1, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%macro testcase(i_object=_issueerrormessage.sas, i_desc=%str(Call with logging level Trace));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/
   %local l_localLogger;
   %let l_localLogger = App.Program.SASUnit.TestLogger;
   %_createLog4SASLogger(loggername=&l_localLogger.
                        ,additivity=FALSE
                        ,level=TRACE
                        );

   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_issueerrormessage(&l_localLogger., Dies ist meine Fehlermeldung!);

   %endTestcall()

   /* assert */
   %assertLog     (i_errors=1, i_warnings=0);
   %assertLogMsg  (i_logMsg=^ERROR: Dies ist meine Fehlermeldung!);

   /* end testcase */
   %endTestcase()
%mend testcase; %testcase;

%endScenario();
/** \endcond */
/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createLogConfigFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _createLogConfigFile.sas);

%macro testcase(i_object=_createLogConfigFile.sas, i_desc=%str(Correct call));
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
   %_createLogConfigFile(i_projectBinFolder=%sysfunc(pathname(WORK))
                        ,i_sasunitLogFolder=./logs
                        ,i_sasunitLanguage =XX
                        );
   %endTestcall()

   /* assert */
   %assertLog(i_errors=0, i_warnings=0);
   %assertEquals (i_actual  =%sysfunc(fileexist(%sysfunc(pathname(WORK))/sasunit.logconfig.xx.xml))
                 ,i_expected=1
                 ,i_desc    =New log config xml file must exist
                 );

   %assertText (i_expected = &g_refdata./sasunit.logconfig.xx.xml
               ,i_actual   = %sysfunc(pathname(WORK))/sasunit.logconfig.xx.xml
               ,i_desc     = Log config file created correctly
               );

   /* end testcase */
   %endTestcase()

   filename fdel "%sysfunc(pathname(WORK))/sasunit.logconfig.xx.xml";
   %put %sysfunc(fdelete(fdel));
   filename fdel clear;
%mend testcase; %testcase;

%endScenario();
/** \endcond */
/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createScnLogConfigXmlFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _createScnLogConfigXmlFile.sas);

%macro testcase(i_object=_createScnLogConfigXmlFile.sas, i_desc=%str(Correct call));
   /*****************
   documentation
   ******************
   setup  [...] 
   call   [...]
   assert [...]
   *****************/

   %_createScnLogConfigTemplate(i_projectBinFolder    =%sysfunc(pathname(WORK))
                               ,i_sasunitLogFolder    =%sysfunc(pathname(WORK))/logs
                               ,i_sasunitScnLogfolder =%sysfunc(pathname(WORK))/scnLogs
                               ,i_sasunitLanguage     =XX
                               );
                               
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_createScnLogConfigXmlFile(i_projectBinFolder =%sysfunc(pathname(WORK))
                              ,i_scnid            =0X0
                              ,i_sasunitLanguage  =XX
                              ,o_scnLogConfigfile =%sysfunc(pathname(WORK))\sasunit.scnlogconfig.xx.xml
                              );

   %endTestcall()

   /* assert */
   %assertLog(i_errors=0, i_warnings=0);
   %assertEquals (i_actual  =%sysfunc(fileexist(%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xx.xml))
                 ,i_expected=1
                 ,i_desc    =New scn log config xml file must exist
                 );
                 
   /* end testcase */
   %endTestcase()

   filename fdel "%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xx.template.xml";
   %put %sysfunc(fdelete(fdel));
   filename fdel clear;
   filename fdel "%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xx.xml";
   %put %sysfunc(fdelete(fdel));
   filename fdel clear;
%mend testcase; %testcase;

%endScenario();
/** \endcond */

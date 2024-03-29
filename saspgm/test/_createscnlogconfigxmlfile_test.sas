/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createScnLogConfigXmlFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

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
                               ,i_sasunitLogFolder    =./logs
                               ,i_sasunitScnLogfolder =./scnLogs
                               ,i_sasunitLanguage     =xx
                               );
                               
   /* start testcase */
   %initTestcase(i_object=&i_object., i_desc=&i_desc.);

   /* call */
   %_createScnLogConfigXmlFile(i_projectBinFolder =%sysfunc(pathname(WORK))
                              ,i_scnid            =0X0
                              ,i_sasunitLanguage  =xx
                              ,o_scnLogConfigfile =%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xx.xml
                              );

   %endTestcall()

   /* assert */
   %assertLog(i_errors=0, i_warnings=0);
   %assertEquals (i_actual  =%sysfunc(fileexist(%sysfunc(pathname(WORK))/sasunit.scnlogconfig.xx.xml))
                 ,i_expected=1
                 ,i_desc    =New scn log config xml file must exist
                 );

   %assertText (i_expected = &g_refdata./sasunit.scnlogconfig.xx.xml
               ,i_actual   = %sysfunc(pathname(WORK))/sasunit.scnlogconfig.xx.xml
               ,i_desc     = Scn-Log config file created correctly
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

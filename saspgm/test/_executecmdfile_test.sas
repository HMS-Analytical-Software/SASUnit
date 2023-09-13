/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _executeCmdFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
      
%initScenario (i_desc=Test of _executeCmdFile.sas)

%let path = %sysfunc (pathname(WORK));
data _null_;
   file "&path./createfolder.cmd";
   put "&g_makedir. ""&path./TestFolder""";
run;

%initTestcase(i_object=_executeCmdFile.sas, i_desc=check call of program)

%_executeCmdFile(&path./createfolder.cmd);

%endTestCall;

%assertEquals(i_expected=1, i_actual=%_existdir(&path./TestFolder), i_desc=Folder should exist)
%assertLog()
%endTestcase()

%endScenario();
/** \endcond */
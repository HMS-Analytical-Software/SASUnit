/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _mkDir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \test Add test cases to check all error messages
         Existing folder with log level TRACE
         Error when folder could not be created
*/ /** \cond */ 
%initScenario (i_desc=Test of _mkDir.sas);

%initTestcase(i_object=_mkDir.sas, i_desc=Test with correct call)
%let newdir=%sysfunc(pathname(work))/folder;
%_mkdir(&newdir.);
%endTestcall;

%assertEquals(i_expected=1,  i_actual=%_existDir(&newdir.),  i_desc=check on file existence)
%endTestcase;

%initTestcase(i_object=_mkDir.sas, i_desc=Test with folder and subfolder to be created. No creation but message)
%let newdir=%sysfunc(pathname(work))/folder1/subfolder;
%_mkdir(&newdir.);
%endTestcall;

%assertLog(i_errors=1, i_warnings=0)
%assertLogMsg(i_logMsg=ERROR: _mkdir: Parentfolder .+folder1 does not exist)
%assertEquals(i_expected=0,  i_actual=%_existDir(&newdir.),  i_desc=check on file existence)
%endTestcase;

%initTestcase(i_object=_mkDir.sas, i_desc=Test with folder and subfolder to be created.)
%let newdir=%sysfunc(pathname(work))/folder1/subfolder;
%_mkdir(&newdir., makeCompletePath=1);
%endTestcall;

%assertEquals(i_expected=1,  i_actual=%_existDir(&newdir.),  i_desc=check on file existence)
%endTestcase;

%endScenario();
/** \endcond */
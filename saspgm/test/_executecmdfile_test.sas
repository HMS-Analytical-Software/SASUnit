/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _executeCmdFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
      
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

/** \endcond */

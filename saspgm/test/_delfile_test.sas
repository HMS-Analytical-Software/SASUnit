/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _delFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _delFile.sas)

%let infile=&g_refdata./class.xlsx;
%let outfile=%sysfunc(pathname(work))/class.xlsx;
%_copyFile (&infile.
           ,&outfile.
           );

%initTestcase(i_object=_delFile.sas, i_desc=Test with correct call)
%let rc=%_delFile(&outfile.);
%endTestcall;

%assertEquals(i_expected=0,  i_actual=%sysfunc(fileexist(&outfile.)),  i_desc=check on file abscence)
%assertEquals(i_expected=0,  i_actual=&rc.,  i_desc=check on return code)
%endTestcase;

/** \endcond */

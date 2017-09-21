/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _copyDir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _copyDir.sas)

%let indir=%sysfunc(pathname(work))/in;
%let outdir=%sysfunc(pathname(work))/out;
%_mkdir(&indir.);
%_mkdir(&outdir.);
%_copyFile(&g_refdata./class.xlsx,&outdir./class.xlsx);
%_copyFile(&g_refdata./class.png,&outdir./class.png);

%initTestcase(i_object=_copyDir.sas, i_desc=Test with correct call)
%_copyDir (&indir.
           ,&outdir.
           );
%endTestcall;

%assertEquals(i_expected=1,  i_actual=%sysfunc(fileexist(&outdir./class.xlsx)),  i_desc=check on file existance)
%assertEquals(i_expected=1,  i_actual=%sysfunc(fileexist(&outdir./class.png)),  i_desc=check on file existance)
%endTestcase;

/** \endcond */

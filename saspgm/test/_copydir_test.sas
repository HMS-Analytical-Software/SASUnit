/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _copyDir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

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

%endScenario();
/** \endcond */
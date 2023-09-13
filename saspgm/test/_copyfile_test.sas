/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _copyFile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _copyFile.sas);

%initTestcase(i_object=_copyFile.sas, i_desc=Test with correct call)
%let infile=&g_refdata./class.xlsx;
%let outfile=%sysfunc(pathname(work))/class.xlsx;
%_copyFile (&infile.
           ,&outfile.
           );
%endTestcall;

%assertEquals(i_expected=1,  i_actual=%sysfunc(fileexist(&outfile.)),  i_desc=check on file existance)
%endTestcase;

%endScenario();
/** \endcond */
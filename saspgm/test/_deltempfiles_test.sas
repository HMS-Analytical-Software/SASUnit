/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _delTempFiles.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _delTempFiles.sas);

data;
set sashelp.class;
run;

%initTestcase(i_object=_delTempFiles.sas, i_desc=Test with correct call)
%_delTempFiles;
%endTestcall;

%assertTableExists(i_libref=work, i_memname=data1, i_desc=check on table abscence, i_not=1)
%endTestcase;

%endScenario();
/** \endcond */
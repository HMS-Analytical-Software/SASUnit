/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _getPgmDesc.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _getPgmDesc.sas);

%LET g_desc = NIX; 
%initTestcase(i_object=_getPgmDesc.sas, i_desc=Test with brief tag)
%_getPgmDesc(i_pgmfile=&g_testdata./macro_with_brief_tag.sas
            ,r_desc=g_desc
            );
%endTestcall;

%assertEquals(i_expected=Program for tests of _getpgmdesc with brief tag,  i_actual=&g_desc.,  i_desc=check on equality)
%endTestcase;

%LET g_desc = NIX; 
%initTestcase(i_object=_getPgmDesc.sas, i_desc=Test without brief tag)
%_getPgmDesc(i_pgmfile=&g_testdata./macro_without_brief_tag.sas
            ,r_desc=g_desc
            );
%endTestcall;

%assertEquals(i_expected=&g_testdata./macro_without_brief_tag.sas,  i_actual=&g_desc.,  i_desc=check on equality)
%endTestcase;

%endScenario();
/** \endcond */
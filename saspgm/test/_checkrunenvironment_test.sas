/**
   \file
   \ingroup    SASUNIT_TEST

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.

   \brief      Test of _checkRunEnvironment.sas

*/ /** \cond */ 

%initScenario(i_desc=Test of _checkRunEnvironment.sas);

%global g_cre_result;
%let g_cre_result=-1;

/*-- Case 1: Successful Call --*/
%initTestcase(i_object = _checkRunEnvironment.sas, i_desc = Successful call)

%let l_mprint = %sysfunc(getoption(MPRINT));
%let l_mlogic = %sysfunc(getoption(MLOGIC));

options mprint mlogic;

%let g_cre_result=%_checkRunEnvironment;

options &l_mprint. &l_mlogic.;

%endTestcall();

%assertEquals(i_actual   =&g_cre_result.
              ,i_expected =0
              ,i_desc     =OS and SAS Version are valid
              );
%assertLogMsg (i_logmsg=NE WIN);
%assertLogMsg (i_logmsg=NE LINUX);
%assertLogMsg (i_logmsg=NE 9.4);

%endTestcase();

%endScenario();
/** \endcond */

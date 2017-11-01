/**
   \file
   \ingroup    SASUNIT_TEST

   \version    \$Revision: 418 $
   \author     \$Author: klandwich $
   \date       \$Date: 2015-06-03 15:46:51 +0200 (Mi, 03 Jun 2015) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_checkszenario_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \brief      Test of _checkRunEnvironment.sas

*/ /** \cond */ 

%initScenario(i_desc=Test of _checkRunEnvironment.sas);

%global g_cre_result;
%let g_cre_result=-1;

/*-- Case 1: Successful Call --*/
%initTestcase(i_object = _checkRunEnvironment.sas, i_desc = Successful call)

%let g_cre_result=%_checkRunEnvironment(1);

%endTestcall();

%assertEquals(i_actual   =&g_cre_result.
              ,i_expected =0
              ,i_desc     =OS and SAS Version are valid
              );
%assertLogMsg (i_logmsg=NE WIN);
%assertLogMsg (i_logmsg=NE 9.2);

%endTestcase();

%endScenario();
/** \endcond */

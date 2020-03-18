/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of endScenario.sas

   \version    \$Revision: 314 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-02-15 10:57:09 +0100 (Sa, 15 Feb 2014) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/_copyfile_test.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
%initScenario(i_desc=Test of endScenario.sas);

%_nls(i_language=de);

%let g_scnid = 017;

%endScenario();

%initScenario(i_desc=Test of endScenario.sas);

%_nls(i_language=en);

%let g_scnid = 017;

%endScenario();
/** \endcond **/
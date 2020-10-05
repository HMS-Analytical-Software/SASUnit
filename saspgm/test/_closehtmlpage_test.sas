/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _closeHTMLPage.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _closeHTMLPage.sas)

ods html file="%sysfunc(pathname(WORK))\TEST.HMTL";

%initTestcase(i_object=_closeHTMLPage.sas, i_desc=Test with correct call);

%let l_mprint     = %sysfunc(getoption(MPRINT));
%let l_mprintnest = %sysfunc(getoption(MPRINTNEST));

options mprint mprintnest;

%_closeHTMLPage(Default);

options &l_mprint. &l_mprintnest.;

%endTestcall;

%assertLogMsg(i_logMsg=MPRINT._CLOSEHTMLPAGE._OPENDUMMYHTMLPAGE.:);

%endTestcase;

%endScenario();
/** \endcond */

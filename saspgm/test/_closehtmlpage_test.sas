/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _closehtmlpage.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
%initScenario (i_desc=Test of _closehtmlpage.sas)

ods html file="%sysfunc(pathname(WORK))\TEST.HMTL";

%initTestcase(i_object=_closehtmlpage.sas, i_desc=Test with correct call);

%_closehtmlpage(HTMLBlue);

%endTestcall;

%assertLogMsg(i_logMsg=MPRINT._CLOSEHTMLPAGE._OPENDUMMYHTMLPAGE.:);

%endTestcase;

%endScenario();
/** \endcond */

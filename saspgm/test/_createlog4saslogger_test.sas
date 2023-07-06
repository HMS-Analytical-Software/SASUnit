/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createlog4saslogger.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \test Create test cases to check error messages

*/ /** \cond */ 
%initScenario (i_desc=Test of _createlog4saslogger.sas)

%initTestcase(i_object=_createlog4saslogger.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */

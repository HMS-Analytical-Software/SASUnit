/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of initScenario.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \test New test case with scenario id zero and i_object ne _AUTOMATIC_
*/ /** \cond */ 
%initScenario (i_desc=Test of initScenario.sas)

%initTestcase(i_object=initScenario.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */

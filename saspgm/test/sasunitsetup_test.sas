/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of sasunitsetup.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \remark Only used outside scenarios so no test cases needed
*/ /** \cond */ 
%initScenario (i_desc=Test of sasunitsetup.sas)

%initTestcase(i_object=sasunitsetup.sas, i_desc=Test with correct call);
   *** Empty scenario *;
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */

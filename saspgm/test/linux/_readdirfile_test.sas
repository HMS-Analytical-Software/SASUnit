/** \file
   \ingroup    SASUNIT_TEST_OS_LINUX

   \brief      Test of _readdirfile.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initScenario (i_desc=Test of _readdirfile.sas)

%initTestcase(i_object=_readdirfile.sas
             ,i_desc=dummy test case because program is only needed under windows
             )
%endTestcall;

%endTestcase;

%endScenario();
/** \endcond */

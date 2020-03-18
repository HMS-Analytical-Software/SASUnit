/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _mkDir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \test New test calls that catch all messages
*/ /** \cond */ 
%initScenario (i_desc=Test of _mkDir.sas);

%initTestcase(i_object=_mkDir.sas, i_desc=Test with correct call)
%let newdir=%sysfunc(pathname(work))/in;
%_mkdir(&newdir.);
%endTestcall;

%assertEquals(i_expected=1,  i_actual=%_existDir(&newdir.),  i_desc=check on file existence)
%endTestcase;

%endScenario();
/** \endcond */
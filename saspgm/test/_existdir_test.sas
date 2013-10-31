/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _existDir.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%let existing = %sysfunc(pathname(work));
%let existing2 = %sysfunc(pathname(work))/;
%let not_existing = y:\ljfdsö\jdsaö\jdsaöl\urewqio;

%initTestcase(i_object=_existDir.sas, i_desc=existing folder)
%LET exists = %_existdir(&existing);
%endTestcall;
%assertEquals(i_expected=1, i_actual=&exists, i_desc=folder exists)
%endTestcase;

%initTestcase(i_object=_existDir.sas, i_desc=existing folder with terminating /)
%LET exists = %_existdir(&existing2);
%endTestcall;
%assertEquals(i_expected=1, i_actual=&exists, i_desc=folder exists)
%endTestcase;

%initTestcase(i_object=_existDir.sas, i_desc=not existing folder)
%LET exists = %_existdir(&not_existing);
%endTestcall;
%assertEquals(i_expected=0, i_actual=&exists, i_desc=folder does not exists)
%endTestcase;

/** \endcond */

/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _getAutocallNumber.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initTestcase(i_object=_getAutocallNumber.sas, i_desc=Macro resides in SASUnit folder)
%let old_g_sasautos0 = &g_sasautos0.;
%let g_sasautos0     = C:\TEMP;

%LET rc=%_getAutocallNumber(_asserts.sas);

%endTestcall;
%let g_sasautos0     = &old_g_sasautos0.;

%assertEquals(i_expected=0,  i_actual=&rc.,  i_desc=SASUnit folder returns 0)
%endTestcase;

%initTestcase(i_object=_getAutocallNumber.sas, i_desc=Macro resides in SASUnit os-specific folder)

%LET rc=%_getAutocallNumber(_dir.sas);

%endTestcall;

%assertEquals(i_expected=1,  i_actual=&rc.,  i_desc=SASUnit folder returns 1)
%endTestcase;


%initTestcase(i_object=_getAutocallNumber.sas, i_desc=Macro resides in sasautos folder 9)
%let old_g_sasautos9 = &g_sasautos9.;
%let g_sasautos9     = &g_sasunit_os;

%LET rc=%_getAutocallNumber(_dir.sas);

%endTestcall;
%let g_sasautos9     = &old_g_sasautos9.;

%assertEquals(i_expected=11,  i_actual=&rc.,  i_desc=SASUnit folder returns 11)
%endTestcase;

%initTestcase(i_object=_getAutocallNumber.sas, i_desc=Macro not found)

%LET rc=%_getAutocallNumber(_dir2.sas);

%endTestcall;

%assertEquals(i_expected=.,  i_actual=&rc.,  i_desc=SASUnit folder returns missing)
%endTestcase;

/** \endcond */

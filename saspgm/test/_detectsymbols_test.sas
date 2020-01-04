/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of _detectSymbols.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */

%initScenario (i_desc=Test of _detectSymbols.sas)

%global
   g_my_error
   g_my_warning
   g_my_note
;

%let g_my_error   = _NONE_;
%let g_my_warning = _NONE_;
%let g_my_note    = _NONE_;

%initTestcase(i_object=_detectSymbols.sas, i_desc=Test with correct call);
   %_detectSymbols(r_error_symbol=g_my_error, r_warning_symbol=g_my_warning, r_note_symbol=g_my_note);
%endTestcall;

%assertEquals (i_actual    = &g_my_error.
              ,i_expected  = ERROR
              ,i_desc      = ERROR-Symbol is set properly
              );
              
%assertEquals (i_actual    = &g_my_warning.
              ,i_expected  = WARNING
              ,i_desc      = WARNING-Symbol is set properly
              );
%assertEquals (i_actual    = &g_my_note.
              ,i_expected  = NOTE
              ,i_desc      = NOTE-Symbol is set properly
              );
%endTestcase;

%endScenario();
/** endcond **/
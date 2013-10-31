/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _oscmds.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 

%initTestcase(i_object=_oscmds.sas, i_desc=check for correct values)
/* Get current values */
%let _removedir  = &g_removedir.;
%let _makedir    = &g_makedir.;
%let _copydir    = &g_copydir.;
%let _endcommand = &g_endcommand.;
%let _sasstart   = &g_sasstart.;
%let _splash     = &g_splash.;

/* delete current values*/
%let g_removedir  = ;
%let g_makedir    = ;
%let g_copydir    = ;
%let g_endcommand = ;
%let g_sasstart   = ;
%let g_splash     = ;

%_oscmds
%endTestcall;

%assertEquals(i_expected=&_removedir.,  i_actual=&g_removedir.,  i_desc=check g_removedir for identical value)
%assertEquals(i_expected=&_makedir.,    i_actual=&g_makedir.,    i_desc=check g_makedir for identical value)
%assertEquals(i_expected=&_copydir.,    i_actual=&g_copydir.,    i_desc=check g_copydir for identical value)
%assertEquals(i_expected=&_endcommand., i_actual=&g_endcommand., i_desc=check g_endcommand for identical value)
%assertEquals(i_expected=%quote(&_sasstart.),   i_actual=%quote(&g_sasstart.), i_desc=check g_sasstart for identical value)
%assertEquals(i_expected=&_splash.,     i_actual=&g_splash.,     i_desc=check g_splash for identical value)
%endTestcase;

/** \endcond */

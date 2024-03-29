/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _osCmds.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
               
   \test What about functionality besides assigning mac vars? Even os dependent functionality?
         That should be tested too.   

*/ /** \cond */ 
%initScenario (i_desc=Test of _osCmds.sas);

%initTestcase(i_object=_osCmds.sas, i_desc=check for correct values)

/* Get current values */
%let _copydir           = &g_copydir.;
%let _endcommand        = &g_endcommand.;
%let _makedir           = &g_makedir.;
%let _removedir         = &g_removedir.;
%let _sasstart          = &g_sasstart.;
%let _splash            = &g_splash.;
%let _infile_options    = &g_infile_options.;
%let _osCmdFileSuffix   = &g_osCmdFileSuffix.;

/* delete current values*/
%let g_copydir          =;
%let g_endcommand       =;
%let g_makedir          =;
%let g_removedir        =;
%let g_sasstart         =;
%let g_splash           =;
%let g_infile_options   =;
%let g_osCmdFileSuffix  =;

%_osCmds
%endTestcall;

%assertEquals(i_expected=&_copydir.,            i_actual=&g_copydir.,            i_desc=check g_copydir for identical value)
%assertEquals(i_expected=&_endcommand.,         i_actual=&g_endcommand.,         i_desc=check g_endcommand for identical value)
%assertEquals(i_expected=&_makedir.,            i_actual=&g_makedir.,            i_desc=check g_removedir for identical value)
%assertEquals(i_expected=&_removedir.,          i_actual=&g_removedir.,          i_desc=check g_removedir for identical value)
%assertEquals(i_expected=%quote(&_sasstart.),   i_actual=%quote(&g_sasstart.),   i_desc=check g_sasstart for identical value)
%assertEquals(i_expected=&_splash.,             i_actual=&g_splash.,             i_desc=check g_splash for identical value)
%assertEquals(i_expected=&_infile_options.,     i_actual=&g_infile_options.,     i_desc=check g_infile_options for identical value)
%assertEquals(i_expected=&_osCmdFileSuffix.,    i_actual=&g_osCmdFileSuffix.,    i_desc=check g_osCmdFileSuffix for identical value)
%endTestcase;

%endScenario();
/** \endcond */
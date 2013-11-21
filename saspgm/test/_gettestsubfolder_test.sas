/** \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _getTestSubfolder.sas

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */ 
      
*** Testcase 1 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with missing parameters);

%_getTestSubfolder();

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a value for i_assertType.);

%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with missing parameter i_root);

%_getTestSubfolder(i_assertType=assertLibrary, i_root=);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a value for i_root.);

%endTestcase();

*** Testcase 3 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with invalid parameter i_root);

%_getTestSubfolder(i_assertType=assertLibrary, i_root=hugo);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a valid directory for i_root.);

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with missing parameter i_scnid);

%_getTestSubfolder(i_assertType=assertLibrary);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a value for i_scnid.);

%endTestcase();

*** Testcase 5 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with missing parameter i_casid);

%_getTestSubfolder(i_assertType=assertLibrary, i_scnid=003);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a value for i_casid.);

%endTestcase();

*** Testcase 6 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with missing parameter i_tstid);

%_getTestSubfolder(i_assertType=assertLibrary, i_scnid=003, i_casid=8);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a value for i_tstid.);

%endTestcase();

*** Testcase 7 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with missing parameter r_path);

%_getTestSubfolder(i_assertType=assertLibrary, i_scnid=003, i_casid=8, i_tstid=4);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Please specify a value for r_path.);

%endTestcase();

*** Testcase 8 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with invalid parameter r_path);

%_getTestSubfolder(i_assertType=assertLibrary, i_scnid=003, i_casid=8, i_tstid=4, r_path=_path);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR.SASUNIT.: Macrovariable for return of subfolder path was not declared by a .local-statement.);

%endTestcase();

%global _path;
*** Testcase 9 ***; 
%initTestcase(i_object=_getTestSubfolder.sas, i_desc=call with path folder in testout);

%_getTestSubfolder(i_assertType=assertLibrary, i_scnid=003, i_casid=8, i_tstid=4, r_path=_path);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals(i_expected=_003_008_004_assertlibrary
             ,i_actual  =%_stdpath(i_root=%sysfunc(pathname(testout)),i_path=&_path.)
             ,i_desc    =Values must be equal
             );

%endTestcase();

/** \endcond */

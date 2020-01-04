/**
   \file
   \ingroup    SASUNIT_TEST

   \brief      Test of _createTestSubfolder.sas

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
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with missing parameters);

%_createTestSubfolder();

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: _createTestSubfolder: Please specify a value for r_path.);
 
%endTestcase();

*** Testcase 2 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with invalid parameter r_path);

%_createTestSubfolder(r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg (i_logmsg=ERROR: _createTestSubfolder: Macrovariable for return of subfolder path was not declared by a .local-statement.);

%endTestcase();

%global _path;
*** Testcase 3 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with missing parameter i_assertType);

%_createTestSubfolder(r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg(i_logmsg=ERROR: _getTestSubfolder: Please specify a value for i_assertType.);
%assertEquals(i_expected=_ERROR_
             ,i_actual  =&_path.
             ,i_desc    =Values must be equal
             );

%endTestcase();

*** Testcase 4 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with missing parameter i_root);

%_createTestSubfolder(i_assertType=assertEquals, i_root=, r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg(i_logmsg=ERROR: _getTestSubfolder: Please specify a value for i_root.);
%assertEquals(i_expected=_ERROR_
             ,i_actual  =&_path.
             ,i_desc    =Values must be equal
             );

%endTestcase();

*** Testcase 5 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with invalid parameter i_root);

%_createTestSubfolder(i_assertType=assertEquals, i_root=hugo, r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg(i_logmsg=ERROR: _getTestSubfolder: Please specify a valid directory for i_root.);
%assertEquals(i_expected=_ERROR_
             ,i_actual  =&_path.
             ,i_desc    =Values must be equal
             );

%endTestcase();

*** Testcase 6 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with missing parameter i_scnid);

%_createTestSubfolder(i_assertType=assertLibrary, r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg(i_logmsg=ERROR: _getTestSubfolder: Please specify a value for i_scnid.);
%assertEquals(i_expected=_ERROR_
             ,i_actual  =&_path.
             ,i_desc    =Values must be equal
             );

%endTestcase();

*** Testcase 7 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with missing parameter i_casid);

%_createTestSubfolder(i_assertType=assertLibrary, i_scnid=003, r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg(i_logmsg=ERROR: _getTestSubfolder: Please specify a value for i_casid.);
%assertEquals(i_expected=_ERROR_
             ,i_actual  =&_path.
             ,i_desc    =Values must be equal
             );

%endTestcase();

*** Testcase 8 ***; 
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with missing parameter i_tstid);

%_createTestSubfolder(i_assertType=assertLibrary, i_scnid=003, i_casid=8, r_path=_path);

%endTestcall;

%assertLog(i_errors=1,i_warnings=0);
%assertLogmsg(i_logmsg=ERROR: _getTestSubfolder: Please specify a value for i_tstid.);
%assertEquals(i_expected=_ERROR_
             ,i_actual  =&_path.
             ,i_desc    =Values must be equal
             );

%endTestcase();

*** Testcase 9 ***; 
%let work_path = %sysfunc(pathname(work));
%initTestcase(i_object=_createTestSubfolder.sas, i_desc=call with subfolder in work);

%_createTestSubfolder(i_assertType=assertEquals, i_root=&work_path., i_scnid=003, i_casid=7, i_tstid=2, r_path=_path);

%endTestcall;

%assertLog(i_errors=0,i_warnings=0);
%assertEquals(i_expected=_003_007_002_assertequals
             ,i_actual  =%_stdpath(i_root=&work_path.,i_path=&_path.)
             ,i_desc    =Values must be equal
             );
%assertEquals(i_expected=1
             ,i_actual  =%_existdir(&_path.)
             ,i_desc    =Values must be equal
             );

%endTestcase();

/** \endcond */
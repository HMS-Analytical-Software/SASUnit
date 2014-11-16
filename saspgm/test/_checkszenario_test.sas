/** \file
   \ingroup    SASUNIT_TEST

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \brief      Test of _checkScenario.sas

               check for many combinations where scenario and / or programs under test have been 
               changed or programs under test are missing, take into account programs 
               which can be found in autocall paths. 

*/ /** \cond */ 

/*-- change time for scenarios -----------------------------------------------*/
%LET scn_changed=%sysfunc(datetime());
%MACRO _createTestFiles;
/* Create test DB */
DATA scn;
   length scn_path $255;
   format scn_end datetime20.;
   scn_id = 1; scn_path = "test/Scenario1.sas"; scn_end = &scn_changed; output;
   scn_id = 2; scn_path = "test/Scenario2.sas"; scn_end = &scn_changed; output;
   scn_id = 3; scn_path = "test/Scenario3.sas"; scn_end = &scn_changed; output;
   scn_id = 4; scn_path = "test/Scenario4.sas"; scn_end = &scn_changed; output;
RUN;

/* Create data set i_examinee */
DATA scn_dir;
   length membername $80 filename $255;
   format changed datetime20.;
   membername = "Scenario1.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario1.sas"; output;
   membername = "Scenario2.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario2.sas"; output;
   membername = "Scenario3.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario3.sas"; output;
   membername = "Scenario4.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario4.sas"; output;
RUN;

DATA dependency;
   length caller calledByCaller $30;
   caller = "Scenario1.sas"; calledByCaller = "dummy1.sas"; output;
   caller = "Scenario1.sas"; calledByCaller = "dummy2.sas"; output;
   caller = "Scenario1.sas"; calledByCaller = "dummy3.sas"; output;
   caller = "Scenario1.sas"; calledByCaller = "dummy4.sas"; output;

   caller = "Scenario2.sas"; calledByCaller = "dummy2.sas"; output;
   caller = "Scenario2.sas"; calledByCaller = "dummy3.sas"; output;
   caller = "Scenario2.sas"; calledByCaller = "dummy4.sas"; output;
   caller = "Scenario2.sas"; calledByCaller = "dummy5.sas"; output;
   caller = "Scenario2.sas"; calledByCaller = "dummy6.sas"; output;

   caller = "Scenario3.sas"; calledByCaller = "dummy1.sas"; output;
   caller = "Scenario3.sas"; calledByCaller = "dummy5.sas"; output;
   caller = "Scenario3.sas"; calledByCaller = "dummy6.sas"; output;
   caller = "Scenario3.sas"; calledByCaller = "dummy7.sas"; output;
   caller = "Scenario3.sas"; calledByCaller = "dummy8.sas"; output;
   
   caller = "Scenario4.sas"; calledByCaller = "dummy5.sas"; output;
   caller = "Scenario4.sas"; calledByCaller = "dummy6.sas"; output;

   caller = "dummy2.sas"; calledByCaller = "dummy3.sas"; output;
   caller = "dummy2.sas"; calledByCaller = "dummy4.sas"; output;
   caller = "dummy5.sas"; calledByCaller = "dummy6.sas"; output;
   caller = "dummy7.sas"; calledByCaller = "dummy8.sas"; output;
RUN;

DATA examinee_dir;
   length membername $80 filename $255;
   format changed datetime20.;
   membername = "Scenario1.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario1.sas"; output;
   membername = "Scenario2.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario2.sas"; output;
   membername = "Scenario3.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario3.sas"; output;
   membername = "Scenario4.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario4.sas"; output;
   
   membername = "dummy1.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario1.sas"; output;
   membername = "dummy2.sas"; changed = &scn_changed-60; filename = "dummypath/test/Scenario2.sas"; output;
   membername = "dummy3.sas"; changed = &scn_changed-60; filename = "dummypath/pgms/Scenario3.sas"; output;
   membername = "dummy4.sas"; changed = &scn_changed-60; filename = "dummypath/pgms/Scenario1.sas"; output;
   membername = "dummy5.sas"; changed = &scn_changed-60; filename = "dummypath/libs/Scenario2.sas"; output;
   membername = "dummy6.sas"; changed = &scn_changed-60; filename = "dummypath/libs/Scenario3.sas"; output;
   membername = "dummy7.sas"; changed = &scn_changed-60; filename = "dummypath/libs/Scenario1.sas"; output;
   membername = "dummy8.sas"; changed = &scn_changed-60; filename = "dummypath/libs/Scenario2.sas"; output;
RUN;

DATA cas;
   format cas_scnid z3.;
   cas_scnid = 1; cas_auton = 2; output;
   cas_scnid = 2; cas_auton = 2; output;
   cas_scnid = 3; cas_auton = 2; output;
   cas_scnid = 4; cas_auton = 2; output;
RUN;

%MEND _createTestFiles;

/*-- Case 1: Neither scenario nor dependend macros changed --*/
%initTestcase(i_object = _checkScenario.sas, i_desc = Neither scenario nor dependend macros changed)
%_createTestFiles;
%_switch();
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = examinee_dir
               ,i_scn_pre        = scn_dir
               ,i_dependency     = dependency
               ,i_scenariosToRun = scenariosToRun
               );
%_switch();
%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=16, i_where=               , i_desc=14 dependencies expected for scenario 1-3 in data set dependenciesByScenario);
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=4 , i_where=               , i_desc=3 scenarios expected in data set scenariosToRun need to be run);
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=0 , i_where=%str(dorun = 1), i_desc=Of which none needs to be run);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);


/* test case 2 ------------------------------------ */
%initTestcase(i_object = _checkScenario.sas, i_desc = 2 scenarios and 1 dependend macro changed since last run);
/* Modifiy results of _dir macro */
PROC SQL;
   update scn_dir
      set changed = &scn_changed+60
      where membername = "Scenario1.sas" or membername = "Scenario4.sas"
   ;
   update examinee_dir
      set changed = &scn_changed+60
      where membername = "Scenario1.sas" or membername = "Scenario4.sas" or membername = "dummy4.sas"
   ;
QUIT;

%_switch();
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = examinee_dir
               ,i_scn_pre        = scn_dir
               ,i_dependency     = dependency
               ,i_scenariosToRun = scenariosToRun
               );
%_switch();

%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=7, i_where=%str(dorun = 1),                                                              i_desc=7 observations with %str(dorun=1) expected);
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=2, i_where=%str(calledByCaller = "dummy4.sas" and dorun = 1),                            i_desc=5 observations with %str(dorun=1) expected);
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=4, i_where=%str(name = "Scenario1.sas" and dorun = 1),                                   i_desc=All entries for scenario 1 with %str(dorun=1));
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario2.sas" and dorun = 1 and calledByCaller = "dummy4.sas"), i_desc=Only one entry for scenario 2 with %str(dorun=1));
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=2, i_where=%str(name = "Scenario4.sas" and dorun = 1),                                   i_desc=All Entries for scenario 4 with %str(dorun=1));
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=3, i_where=%str(dorun = 1),                                                              i_desc=3 scenarios expected with %str(dorun=1));
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario3.sas" and dorun = 0),                                   i_desc=Scenario 3 will not be run);
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario4.sas" and dorun = 1),                                   i_desc=Scenario 4 will be run);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 3 ------------------------------------ */
%initTestcase(i_object = _checkScenario.sas, i_desc = New scenario found%str(,) that has not been run before);
/* Test files without scenario4 in test db */
%_createTestFiles;
PROC SQL;
   delete from scn
      where scn_id = 4
   ;
QUIT;

%_switch();
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = examinee_dir
               ,i_scn_pre        = scn_dir
               ,i_dependency     = dependency
               ,i_scenariosToRun = scenariosToRun
               );
%_switch();

%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=scn,                    i_operator=EQ, i_recordsExp=3, i_where=,                                            i_desc=3 observations in test db expected);
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=2, i_where=%str(name = "Scenario4.sas" and dorun = 1),  i_desc=2 observations with %str(dorun=1) expected);
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario4.sas" and dorun = 1),  i_desc=Scenario 4 expected with %str(dorun=1));
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=3, i_where=%str(name ne "Scenario4.sas" and dorun = 0), i_desc=Scenario 1%str(,) 2 and 3 will not be run);
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 4 ------------------------------------ */
%initTestcase(i_object = _checkScenario.sas, i_desc = Test DB empty: all scenarios have to be run);
/* Test files without scenario3 in test db */
%_createTestFiles;
PROC SQL;
   delete from scn
      where scn_path = "test/Scenario3.sas"
   ;
QUIT;

%_switch();
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = examinee_dir
               ,i_scn_pre        = scn_dir
               ,i_dependency     = dependency
               ,i_scenariosToRun = scenariosToRun
               );
%_switch();

%endTestcall();
   %markTest();
      %assertRecordCount(i_libref=work, i_memname=scn                   , i_operator=EQ, i_recordsExp=2, i_where=%str(scn_id = 1 or scn_id = 2),             i_desc=2 observations in test db expected);
      %assertRecordCount(i_libref=work, i_memname=Dependenciesbyscenario, i_operator=EQ, i_recordsExp=5, i_where=%str(name = "Scenario3.sas" and dorun = 1), i_desc=5 observations with %str(dorun=1) expected);
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario3.sas" and dorun = 1), i_desc=Scenario 3 expected with %str(dorun=1));
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario1.sas" and dorun = 0), i_desc=Scenario 1 will not be run);
      %assertRecordCount(i_libref=work, i_memname=ScenariosToRun,         i_operator=EQ, i_recordsExp=1, i_where=%str(name = "Scenario2.sas" and dorun = 0), i_desc=Scenario 2 will not be run);
      
      %assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);
/** \endcond */ 

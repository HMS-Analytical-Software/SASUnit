/**
   \file
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

%initScenario(i_desc=Test of _checkScenario.sas);
/*-- change time for scenarios -----------------------------------------------*/
%LET scn_changed=%sysfunc(datetime());
%MACRO _createTestFiles;
   %local l_root;
   %let l_root = %sysfunc (translate (&g_root., /, \));

   /* Create test DB */
   DATA scn_single;
      length scn_path $255;
      format scn_end datetime20.;
      scn_id = 1; scn_path = "saspgm/test/pgmlib1/scenario1.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 2; scn_path = "saspgm/test/pgmlib1/scenario2.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 3; scn_path = "saspgm/test/pgmlib1/scenario3.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 4; scn_path = "saspgm/test/pgmlib1/scenario4.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
   RUN;

   DATA scn_multi;
      length scn_path $255;
      format scn_end datetime20.;
      scn_id = 1; scn_path = "saspgm/test/pgmlib1/scenario1.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 2; scn_path = "saspgm/test/pgmlib1/scenario2.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 3; scn_path = "saspgm/test/pgmlib1/scenario3.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 4; scn_path = "saspgm/test/pgmlib1/scenario4.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 5; scn_path = "saspgm/test/pgmlib2/scenario5.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
      scn_id = 6; scn_path = "saspgm/test/pgmlib2/scenario6.sas"; scn_end = &scn_changed.; scn_changed=&scn_changed.;output;
   RUN;

   /* Create data set i_examinee */
   DATA scn_dir_1;
      length membername $80 filename $255;
      format changed datetime20.;
      membername = "scenario1.sas"; changed = &scn_changed.-60; filename = "&l_root./saspgm/test/pgmlib1/scenario1.sas"; output;
      membername = "scenario2.sas"; changed = &scn_changed.-60; filename = "&l_root./saspgm/test/pgmlib1/scenario2.sas"; output;
      membername = "scenario3.sas"; changed = &scn_changed.-60; filename = "&l_root./saspgm/test/pgmlib1/scenario3.sas"; output;
      membername = "scenario4.sas"; changed = &scn_changed.-60; filename = "&l_root./saspgm/test/pgmlib1/scenario4.sas"; output;
   RUN;

   DATA scn_dir_2;
      length membername $80 filename $255;
      format changed datetime20.;
      membername = "scenario5.sas"; changed = &scn_changed.-60; filename = "&l_root./saspgm/test/pgmlib2/scenario5.sas"; output;
      membername = "scenario6.sas"; changed = &scn_changed.-60; filename = "&l_root./saspgm/test/pgmlib2/scenario6.sas"; output;
   RUN;

   DATA exa;
      length exa_pgm $80 exa_filename $255;
      format exa_changed datetime20.;
      format exa_id z3.;
      exa_id=5; exa_auton=3; exa_pgm = "scenario1.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/scenario1.sas"; output;
      exa_id=6; exa_auton=3; exa_pgm = "scenario2.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/scenario2.sas"; output;
      exa_id=7; exa_auton=3; exa_pgm = "scenario3.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/scenario3.sas"; output;
      exa_id=8; exa_auton=3; exa_pgm = "scenario4.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/scenario4.sas"; output;
      
      exa_id=1; exa_auton=2; exa_pgm = "testmakro1.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/testmakro1.sas"; output;
      exa_id=2; exa_auton=2; exa_pgm = "testmakro2.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/testmakro2.sas"; output;
      exa_id=3; exa_auton=2; exa_pgm = "testmakro3.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/testmakro3.sas"; output;
      exa_id=4; exa_auton=2; exa_pgm = "testmakro4.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib1/testmakro4.sas"; output;

      exa_id=11; exa_auton=4; exa_pgm = "scenario5.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib2/scenario5.sas"; output;
      exa_id=12; exa_auton=4; exa_pgm = "scenario6.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib2/scenario6.sas"; output;

      exa_id=9;  exa_auton=4; exa_pgm = "testmakro5.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib2/testmakro5.sas"; output;
      exa_id=10; exa_auton=4; exa_pgm = "testmakro6.sas"; exa_changed = &scn_changed.-60; exa_filename = "&l_root./saspgm/test/pgmlib2/testmakro6.sas"; output;
   RUN;

   DATA cas;
      format cas_scnid z3.;
      cas_scnid = 1; cas_exaid=1; cas_obj="TestMakro1"; output;
      cas_scnid = 2; cas_exaid=2; cas_obj="TestMakro2"; output;
      cas_scnid = 3; cas_exaid=3; cas_obj="TestMakro3"; output;
      cas_scnid = 4; cas_exaid=4; cas_obj="TestMakro4"; output;
      cas_scnid = 5; cas_exaid=9; cas_obj="TestMakro5"; output;
      cas_scnid = 6; cas_exaid=10; cas_obj="TestMakro6"; output;
   RUN;

   data tsu;
      format tsu_lastinit datetime20.;
      tsu_lastinit=&scn_changed.; output;
   run;
%MEND _createTestFiles;

/*-- Case 1: Neither scenario nor dependend macros changed --*/
%_createTestFiles;
data work.scn;
   set work.scn_single;
run;
%initTestcase(i_object = _checkScenario.sas, i_desc = Neither scenario nor dependend macros changed)
libname target (work);

/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ 
                  ,i_recordsExp=4 
                  ,i_where=               
                  ,i_desc=4 scenarios expected in data set scenariosToRun
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=0 
                  ,i_where=%str(dorun = 1)
                  ,i_desc=Of which none needs to be run);
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);


/* test case 2 ------------------------------------ */
%_createTestFiles;
data work.scn;
   set work.scn_single;
run;
/* Modifiy results of _dir macro */
PROC SQL;
   update exa
      set exa_changed = &scn_changed.+60
      where exa_pgm = "testmakro4.sas"
   ;
QUIT;
%LET _G_CROSSREF=&G_CROSSREF.;
%LET _G_CROSSREFSASUNIT=&G_CROSSREFSASUNIT.;
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;

%initTestcase(i_object = _checkScenario.sas, i_desc = 1 macro changed since last run - no dependency check);
libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(dorun = 1)
                  ,i_desc=1 scenarios expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario3.sas" and dorun = 0)
                  ,i_desc=Scenario 3 will not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario4.sas" and dorun = 1)
                  ,i_desc=Scenario 4 will be run
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 3 ------------------------------------ */
%LET G_CROSSREF=1;
%LET G_CROSSREFSASUNIT=1;
%initTestcase(i_object = _checkScenario.sas, i_desc = 1 macro changed since last run - dependency check);
libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=4
                  ,i_where=%str(dorun = 1)
                  ,i_desc=all scenarios expected with %str(dorun=1)
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 4 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
/* Test files without scenario4 in test db */
%_createTestFiles;
PROC SQL;
   delete from scn
      where scn_path = "saspgm/test/pgmlib1/scenario4.sas"
   ;
QUIT;

%initTestcase(i_object = _checkScenario.sas, i_desc = New scenario found%str(,) that has not been run before);
libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=3
                  ,i_where=
                  ,i_desc=3 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path =  "saspgm/test/pgmlib1/scenario4.sas" and dorun = 1)
                  ,i_desc=Scenario 4 expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=3
                  ,i_where=%str(scn_path ne "saspgm/test/pgmlib1/scenario4.sas" and dorun = 0)
                  ,i_desc=Scenario 1%str(,) 2 and 3 will not be run
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 5 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
/* Test files without scenario3 in test db */
%_createTestFiles;
data work.scn;
   set work.scn_single;
run;
PROC SQL;
   delete from scn
      where scn_path = "saspgm/test/pgmlib1/scenario3.sas"
   ;
QUIT;
%initTestcase(i_object = _checkScenario.sas, i_desc = New scenario found%str(,) that has not been run before);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=3
                  ,i_where=
                  ,i_desc=3 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=dorun ne 0
                  ,i_desc=1 scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario3.sas" and dorun = 1)
                  ,i_desc=Scenario 3 expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario4.sas" and dorun = 0)
                  ,i_desc=Scenario 4 will not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario1.sas" and dorun = 0)
                  ,i_desc=Scenario 1 will not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario2.sas" and dorun = 0)
                  ,i_desc=Scenario 2 will not be run
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 6 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
/* Test files with empty test db */
%_createTestFiles;
data work.scn;
   set work.scn_single;
   stop;
run;
%initTestcase(i_object = _checkScenario.sas, i_desc = Test DB empty: all scenarios have to be run);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=0
                  ,i_where=
                  ,i_desc=no observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=4
                  ,i_where=dorun ne 0
                  ,i_desc=4 scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario1.sas" and dorun = 1)
                  ,i_desc=Scenario 1 expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario2.sas" and dorun = 1)
                  ,i_desc=Scenario 2 expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario3.sas" and dorun = 1)
                  ,i_desc=Scenario 3 expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario4.sas" and dorun = 1)
                  ,i_desc=Scenario 4 expected with %str(dorun=1)
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 7 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
%_createTestFiles;
data work.scn;
   set work.scn_multi;
run;
/* Modifiy results of _dir macro */
PROC SQL;
   update exa
      set exa_changed = &scn_changed.+60
      where exa_pgm = "testmakro1.sas"
   ;
QUIT;
%initTestcase(i_object = _checkScenario.sas, i_desc = First call to runsasunit - testmakro 3 changed);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=
                  ,i_desc=6 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=dorun ne 0
                  ,i_desc=1 scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=5
                  ,i_where=dorun = 0
                  ,i_desc=Five Scenario should not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario1.sas" and dorun = 1)
                  ,i_desc=Scenario 1 expected with %str(dorun=1)
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 8 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
%_createTestFiles;
data work.scn;
   set work.scn_multi;
run;
%initTestcase(i_object = _checkScenario.sas, i_desc = Second call to runsasunit - testmakro 3 changed);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_2
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=
                  ,i_desc=6 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=0
                  ,i_where=dorun ne 0
                  ,i_desc=no scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=dorun = 0
                  ,i_desc=All Scenario should not be run
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 9 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
%_createTestFiles;
data work.scn;
   set work.scn_multi;
run;
/* Modifiy results of _dir macro */
PROC SQL;
   update exa
      set exa_changed = &scn_changed.+60
      where exa_pgm = "testmakro5.sas"
   ;
QUIT;
%initTestcase(i_object = _checkScenario.sas, i_desc = First call to runsasunit - testmakro 5 changed);
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=
                  ,i_desc=6 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=0
                  ,i_where=dorun ne 0
                  ,i_desc=no scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=dorun = 0
                  ,i_desc=All Scenario should not be run
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 10 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
%_createTestFiles;
data work.scn;
   set work.scn_multi;
run;
/* Modifiy results of _dir macro */
PROC SQL;
   update exa
      set exa_changed = &scn_changed.+60
      where exa_pgm = "testmakro5.sas"
   ;
QUIT;
%initTestcase(i_object = _checkScenario.sas, i_desc = Second call to runsasunit - testmakro 5 changed);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_2
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=
                  ,i_desc=6 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=dorun ne 0
                  ,i_desc=1 scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=5
                  ,i_where=dorun = 0
                  ,i_desc=Five Scenario should not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib2/scenario5.sas" and dorun = 1)
                  ,i_desc=Scenario 5 expected with %str(dorun=1)
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase(i_assertLog=0);

/* test case 11 ------------------------------------ */
%LET G_CROSSREF=0;
%LET G_CROSSREFSASUNIT=1;
%_createTestFiles;
data work.scn;
   set work.scn_multi;
run;
/* Modifiy results of _dir macro */
PROC SQL;
   update exa
      set exa_changed = &scn_changed.+60
      where exa_pgm = "testmakro2.sas"
   ;
QUIT;
%initTestcase(i_object = _checkScenario.sas
             ,i_desc   = First call to runsasunit - testmakro 2 changed);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=
                  ,i_desc=6 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=dorun ne 0
                  ,i_desc=1 scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=5
                  ,i_where=dorun = 0
                  ,i_desc=5 Scenario should not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario2.sas" and dorun = 1)
                  ,i_desc=Scenario 2 expected with %str(dorun=1)
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase;

/* test case 12 ------------------------------------ */
%LET G_CROSSREF=1;
%LET G_CROSSREFSASUNIT=1;
%_createTestFiles;
data work.scn;
   set work.scn_multi;
run;
/* Modifiy results of _dir macro */
PROC SQL;
   update exa
      set exa_changed = &scn_changed.+60
      where exa_pgm = "testmakro2.sas"
   ;
QUIT;
%initTestcase(i_object = _checkScenario.sas
             ,i_desc   = Second call to runsasunit - testmakro 2 changed - dependency overwrites);

libname target (work);
/* check which test scenarios must be run */
%_checkScenario(i_examinee       = exa
               ,i_scn_pre        = scn_dir_1
               ,o_scenariosToRun = scenariosToRun
               );
libname target "&g_target.";
%endTestcall();
%assertRecordCount(i_libref=work, i_memname=scn, i_operator=EQ
                  ,i_recordsExp=6
                  ,i_where=
                  ,i_desc=6 observations in test db expected
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=2
                  ,i_where=dorun ne 0
                  ,i_desc=2 scenarios should be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=4
                  ,i_where=dorun = 0
                  ,i_desc=4 Scenario should not be run
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario1.sas" and dorun = 1)
                  ,i_desc=Scenario 1 expected with %str(dorun=1)
                  );
%assertRecordCount(i_libref=work, i_memname=ScenariosToRun, i_operator=EQ
                  ,i_recordsExp=1
                  ,i_where=%str(scn_path = "saspgm/test/pgmlib1/scenario2.sas" and dorun = 1)
                  ,i_desc=Scenario 2 expected with %str(dorun=1)
                  );
%assertLog (i_errors=0, i_warnings=0);
%endTestcase;
%LET G_CROSSREF=&_G_CROSSREF.;
%LET G_CROSSREFSASUNIT=&_G_CROSSREFSASUNIT.;

proc datasets lib=work kill memtype=(data) nolist;
run;
quit;

%endScenario();
/** \endcond */

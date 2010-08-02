/** \file
   \ingroup    SASUNIT_TEST 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \brief      tests for _sasunit_checkScenario.sas

               check for many combinations where scenario and / or programs under test have been 
               changed or programs under test are missing, take into account programs 
               which can be found in autocall paths or have relative or absolute paths. 

*/ /** \cond */ 

/* change log 
   15.12.2007 AM  Neuerstellung 
*/ 

/*-- create folders for example programs -------------------------------------*/
%_sasunit_mkdir(&g_work\auto)
%_sasunit_mkdir(&g_work\auto1)

/*-- change time for scenarios -----------------------------------------------*/
%let schanged=%sysfunc(datetime());

/*-- create programs, wait one minute for program pgm2, because of time precision of dir --*/
data _null_;
   file "&g_work/auto/pgm1.sas";
   put;
run;
%let p1changed=%sysfunc(datetime());
data _null_;
   call sleep(60,1);
   file "&g_work/auto1/pgm2.sas";
   put;
run;
%let p2changed=%sysfunc(datetime());

/*-- create example database -------------------------------------------------*/
%let delta=1;
data scn(keep=scn_id scn_path scn_start) cas (keep=cas_scnid cas_id cas_pgm cas_auton);
   length scn_path cas_pgm $255;
   format scn_start datetime20.;
/*-- Case 1: scenario changed after last run --*/
   scn_id = 1; scn_path="test/Scenario1.sas"; scn_start=&schanged-&delta; output scn;
      cas_scnid=1; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=1; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Case 2: scenario still unknown --*/
/*-- Case 3: scenario not changed, but one of two autocall programs --*/
   scn_id = 3; scn_path="test/Scenario3.sas"; scn_start=&p1changed+&delta; output;
      cas_scnid=3; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=3; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Case 4: scenario not changed, but one of two autocall programs is missing --*/
   scn_id = 4; scn_path="test/Scenario4.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=4; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=4; cas_id=2; cas_pgm='pgmxxx.sas'; cas_auton=1; output cas;
/*-- Case 5: scenario not changed, but the only autocall program is missing --*/
   scn_id = 5; scn_path="test/Scenario5.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=5; cas_id=1; cas_pgm='pgmxxx.sas'; cas_auton=1; output cas;
/*-- Case 6: scenario not changed, but one program without autocall --*/
   scn_id = 6; scn_path="test/Scenario6.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=6; cas_id=1; cas_pgm='auto1/pgm2.sas'; cas_auton=.; output cas;
/*-- Fall 7: scenario not changed, but one program without autocall (abs. path) --*/
   scn_id = 7; scn_path="test/Scenario7.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=7; cas_id=1; cas_pgm="&g_work/auto1/pgm2.sas"; cas_auton=.; output cas;
/*-- Case 8: scenario not changed, but the only program without autocall is missing --*/
   scn_id = 8; scn_path="test/Scenario8.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=8; cas_id=1; cas_pgm="auto/pgmxxx.sas"; cas_auton=.; output cas;
/*-- Case 9: scenario not changed, none of two autocall programs changed --*/
   scn_id = 9; scn_path="test/Scenario9.sas"; scn_start=&p2changed+&delta; output;
      cas_scnid=9; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=9; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Case 10: scenario not changed,  none of the two programs changed, one with, one without autocall --*/
   scn_id = 10; scn_path="test/Scenario10.sas"; scn_start=&p2changed+&delta; output scn;
      cas_scnid=10; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=10; cas_id=2; cas_pgm='auto1/pgm2.sas'; cas_auton=.; output cas;
/*-- Case 11: scenario not changed, one program without autocall not changed --*/
   scn_id = 11; scn_path="test/Scenario11.sas"; scn_start=&p1changed+&delta; output scn;
      cas_scnid=11; cas_id=1; cas_pgm='auto/pgm1.sas'; cas_auton=.; output cas;
/*-- Case 12: scenario not changed, one program without autocall not changed (abs. path) --*/
   scn_id = 12; scn_path="test/Scenario12.sas"; scn_start=&p1changed+&delta; output scn;
      cas_scnid=12; cas_id=1; cas_pgm="&g_work/auto/pgm1.sas"; cas_auton=.; output cas;
/*-- Case 13: scenario changed (abs. path) --*/
   scn_id = 13; scn_path="x:/xghkdsf/Scenario13.sas"; scn_start=&schanged-&delta; output scn;
      cas_scnid=13; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=13; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Case 14: scenario (abs path) not changed, but one of two autocall programs --*/
   scn_id = 14; scn_path="x:/xghkdsf/Scenario14.sas"; scn_start=&p1changed+&delta; output;
      cas_scnid=14; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=14; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
run;
ods listing; 
proc print data=scn; run; 
proc print data=cas; run; 
ods listing close;

/*-- create program folders --------------------------------------------------*/
%_sasunit_dir(i_path=&g_work/auto ,o_out=dir)
%_sasunit_dir(i_path=&g_work/auto1,o_out=dir1)
data dir;
   set dir (in=in1) dir1;
   if in1 then auton=0;
   else auton=1;
run; 
ods listing; 
proc print; run; 
ods listing close;

/*-- switch between example database and real database -----------------------*/
%macro switch();
%global state save_root save_target;
%if &state= or &state=0 %then %do;
   %let state=1;
   %let save_root=&g_root;
   %let save_target=&g_target;
   %let g_root=&g_work;
   %let g_target=&g_work;
%end;
%else %do;
   %let state=0;
   %let g_root=&save_root;
   %let g_target=&save_target;
%end;
libname target "&g_target";
%mend switch;

/*-- Case 1: scenario changed after last run --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = scenario changed after last run 
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario1.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=1, i_actual=&scnid, i_desc=szenario id must be 1)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <1>), i_desc=choose exit 1)
%assertLog()

/*-- Case 2: scenario still unknown --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = scenario still unknown
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario2.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=0,  i_actual=&scnid, i_desc=scenario id must be 0 - not found)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <1>), i_desc=choose exit 1)
%assertLog()

/*-- Case 3: scenario not changed, but one of two autocall programs --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, but one of two autocall programs)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario3.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=3, i_actual=&scnid, i_desc=scenario id must be 3)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=choose exit 2)
%assertLog()

/*-- Case 4: scenario not changed, but one of two autocall programs is missing --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, but one of two autocall programs is missing)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario4.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=4, i_actual=&scnid, i_desc=scenario id must be 4)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=choose exit 2)
%assertLog()

/*-- Case 5: scenario not changed, but the only autocall program is missing --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, but the only autocall program is missing)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario5.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=5, i_actual=&scnid, i_desc=scenario id must be 5)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=choose exit 2)
%assertLog()

/*-- Case 6: scenario not changed, but one program without autocall --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, but one program without autocall)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario6.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=6, i_actual=&scnid, i_desc=scenario id must be 6)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <4>), i_desc=choose exit 4)
%assertLog()

/*-- Fall 7: scenario not changed, but one program without autocall (abs. path) --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, but one program without autocall (abs. path))
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario7.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=7, i_actual=&scnid, i_desc=scenario id must be 7)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <4>), i_desc=Choose exit 4)
%assertLog()

/*-- Case 8: scenario not changed, but the only program without autocall is missing --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, but the only program without autocall is missing)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario8.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=8, i_actual=&scnid, i_desc=scenario id must be 8)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <4>), i_desc=Choose exit 4)
%assertLog()

/*-- Case 9: scenario not changed, none of two autocall programs changed --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, none of two autocall programs changed)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario9.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=9, i_actual=&scnid, i_desc=scenario id must be 9)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=scenario does not have to be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <3>), i_desc=Choose exit 3)
%assertLog()

/*-- Case 10: scenario not changed,  none of the two programs changed, one with, one without autocall --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed,  none of the two programs changed, one with, one without autocall)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario10.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=10, i_actual=&scnid, i_desc=scenario id must be 10)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=scenario does not have to be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <5>), i_desc=Choose exit 5)
%assertLog()

/*-- Case 11: scenario not changed, one program without autocall not changed --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, one program without autocall not changed)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario11.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=11, i_actual=&scnid, i_desc=scenario id must be 11)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=scenario does not have to be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <5>), i_desc=Choose exit 5)
%assertLog()

/*-- Case 12: scenario not changed, one program without autocall not changed (abs. path) --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario not changed, one program without autocall not changed (abs. path))
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = &g_work/test/Scenario12.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=12, i_actual=&scnid, i_desc=scenario id must be 12)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=scenario does not have to be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <5>), i_desc=Choose exit 5)
%assertLog()

/*-- Case 13: scenario changed (abs. path) --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario changed (abs. path))
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = x:/xghkdsf/Scenario13.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=13, i_actual=&scnid, i_desc=scenario id must be 13)
%assertEquals(i_expected=1, i_actual=&run, i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <1>), i_desc=Choose exit 1)
%assertLog()

/*-- Case 14: scenario (abs path) not changed, but one of two autocall programs --*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(scenario (abs path) not changed, but one of two autocall programs)
)
%switch()
%let scnid=0;
%let run=;
%_sasunit_checkScenario(
   i_scnfile = x:/xghkdsf/Scenario14.sas
  ,i_changed = &schanged
  ,i_dir     = dir
  ,r_scnid   = scnid
  ,r_run     = run
)   
%switch()
%assertEquals(i_expected=14, i_actual=&scnid, i_desc=scenario id must be 14)
%assertEquals(i_expected=1, i_actual=&run, i_desc=scenario must be run)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=Choose exit 2)
%assertLog()

/** \endcond */ 

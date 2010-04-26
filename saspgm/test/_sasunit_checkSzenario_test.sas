/** \file
   \ingroup    SASUNIT_TEST 

   \brief      Tests für _sasunit_checkScenario.sas

*/ /** \cond */ 

/* Änderungshistorie
   15.12.2007 AM  Neuerstellung 
*/ 

/*-- Pfade anlegen für Beispielprogramme -------------------------------------*/
%_sasunit_mkdir(&g_work\auto)
%_sasunit_mkdir(&g_work\auto1)

/*-- Szenarien Änderungszeitpunkt --------------------------------------------*/
%let schanged=%sysfunc(datetime());

/*-- Programme anlegen, dabei 1 Minute warten für pgm2, wegen dir-precision --*/
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

/*-- Beispieldatenbank erstellen ---------------------------------------------*/
%let delta=1;
data scn(keep=scn_id scn_path scn_start) cas (keep=cas_scnid cas_id cas_pgm cas_auton);
   length scn_path cas_pgm $255;
   format scn_start datetime20.;
/*-- Fall 1: Szenario geändert nach letztem Lauf -----------------------------*/
   scn_id = 1; scn_path="test/Scenario1.sas"; scn_start=&schanged-&delta; output scn;
      cas_scnid=1; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=1; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Fall 2: Szenario noch nicht bekannt -------------------------------------*/
/*-- Fall 3: Szenario nicht geändert, aber eines von zwei Autocall-Pgms ------*/
   scn_id = 3; scn_path="test/Scenario3.sas"; scn_start=&p1changed+&delta; output;
      cas_scnid=3; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=3; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Fall 4: Szenario nicht geändert, aber eines von zwei Autocall-Pgms fehlt */
   scn_id = 4; scn_path="test/Scenario4.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=4; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=4; cas_id=2; cas_pgm='pgmxxx.sas'; cas_auton=1; output cas;
/*-- Fall 5: Szenario nicht geändert, aber eines von einem Autocall-Pgms fehlt*/
   scn_id = 5; scn_path="test/Scenario5.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=5; cas_id=1; cas_pgm='pgmxxx.sas'; cas_auton=1; output cas;
/*-- Fall 6: Szenario nicht geändert, aber eines ohne Autocall ---------------*/
   scn_id = 6; scn_path="test/Scenario6.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=6; cas_id=1; cas_pgm='auto1/pgm2.sas'; cas_auton=.; output cas;
/*-- Fall 7: Szenario nicht geändert, aber eines ohne Autocall (abs. Pfad) ---*/
   scn_id = 7; scn_path="test/Scenario7.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=7; cas_id=1; cas_pgm="&g_work/auto1/pgm2.sas"; cas_auton=.; output cas;
/*-- Fall 8: Szenario nicht geändert, eines ohne Autocall fehlt --------------*/
   scn_id = 8; scn_path="test/Scenario8.sas"; scn_start=&schanged+&delta; output;
      cas_scnid=8; cas_id=1; cas_pgm="auto/pgmxxx.sas"; cas_auton=.; output cas;
/*-- Fall 9: Szenario nicht geändert, keines von zwei Autocall-Pgms ----------*/
   scn_id = 9; scn_path="test/Scenario9.sas"; scn_start=&p2changed+&delta; output;
      cas_scnid=9; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=9; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Fall 10: Szenario nicht geändert, weder eins mit noch eins ohne Autocall-*/
   scn_id = 10; scn_path="test/Scenario10.sas"; scn_start=&p2changed+&delta; output scn;
      cas_scnid=10; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=10; cas_id=2; cas_pgm='auto1/pgm2.sas'; cas_auton=.; output cas;
/*-- Fall 11: Szenario nicht geändert und auch nicht ein Programm ohne Autoc.-*/
   scn_id = 11; scn_path="test/Scenario11.sas"; scn_start=&p1changed+&delta; output scn;
      cas_scnid=11; cas_id=1; cas_pgm='auto/pgm1.sas'; cas_auton=.; output cas;
/*-- Fall 12: Szenario nicht geändert und nicht ein Programm o. Autocall abs.-*/
   scn_id = 12; scn_path="test/Scenario12.sas"; scn_start=&p1changed+&delta; output scn;
      cas_scnid=12; cas_id=1; cas_pgm="&g_work/auto/pgm1.sas"; cas_auton=.; output cas;
/*-- Fall 13: Szenario (abs Pfad) geändert -----------------------------------*/
   scn_id = 13; scn_path="x:/xghkdsf/Scenario13.sas"; scn_start=&schanged-&delta; output scn;
      cas_scnid=13; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=13; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
/*-- Fall 14: Szenario (abs Pfad) nicht geändert, aber eines von zwei Autocall*/
   scn_id = 14; scn_path="x:/xghkdsf/Scenario14.sas"; scn_start=&p1changed+&delta; output;
      cas_scnid=14; cas_id=1; cas_pgm='pgm1.sas'; cas_auton=0; output cas;
      cas_scnid=14; cas_id=2; cas_pgm='pgm2.sas'; cas_auton=1; output cas;
run;
ods listing; 
proc print data=scn; run; 
proc print data=cas; run; 
ods listing close;

/*-- Programmdirectory erstellen ---------------------------------------------*/
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

/*-- umschalten zwischen Beispieldatenbank und richtiger Datenbank -----------*/
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

/*-- Fall 1: Szenario geändert nach letztem Lauf -----------------------------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = Szenario geändert nach letztem Lauf
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
%assertEquals(i_expected=1, i_actual=&scnid, i_desc=Testszenario-id muss 1 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <1>), i_desc=Ausgang 1 gewählt)
%assertLog()

/*-- Fall 2: Szenario noch nicht bekannt -------------------------------------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = Szenario noch nicht bekannt
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
%assertEquals(i_expected=0,  i_actual=&scnid, i_desc=Testszenario-id muss 0 sein - nicht gefunden)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <1>), i_desc=Ausgang 1 gewählt)
%assertLog()

/*-- Fall 3: Szenario nicht geändert, aber eines von zwei Autocall-Pgms ------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert, aber eines von zwei Autocall-Pgms)
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
%assertEquals(i_expected=3, i_actual=&scnid, i_desc=Testszenario-id muss 3 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=Ausgang 2 gewählt)
%assertLog()

/*-- Fall 4: Szenario nicht geändert, aber eines von zwei Autocall-Pgms fehlt */
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert, aber eines von zwei Autocall-Pgms fehlt)
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
%assertEquals(i_expected=4, i_actual=&scnid, i_desc=Testszenario-id muss 4 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=Ausgang 2 gewählt)
%assertLog()

/*-- Fall 5: Szenario nicht geändert, aber eines von einem Autocall-Pgms fehlt*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert, aber eines von einem Autocall-Pgms fehlt)
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
%assertEquals(i_expected=5, i_actual=&scnid, i_desc=Testszenario-id muss 5 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=Ausgang 2 gewählt)
%assertLog()

/*-- Fall 6: Szenario nicht geändert, aber eines ohne Autocall ---------------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert, aber ein Programm ohne Autocall )
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
%assertEquals(i_expected=6, i_actual=&scnid, i_desc=Testszenario-id muss 6 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <4>), i_desc=Ausgang 4 gewählt)
%assertLog()

/*-- Fall 7: Szenario nicht geändert, aber eines ohne Autocall (abs. Pfad) ---*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert, aber ein Programm ohne Autocall - abs. Pfad)
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
%assertEquals(i_expected=7, i_actual=&scnid, i_desc=Testszenario-id muss 7 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <4>), i_desc=Ausgang 4 gewählt)
%assertLog()

/*-- Fall 8: Szenario nicht geändert, eines ohne Autocall fehlt --------------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert, aber ein Programm ohne Autocall fehlt)
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
%assertEquals(i_expected=8, i_actual=&scnid, i_desc=Testszenario-id muss 8 sein)
%assertEquals(i_expected=1, i_actual=&run  , i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <4>), i_desc=Ausgang 4 gewählt)
%assertLog()

/*-- Fall 9: Szenario nicht geändert, keines von zwei Autocall-Pgms ----------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert und keines von zwei Autocall-Programmen)
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
%assertEquals(i_expected=9, i_actual=&scnid, i_desc=Testszenario-id muss 9 sein)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=Testszenario muss nicht ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <3>), i_desc=Ausgang 3 gewählt)
%assertLog()

/*-- Fall 10: Szenario nicht geändert, weder eins mit noch eins ohne Autocall-*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert und weder ein Programm mit noch eines ohne Autocall geändert)
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
%assertEquals(i_expected=10, i_actual=&scnid, i_desc=Testszenario-id muss 10 sein)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=Testszenario muss nicht ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <5>), i_desc=Ausgang 5 gewählt)
%assertLog()

/*-- Fall 11: Szenario nicht geändert und auch nicht ein Programm ohne Autoc.-*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert und auch nicht ein Programm ohne Autocall)
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
%assertEquals(i_expected=11, i_actual=&scnid, i_desc=Testszenario-id muss 11 sein)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=Testszenario muss nicht ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <5>), i_desc=Ausgang 5 gewählt)
%assertLog()

/*-- Fall 12: Szenario nicht geändert und nicht ein Programm o. Autocall abs.-*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario nicht geändert und auch nicht ein Programm ohne Autocall mit absolutem Pfad)
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
%assertEquals(i_expected=12, i_actual=&scnid, i_desc=Testszenario-id muss 12 sein)
%assertEquals(i_expected=0, i_actual=&run  , i_desc=Testszenario muss nicht ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <5>), i_desc=Ausgang 5 gewählt)
%assertLog()

/*-- Fall 13: Szenario (abs Pfad) geändert -----------------------------------*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario geändert - absoluter Pfad)
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
%assertEquals(i_expected=13, i_actual=&scnid, i_desc=Testszenario-id muss 13 sein)
%assertEquals(i_expected=1, i_actual=&run, i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <1>), i_desc=Ausgang 1 gewählt)
%assertLog()

/*-- Fall 14: Szenario (abs Pfad) nicht geändert, aber eines von zwei Autocall*/
%initTestcase(
   i_object = _sasunit_checkScenario.sas
  ,i_desc   = %str(Szenario - absoluter Pfad - nicht geändert, aber eines von zwei Autocall-Pgms)
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
%assertEquals(i_expected=14, i_actual=&scnid, i_desc=Testszenario-id muss 14 sein)
%assertEquals(i_expected=1, i_actual=&run, i_desc=Testszenario muss ausgeführt werden)
%assertLogMsg(i_logMsg=%str(_sasunit_checkScenario <2>), i_desc=Ausgang 2 gewählt)
%assertLog()

/** \endcond */ 

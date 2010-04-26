/**
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      Initialization of a test suite that comprises several test scenarios. 

               Please refer to the description of the test tools in _sasunit_doc.sas. 

               An existing test repository is opened or a new test repository is created..


   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/sasunit/initSASUnit.sas $

   \param   i_root         optional: root path for all other paths, is used for paths that do not begin 
                           with a drive letter or a slash/backslash
   \param   io_target      Path for the test repository and the generated documentation, has to exist
   \param   i_overwrite    0 (default) .. create test repository only in case it does not already exist
                           1 .. test repository is always created newly 
   \param   i_project      optional (in case test repository already exists): name of project
   \param   i_sasunit      optional (in case test repository already exists): path of SAS programs from SASUnit
   \param   i_sasautos     optional: i_sasautos, i_sasautos1 .. i_sasautos9: search paths for the programs 
                           under test and other sas macros invoked in test scenarios or programs under test
                           (the filename SASAUTOS predefined by SAS is always included at the beginning of
                           the search path)
   \param   i_autoexec     optional: a SAS program that is always invoked before a start of a test scenario
   \param   i_sascfg       optional: a SAS configuration file that is used for every invocation of a
                           test scenario
   \param   i_sasuser      optional: Template for a SASUSER directory including configuration catalogs.
                           A temporary SASUSER directory is created, existing only for the duration of a 
                           test scenario, in which all files are copied out of the specified directory.
   \param   i_testdata     optional: directory containing test data, has to exist in case parameter is set
                           (is accessed readonly)
   \param   i_refdata      optional: directory containing reference data, has to exist in case parameter is set
                           (is accessed readonly)
   \param   i_doc          optional: directory containing specification documents, etc., has to exist
                           in case parameter is set (is accessed readonly)
*/

/*DE
   \file
   \ingroup    SASUNIT_CNTL 

   \brief      Initialisieren einer Testsuite, die aus mehreren Testszenarien 
               besteht. 

               Siehe Beschreibung der Testtools in _sasunit_doc.sas. 

               Es wird eine vorhandene Testdatenbank geöffnet oder eine neue Testdatenbank erstellt.


   \version    \$Revision: 40 $
   \author     \$Author: warnat $
   \date       \$Date: 2008-08-20 16:04:44 +0200 (Mi, 20 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/sasunit/initSASUnit.sas $

   \param   i_root         optional: Rootpfad für alle weiterne Pfade, wird verwendet bei Pfaden, die nicht 
                           mit einem Laufwerksbuchstaben oder Slash bzw. Backslash beginnen
   \param   io_target      Pfad für Testdatenbank und generierte Dokumentation, muss existieren
   \param   i_overwrite    0 (default) .. Datenbank nur anlegen, wenn sie noch nicht existiert
                           1 .. Datenbank immer neu anlegen
   \param   i_project      optional (nur bei vorhandener Testdatenbank): Name des Projekts
   \param   i_sasunit      optional (nur bei vorhandener Testdatenbank): Pfad der SAS-Programme von SASUnit
   \param   i_sasautos     optional: i_sasautos, i_sasautos1 .. i_sasautos9: Makrosuchpfade für die
                           Prüflinge und weitere in den Testszenarien und Prüflingen verwendete Makros
                           (der von SAS vordefinierte Filename SASAUTOS
                           wird immer ganz vorne im Suchpfad mit aufgenommen)
   \param   i_autoexec     optional: Angabe eines SAS-Programms, das vor jedem Aufruf
                           eines Testszenarios aufgerufen wird
   \param   i_sascfg       optional: Angabe einer SAS-Konfigurationsdatei, 
                           die beim Ausführen jedes Testszenarios verwendet werden soll
   \param   i_sasuser      optional: Vorlage für ein SASUSER-Verzeichnis mit den dort
                           befindlichen Konfigurationskatalogen. Es wird dann ein temporäres
                           SASUSER-Verzeichnis angelegt, in das alle Dateien aus dem 
                           angegebenen Verzeichnis kopiert werden und 
                           das nur für die Dauer eines
                           Aufrufs eines Testszenarios existiert
   \param   i_testdata     optional: Testdatenverzeichnis, muss ggfs. existieren
                           (wird readonly verwendet)
   \param   i_refdata      optional: Referenzdatenverzeichnis, muss ggfs. existieren
                           (wird readonly verwendet)
   \param   i_doc          optional: Verzeichnis mit Spezifikationsdokumenten etc., 
                           muss ggfs. existieren (wird readonly verwendet)
*/ /** \cond */ 

/* Änderungshistorie
   27.06.2008 AM  Minimale Änderungen in den Kommentartexten
   15.02.2008 AM  Dokumentation ausgelagert nach _sasunit_doc.sas
   05.02.2008 AM  Dokumentation der asserts aktualisiert
   29.12.2007 AM  Dokumentation der asserts aktualisiert
   15.12.2007 AM  Dokumentation der asserts überarbeitet.
*/ 

%MACRO initSASUnit(
   i_root       = 
  ,io_target    = 
  ,i_overwrite  = 0
  ,i_project    = 
  ,i_sasunit    =
  ,i_sasautos   =
  ,i_sasautos1  =
  ,i_sasautos2  =
  ,i_sasautos3  =
  ,i_sasautos4  =
  ,i_sasautos5  =
  ,i_sasautos6  =
  ,i_sasautos7  =
  ,i_sasautos8  =
  ,i_sasautos9  =
  ,i_autoexec   =
  ,i_sascfg     =
  ,i_sasuser    =
  ,i_testdata   = 
  ,i_refdata    = 
  ,i_doc        = 
);
%LOCAL l_macname; %LET l_macname=&sysmacroname;
%LOCAL l_first_temp;

/*-- Fehlerbehandlung initialisieren -----------------------------------------*/
%_sasunit_initErrorHandler;

/*-- Zielverzeichnis prüfen --------------------------------------------------*/
%LOCAL l_target_abs;
%LET l_target_abs=%_sasunit_abspath(&i_root,&io_target);
%IF %_sasunit_handleError(&l_macname, InvalidTargetDir, 
   "&l_target_abs" EQ "" OR NOT %_sasunit_existDir(&l_target_abs), 
   Fehler in Parameter io_target: Zielverzeichnis existiert nicht) 
   %THEN %GOTO errexit;

LIBNAME target "&l_target_abs";
%IF %_sasunit_handleError(&l_macname, ErrorTargetLib, 
   %quote(&syslibrc) NE 0, 
   Fehler in Parameter io_target: Zielverzeichnis kann nicht als SAS-Library geöffnet werden) 
   %THEN %GOTO errexit;
data target._test;
run;
%IF %_sasunit_handleError(&l_macname, ErrorTargetLibNotWritable, 
   %quote(&syserr) NE 0, 
   Fehler in Parameter io_target: Zielverzeichnis nicht beschreibbar) 
   %THEN %GOTO errexit;
PROC SQL;
   DROP TABLE target._test;
QUIT;

/*-- existiert die Testdatenbank schon? --------------------------------------*/
%LOCAL l_newdb;
%IF "&i_overwrite" NE "1" %then %LET i_overwrite=0;
%IF &i_overwrite %THEN %LET l_newdb=1;
%ELSE %LET l_newdb=%eval(NOT %sysfunc(exist(target.tsu)));

/*-- Testdatenbank ggfs. anlegen ---------------------------------------------*/
%IF &l_newdb %THEN %DO;
PROC SQL NOPRINT;
   CREATE TABLE target.tsu (        /* Testsuite */
       tsu_project    CHAR(255)        /* siehe i_project */
      ,tsu_root       CHAR(255)        /* siehe i_root */
      ,tsu_target     CHAR(255)        /* siehe io_target */
      ,tsu_sasunit    CHAR(255)        /* siehe i_sasunit */
      ,tsu_sasautos   CHAR(255)        /* siehe i_sasautos */
%DO i=1 %TO 9;
      ,tsu_sasautos&i CHAR(255)        /* siehe i_sasautos<n> */
%END;
      ,tsu_autoexec   CHAR(255)        /* siehe i_autoexec */
      ,tsu_sascfg     CHAR(255)        /* siehe i_sascfg */
      ,tsu_sasuser    CHAR(255)        /* siehe i_sasuser */
      ,tsu_testdata   CHAR(255)        /* siehe i_testdata */
      ,tsu_refdata    CHAR(255)        /* siehe i_refdata */
      ,tsu_doc        CHAR(255)        /* siehe i_doc */
      ,tsu_lastinit   INT FORMAT=datetime21.2 /* Zeit der letzten Initialisierung */
      ,tsu_lastrep    INT FORMAT=datetime21.2 /* Zeit der letzten Reportgenerierung */
   );
   INSERT INTO target.tsu VALUES (
   "","","","","","","","","","","","","","","","","","","","",0,0
   );

   CREATE TABLE target.scn (        /* Szenariolauf */
       scn_id     INT FORMAT=z3.       /* Laufende Nummer des Testszenariolaufs */
      ,scn_path   CHAR(255)            /* Pfad zur Programmdatei */ 
      ,scn_desc   CHAR(255)            /* Beschreibung der Datei (Brief-Tag Doxygen) */
      ,scn_start  INT FORMAT=datetime21.2 /* Startzeit des Laufs */
      ,scn_end    INT FORMAT=datetime21.2 /* Endzeit der Tests */
      ,scn_rc     INT                  /* Returncode der SAS-Sitzung */
      ,scn_res    INT                  /* Testergebnis 0 .. OK, 1 .. nicht OK, 2 .. manuell */
   );
   CREATE TABLE target.cas (        /* Testfall */
       cas_scnid INT FORMAT=z3.        /* Verweis auf Szenariolauf */
      ,cas_id    INT FORMAT=z3.        /* laufende Nummer des Testfalls innerhalb des Szenariolaufs */
      ,cas_auton INT                   /* Nummer des Autocall-Pfads, in dem das Programm gefunden wurde, oder ., wenn nicht gefunden */
      ,cas_pgm   CHAR(255)             /* Programmdatei des Prüflings, wenn über Autocall gefunden, oder vorangestellter Pfad */ 
      ,cas_desc  CHAR(255)             /* Beschreibung des Testfalls */
      ,cas_spec  CHAR(255)             /* optional: Spezifikationsdokument, wenn nicht absoluter Pfad: in Verzeichnis g_doc */
      ,cas_start INT FORMAT=datetime21.2  /* Startzeit des Testfalls */
      ,cas_end   INT FORMAT=datetime21.2  /* Endzeit des Testfalls */
      ,cas_res   INT                   /* Testergebnis 0 .. OK, 1 .. nicht OK, 2 .. manuell */
   );
   CREATE TABLE target.tst (        /* Test */
       tst_scnid INT FORMAT=z3.        /* Verweis auf Szenariolauf */
      ,tst_casid INT FORMAT=z3.        /* Verweis auf Testfall */
      ,tst_id    INT FORMAT=z3.        /* eindeutige Nummer des Tests innerhalb des Testfalls */
      ,tst_type  CHAR(32)              /* Typ des Tests (Name des verwendeten assert-Makros) */
      ,tst_desc  CHAR(255)             /* Beschreibung des Tests */
      ,tst_exp   CHAR(255)             /* erwartetes Ergebnis */
      ,tst_act   CHAR(255)             /* tatsächliches Ergebnis */
      ,tst_res   INT                   /* Testergebnis 0 .. OK, 1 .. nicht OK, 2 .. manuell */
   );
QUIT;
%IF %_sasunit_handleError(&l_macname, ErrorCreateDB, 
   &syserr NE 0, 
   Fehler beim Anlegen der Testdatenbank) 
   %THEN %GOTO errexit;

/*-- Verzeichnisse anlegen, vorher leeren ------------------------------------*/
DATA _null_;
   FILE "%sysfunc(pathname(work))/x.cmd" encoding=pcoem850;/* wg. Umlauten in Pfaden */
   PUT "rd /S /Q ""&l_target_abs/log""";
   PUT "rd /S /Q ""&l_target_abs/tst""";
   PUT "rd /S /Q ""&l_target_abs/rep""";
   PUT "md ""&l_target_abs/log""";
   PUT "md ""&l_target_abs/tst""";
   PUT "md ""&l_target_abs/rep""";
RUN;
%_sasunit_xcmd("%sysfunc(pathname(work))/x.cmd")
%LOCAL l_rc;
%LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/x.cmd);

%END; /* %if &l_newdb */

/*-- Verzeichnisse prüfen ----------------------------------------------------*/
%IF %_sasunit_handleError(&l_macname, NoLogDir, 
   NOT %_sasunit_existdir(&l_target_abs/log), 
   Log-Verzeichnis existiert nicht) 
   %THEN %GOTO errexit;
%IF %_sasunit_handleError(&l_macname, NoTstDir, 
   NOT %_sasunit_existdir(&l_target_abs/tst), 
   Tst-Verzeichnis existiert nicht) 
   %THEN %GOTO errexit;
%IF %_sasunit_handleError(&l_macname, NoRepDir, 
   NOT %_sasunit_existdir(&l_target_abs/rep), 
   Rep-Verzeichnis existiert nicht) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_target = "&io_target";
QUIT;

/*-- Projektname -------------------------------------------------------------*/
%LOCAL l_project;
PROC SQL NOPRINT;
   SELECT tsu_project INTO :l_project FROM target.tsu;
QUIT;
%LET l_project=&l_project;
%IF "&i_project" NE "" %THEN %LET l_project=&i_project;
%IF %_sasunit_handleError(&l_macname, MissingProjectName, 
   "&l_project" EQ "", 
   Parameter i_project muss angegeben werden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_project = "&l_project";
QUIT;

/*-- root-Verzeichnis --------------------------------------------------------*/
%LOCAL l_root;
PROC SQL NOPRINT;
   SELECT tsu_root INTO :l_root FROM target.tsu;
QUIT;
%LET l_root=&l_root;
%IF "&i_root" NE "" %THEN %LET l_root=&i_root;
%IF %_sasunit_handleError(&l_macname, InvalidRoot, 
   "&l_root" NE "" AND NOT %_sasunit_existdir(&l_root),
   %str(Fehler in Parameter i_root: Verzeichnis muss existieren, wenn angegeben)) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_root = "&l_root";
QUIT;

/*-- sasunit-Verzeichnis -----------------------------------------------------*/
%LOCAL l_sasunit l_sasunit_abs;
PROC SQL NOPRINT;
   SELECT tsu_sasunit INTO :l_sasunit FROM target.tsu;
QUIT;
%LET l_sasunit=&l_sasunit;
%IF "&i_sasunit" NE "" %THEN %LET l_sasunit=&i_sasunit;
%LET l_sasunit_abs=%_sasunit_abspath(&l_root,&l_sasunit);
%IF %_sasunit_handleError(&l_macname, InvalidSASUnitDir, 
   "&l_sasunit_abs" EQ "" OR NOT %sysfunc(fileexist(&l_sasunit_abs/_sasunit_scenario.sas)), 
   Fehler in Parameter i_sasunit: Programme von SASUnit nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_sasunit = "&l_sasunit";
QUIT;

/*-- ggfs. prüfen, ob autoexec vorhanden -------------------------------------*/
%LOCAL l_autoexec l_autoexec_abs;
PROC SQL NOPRINT;
   SELECT tsu_autoexec INTO :l_autoexec FROM target.tsu;
QUIT;
%LET l_autoexec=&l_autoexec;
%IF "&i_autoexec" NE "" %THEN %LET l_autoexec=&i_autoexec;
%LET l_autoexec_abs=%_sasunit_abspath(&l_root,&l_autoexec);
%IF %_sasunit_handleError(&l_macname, AutoexecNotFound, 
   "&l_autoexec" NE "" AND NOT %sysfunc(fileexist(&l_autoexec_abs%str( ))), 
   Fehler in Parameter i_autoexec: Datei nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_autoexec = "&l_autoexec";
QUIT;

/*-- ggfs. prüfen, ob sascfg vorhanden ---------------------------------------*/
%LOCAL l_sascfg l_sascfg_abs;
PROC SQL NOPRINT;
   SELECT tsu_sascfg INTO :l_sascfg FROM target.tsu;
QUIT;
%LET l_sascfg=&l_sascfg;
%IF "&i_sascfg" NE "" %THEN %LET l_sascfg=&i_sascfg;
%LET l_sascfg_abs=%_sasunit_abspath(&l_root,&l_sascfg);
%IF %_sasunit_handleError(&l_macname, SASCfgNotFound, 
   "&l_sascfg" NE "" AND NOT %sysfunc(fileexist(&l_sascfg_abs%str( ))), 
   Fehler in Parameter i_sascfg: Datei nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_sascfg = "&l_sascfg";
QUIT;

/*-- sasuser-Verzeichnis prüfen ----------------------------------------------*/
%LOCAL l_sasuser l_sasuser_abs;
PROC SQL NOPRINT;
   SELECT tsu_sasuser INTO :l_sasuser FROM target.tsu;
QUIT;
%LET l_sasuser=&l_sasuser;
%IF "&i_sasuser" NE "" %THEN %LET l_sasuser=&i_sasuser;
%LET l_sasuser_abs=%_sasunit_abspath(&l_root,&l_sasuser);
%IF %_sasunit_handleError(&l_macname, InvalidSasuser, 
   "&l_sasuser_abs" NE "" AND NOT %_sasunit_existdir(&l_sasuser_abs), 
   Fehler in Parameter i_sasuser: Verzeichnis nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_sasuser = "&l_sasuser";
QUIT;

/*-- Testdatenverzeichnis prüfen ---------------------------------------------*/
%LOCAL l_testdata l_testdata_abs;
PROC SQL NOPRINT;
   SELECT tsu_testdata INTO :l_testdata FROM target.tsu;
QUIT;
%LET l_testdata=&l_testdata;
%IF "&i_testdata" NE "" %THEN %LET l_testdata=&i_testdata;
%LET l_testdata_abs=%_sasunit_abspath(&l_root,&l_testdata);
%IF %_sasunit_handleError(&l_macname, InvalidTestdata, 
   "&l_testdata_abs" NE "" AND NOT %_sasunit_existdir(&l_testdata_abs), 
   Fehler in Parameter i_testdata: Verzeichnis nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_testdata = "&l_testdata";
QUIT;

/*-- Referenzdatenverzeichnis prüfen -----------------------------------------*/
%LOCAL l_refdata l_refdata_abs;
PROC SQL NOPRINT;
   SELECT tsu_refdata INTO :l_refdata FROM target.tsu;
QUIT;
%LET l_refdata=&l_refdata;
%IF "&i_refdata" NE "" %THEN %LET l_refdata=&i_refdata;
%LET l_refdata_abs=%_sasunit_abspath(&l_root,&l_refdata);
%IF %_sasunit_handleError(&l_macname, InvalidRefdata, 
   "&l_refdata_abs" NE "" AND NOT %_sasunit_existdir(&l_refdata_abs), 
   Fehler in Parameter i_refdata: Verzeichnis nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_refdata = "&l_refdata";
QUIT;

/*-- Verzeichnis für Spezifikationsdokumente prüfen --------------------------*/
%LOCAL l_doc l_doc_abs;
PROC SQL NOPRINT;
   SELECT tsu_doc INTO :l_doc FROM target.tsu;
QUIT;
%LET l_doc=&l_doc;
%IF "&i_doc" NE "" %THEN %LET l_doc=&i_doc;
%LET l_doc_abs=%_sasunit_abspath(&l_root,&l_doc);
%IF %_sasunit_handleError(&l_macname, InvalidDoc, 
   "&l_doc_abs" NE "" AND NOT %_sasunit_existdir(&l_doc_abs), 
   Fehler in Parameter i_doc: Verzeichnis nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_doc = "&l_doc";
QUIT;

/*-- Autocall-Pfade prüfen ---------------------------------------------------*/
%LOCAL restore_sasautos l_sasautos l_sasautos_abs i;
%LET restore_sasautos=%sysfunc(getoption(sasautos));

PROC SQL NOPRINT;
   SELECT tsu_sasautos INTO :l_sasautos FROM target.tsu;
QUIT;
%LET l_sasautos=&l_sasautos;
%IF "&i_sasautos" NE "" %THEN %LET l_sasautos=&i_sasautos;
%LET l_sasautos_abs=%_sasunit_abspath(&l_root,&l_sasautos);
%IF %_sasunit_handleError(&l_macname, InvalidSASAutos, 
   "&l_sasautos_abs" NE "" AND NOT %_sasunit_existdir(&l_sasautos_abs), 
   Fehler in Parameter i_sasautos: Verzeichnis nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_sasautos = "&l_sasautos";
QUIT;

%DO i=1 %TO 9;
PROC SQL NOPRINT;
   SELECT tsu_sasautos&i INTO :l_sasautos FROM target.tsu;
QUIT;
%LET l_sasautos=&l_sasautos;
%IF "&&i_sasautos&i" NE "" %THEN %LET l_sasautos=&&i_sasautos&i;
%LET l_sasautos_abs=%_sasunit_abspath(&l_root,&l_sasautos);
%IF %_sasunit_handleError(&l_macname, InvalidSASAutosN, 
   "&l_sasautos_abs" NE "" AND NOT %_sasunit_existdir(&l_sasautos_abs), 
   Fehler in Parameter i_sasautos&i: Verzeichnis nicht gefunden) 
   %THEN %GOTO errexit;
PROC SQL NOPRINT;
   UPDATE target.tsu SET tsu_sasautos&i = "&l_sasautos";
QUIT;
%END; /* i=1 %TO 9 */

/*-- relevante Informationen aus der Testdatenbank in globale Makrovariablen -*/
%_sasunit_loadEnvironment (
    i_withLibrefs = 0
)
%IF "&g_error_code" NE "" %THEN %GOTO errexit;

/*-- Optionen für OS-Kommandos setzen ----------------------------------------*/
options noxwait xsync xmin;

/*-- SAS-Aufruf prüfen -------------------------------------------------------*/
/* es wird hierfür von der aufgerufenen SAS-Sitzung in der Work-Library 
   der aufrufenden Sitzung eine Datei erstellt */
%LOCAL l_work;
%LET l_work = %sysfunc(pathname(work));
PROC DATASETS NOLIST NOWARN LIB=work;
   DELETE check;
QUIT;

DATA _null_;
   FILE "%sysfunc(pathname(work))/x.cmd";
   PUT "rd /S /Q ""%sysfunc(pathname(work))/sasuser""";
   PUT "md ""%sysfunc(pathname(work))/sasuser""";
%IF %length(&g_sasuser) %THEN %DO;
   PUT "xcopy ""&g_sasuser"" ""%sysfunc(pathname(work))/sasuser"" /E /I /Y";
%END;
RUN;
%_sasunit_xcmd("%sysfunc(pathname(work))/x.cmd")
%LOCAL l_rc;
%LET l_rc=_sasunit_delfile(%sysfunc(pathname(work))/x.cmd);
         
DATA _null_;
   FILE "&l_work/run.sas";
   PUT "LIBNAME awork ""&l_work"";";
   PUT "DATA awork.check; RUN;";
RUN;
%LOCAL l_parms;
%IF "&g_autoexec" NE "" %THEN %DO;
   %LET l_parms=&l_parms -autoexec "&g_autoexec";
%END;
%IF "&g_sascfg" NE "" %THEN %DO;
   %LET l_parms=&l_parms -config "&g_sascfg";
%END;
%sysexec 
   "%sysget(sasroot)/sas.exe"
      &l_parms
      -sysin "&l_work/run.sas"
      -initstmt "%nrstr(%_sasunit_scenario%(io_target=)&g_target%str(%))"
      -log   "&g_log/000.log"
      -print "&g_log/000.lst"
      -nosplash
      -noovp
      -nosyntaxcheck
      -mautosource
      -mcompilenote all
      -sasautos "&g_sasunit"
      -sasuser "%sysfunc(pathname(work))/sasuser"
   ;

%IF %_sasunit_handleError(&l_macname, ErrorSASCall2, 
   NOT %sysfunc(exist(work.check)), 
   Fehler beim Starten eines Testszenarios) 
   %THEN %GOTO errexit;

PROC DATASETS NOLIST NOWARN LIB=work;
   DELETE check;
QUIT;

%LET l_rc=%_sasunit_delFile(&l_work/run.sas);

/*-- Zeitpunkt der Initialisierung merken ------------------------------------*/
PROC SQL NOPRINT;
   UPDATE target.tsu 
      SET tsu_lastinit = %sysfunc(datetime())
   ;
QUIT;

%PUT;
%PUT ============================ SASUnit erfolgreich initialisiert ==================================;
%PUT;

%GOTO exit;
%errexit:
   %PUT;
   %PUT &g_error: ===================== Fehler! Testsuite wird abgebrochen! =================================;
   %PUT;
   LIBNAME target;
%exit:
%MEND initSASUnit;
/** \endcond */

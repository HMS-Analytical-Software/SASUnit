/** \file
   \ingroup    SASUNIT_UTIL 

   \brief      Ausführungsumgebung (Makrovariablen und Librefs / Filerefs) herstellen.

   \version 1.0
   \author  Andreas Mangold
   \date    10.08.2007
   \param   i_withlibrefs 1..es sollen auch die File- und Librefs hergestellt werden. 
                          0..nur Makrovariablen. 
*/ /** \cond */ 

/* Änderungshistorie
   19.08.2008 AM  neue Version 0.904
   11.08.2008 AM  neue Revision
   15.02.2008 AM  neue Revision
   10.02.2008 AM  neue Revision
*/

%MACRO _sasunit_loadEnvironment(
    i_withlibrefs = 1
); 
%LOCAL l_macname; %LET l_macname=&sysmacroname;

%GLOBAL g_target g_project g_root g_sasunit g_autoexec g_sascfg g_sasuser
        g_sasautos g_sasautos1 g_sasautos2 g_sasautos3 g_sasautos4 g_sasautos5
                   g_sasautos6 g_sasautos7 g_sasautos8 g_sasautos9 
        g_testdata g_refdata g_doc g_error g_warning
        g_work g_testout g_log
        g_version g_revision;
%LOCAL i;
        
%LET g_target = %sysfunc(pathname(target));
%LET g_version = 0.904;
%LET g_revision = $Revision: 56 $;
%LET g_revision = %scan(&g_revision,2,%str( $:));

%IF %_sasunit_handleError(&l_macname, InvalidTsu, 
   %_sasunit_nobs(target.tsu) NE 1, 
   ungültige Testdatenbank: target.tsu) 
   %THEN %GOTO errexit;

%IF %_sasunit_handleError(&l_macname, MissingCas, 
   NOT %sysfunc(exist(target.cas)), 
   ungültige Testdatenbank: target.cas) 
   %THEN %GOTO errexit;

%IF %_sasunit_handleError(&l_macname, MissingScn, 
   NOT %sysfunc(exist(target.scn)), 
   ungültige Testdatenbank: target.scn) 
   %THEN %GOTO errexit;

%IF %_sasunit_handleError(&l_macname, MissingTst, 
   NOT %sysfunc(exist(target.tst)), 
   ungültige Testdatenbank: target.tst) 
   %THEN %GOTO errexit;

DATA _null_;
   SET target.tsu;
   call symput ('g_project'   , tsu_project);
   call symput ('g_root'      , tsu_root);
   call symput ('g_sasunit'   , tsu_sasunit);
   call symput ('g_sasautos'  , tsu_sasautos);
%DO i=1 %TO 9;
   call symput ("g_sasautos&i", tsu_sasautos&i);
%END;
   call symput ('g_autoexec'  , tsu_autoexec);
   call symput ('g_sascfg'    , tsu_sascfg);
   call symput ('g_sasuser'   , tsu_sasuser);
   call symput ('g_testdata'  , tsu_testdata);
   call symput ('g_refdata'   , tsu_refdata);
   call symput ('g_doc'       , tsu_doc);
RUN;

%LET g_project  = &g_project;
%LET g_root     = &g_root;
%LET g_sasunit  = %_sasunit_abspath(&g_root,&g_sasunit);
%LET g_sasautos = %_sasunit_abspath(&g_root,&g_sasautos);
%DO i=1 %TO 9;
   %LET g_sasautos&i = %_sasunit_abspath(&g_root,&&g_sasautos&i);
%END;
%LET g_autoexec = %_sasunit_abspath(&g_root,&g_autoexec);
%LET g_sascfg   = %_sasunit_abspath(&g_root,&g_sascfg);
%LET g_sasuser  = %_sasunit_abspath(&g_root,&g_sasuser);
%LET g_testdata = %_sasunit_abspath(&g_root,&g_testdata);
%LET g_refdata  = %_sasunit_abspath(&g_root,&g_refdata);
%LET g_doc      = %_sasunit_abspath(&g_root,&g_doc);

%LET g_work     = %sysfunc(pathname(work));
%LET g_testout  = &g_target/tst;
%LET g_log      = &g_target/log;

%_sasunit_detectSymbols(r_error_symbol=g_error, r_warning_symbol=g_warning)

%IF &i_withlibrefs %THEN %DO;
      LIBNAME testout "&g_testout";
      FILENAME testout "&g_testout";
   %IF %length(&g_testdata) %THEN %DO;
      LIBNAME testdata "&g_testdata";
      FILENAME testdata "&g_testdata";
   %END;
   %IF %length(&g_refdata) %THEN %DO;
      LIBNAME refdata "&g_refdata";
      FILENAME refdata "&g_refdata";
   %END;
   %IF %length(&g_doc) %THEN %DO;
      FILENAME doc "&g_doc";
   %END;
%END;

%put _global_;

%GOTO exit;
%errexit:
LIBNAME target;
%exit:
%MEND _sasunit_loadEnvironment;
/** \endcond */

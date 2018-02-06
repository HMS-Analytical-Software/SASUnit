/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Initialize runtime environment (macro symbols and librefs / / filerefs)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_withlibrefs 1..initialize also filerefs and librefs 
                          0..initialize only macro symbols. 
*/ /** \cond */ 

%MACRO _loadEnvironment(i_withlibrefs = 1
                       );
 
   %LOCAL l_macname; %LET l_macname=&sysmacroname;

   %GLOBAL g_sasunitroot g_target g_project g_root g_sasunit g_sasunit_os g_autoexec g_sascfg g_sasuser
           g_sasautos   
           g_sasautos0  g_sasautos1  g_sasautos2  g_sasautos3  g_sasautos4  g_sasautos5  g_sasautos6  g_sasautos7  g_sasautos8  g_sasautos9 
           g_sasautos10 g_sasautos11 g_sasautos12 g_sasautos13 g_sasautos14 g_sasautos15 g_sasautos16 g_sasautos17 g_sasautos18 g_sasautos19 
           g_sasautos20 g_sasautos21 g_sasautos22 g_sasautos23 g_sasautos24 g_sasautos25 g_sasautos26 g_sasautos27 g_sasautos28 g_sasautos29 
           g_testdata g_refdata g_doc g_error g_warning g_note
           g_work g_testout g_log g_logfile g_printfile
           g_testcoverage g_verbose g_crossref g_crossrefsasunit g_rep_encoding
           g_language
           ;

   %LOCAL i;
           
   %LET g_target    = %sysfunc(pathname(target));

   %*** Both macvars are dependent on scenario and testcase, values can only be assigned later ***;
   %LET g_logfile   = ;
   %LET g_printfile = ;

   %IF %_handleError(&l_macname.
                    ,InvalidTsu
                    ,%_nobs(target.tsu) NE 1
                    ,invalid test database: target.tsu
                    ) 
      %THEN %GOTO errexit;

   %IF %_handleError(&l_macname.
                    ,MissingCas
                    ,NOT %sysfunc(exist(target.cas))
                    ,invalid test database: target.cas
                    ) 
      %THEN %GOTO errexit;

   %IF %_handleError(&l_macname.
                    ,MissingScn
                    ,NOT %sysfunc(exist(target.scn))
                    ,invalid test database: target.scn
                    ) 
      %THEN %GOTO errexit;

   %IF %_handleError(&l_macname.
                    ,MissingTst
                    ,NOT %sysfunc(exist(target.tst))
                    ,invalid test database: target.tst
                    ) 
      %THEN %GOTO errexit;

   DATA _null_;
      SET target.tsu;
      call symput ('g_project'        , trim(tsu_project));
      call symput ('g_root'           , trim(tsu_root));
      call symput ('g_sasunitroot'    , trim(tsu_sasunitroot));
      call symput ('g_sasunit'        , trim(tsu_sasunit));
      call symput ('g_sasunit_os'     , trim(tsu_sasunit_os));
      call symput ('g_sasautos'       , trim(tsu_sasautos));
      call symput ('g_sasautos0'      , trim(tsu_sasautos));
   %DO i=1 %TO 29;                     
      call symput ("g_sasautos&i"     , trim(tsu_sasautos&i));
   %END;                              
      call symput ('g_autoexec'       , trim(tsu_autoexec));
      call symput ('g_sascfg'         , trim(tsu_sascfg));
      call symput ('g_sasuser'        , trim(tsu_sasuser));
      call symput ('g_testdata'       , trim(tsu_testdata));
      call symput ('g_refdata'        , trim(tsu_refdata));
      call symput ('g_doc'            , trim(tsu_doc));
      call symput ('g_testcoverage'   , put (tsu_testcoverage, z1.));
      call symput ('g_verbose'        , put (tsu_verbose, z1.));
      call symput ('g_crossref'       , put (tsu_crossref, z1.));
      call symput ('g_crossrefsasunit', put (tsu_crossrefsasunit, z1.));
      call symput ('g_language'       , trim(tsu_language));
   RUN;

   %LET g_project      = &g_project;
   %LET g_root         = &g_root;
   %LET g_sasunitroot  = %_abspath(&g_root,&g_sasunitroot);
   %LET g_sasunit      = %_abspath(&g_root,&g_sasunit);
   %LET g_sasunit_os   = %_abspath(&g_root,&g_sasunit_os);
   %LET g_sasautos     = %_abspath(&g_root,&g_sasautos);
   %DO i=0 %TO 29;
      %LET g_sasautos&i = %_abspath(&g_root,&&g_sasautos&i);
   %END;
   %LET g_autoexec     = %_abspath(&g_root,&g_autoexec);
   %LET g_sascfg       = %_abspath(&g_root,&g_sascfg);
   %LET g_sasuser      = %_abspath(&g_root,&g_sasuser);
   %LET g_testdata     = %_abspath(&g_root,&g_testdata);
   %LET g_refdata      = %_abspath(&g_root,&g_refdata);
   %LET g_doc          = %_abspath(&g_root,&g_doc);
   %LET g_testcoverage = &g_testcoverage.;
   %LET g_rep_encoding = UTF8;

   %LET g_work     = %sysfunc(pathname(work));
   %LET g_testout  = &g_target/tst;
   %LET g_log      = &g_target/log;

   %_detectSymbols(r_error_symbol=g_error, r_warning_symbol=g_warning, r_note_symbol=g_note);

   %IF &i_withlibrefs %THEN %DO;
         LIBNAME testout "&g_testout";
         FILENAME testout "&g_testout";
      %IF %length(&g_testdata) %THEN %DO;
         LIBNAME testdata "&g_testdata";
         FILENAME testdata "&g_testdata";
         %LET g_testdata = %sysfunc(pathname(testdata));
      %END;
      %IF %length(&g_refdata) %THEN %DO;
         LIBNAME refdata "&g_refdata";
         FILENAME refdata "&g_refdata";
         %LET g_refdata = %sysfunc(pathname(refdata));
      %END;
      %IF %length(&g_doc) %THEN %DO;
         FILENAME doc "&g_doc";
      %END;
   %END;

   OPTIONS MAUTOSOURCE APPEND=(SASAUTOS=("&g_sasunit_os"
   %DO i=0 %TO 29;
      %IF "&&g_sasautos&i" NE "" %THEN "&&g_sasautos&i";
   %END;     ));
   
   %_oscmds;

   OPTIONS MAUTOSOURCE LINESIZE=MAX NOQUOTELENMAX MPRINT MPRINTNEST MCOMPILENOTE=ALL MAUTOLOCDISPLAY;
   %IF (&g_verbose. = 1) %THEN %DO;
      OPTIONS MLOGIC MLOGICNEST SYMBOLGEN ;
   %END;
   %ELSE %DO;
      OPTIONS NOMLOGIC NOMLOGICNEST NOSYMBOLGEN;
   %END;

   %put _global_;

   %GOTO exit;
%errexit:
   LIBNAME target;
 %exit:
%MEND _loadEnvironment;
/** \endcond */

/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Initialize runtime environment (macro symbols and librefs / / filerefs)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_withlibrefs 1..initialize also filerefs and librefs 
                          0..initialize only macro symbols. 
*/ /** \cond */ 

%MACRO _loadEnvironment(i_withlibrefs = 1
                       );
 
   %LOCAL l_macname; %LET l_macname=&sysmacroname;

   %GLOBAL g_target g_project g_root g_sasunit g_sasunit_os g_autoexec g_sascfg g_sasuser
           g_sasautos g_sasautos0 g_sasautos1 g_sasautos2 g_sasautos3 g_sasautos4 
           g_sasautos5 g_sasautos6 g_sasautos7 g_sasautos8 g_sasautos9 
           g_testdata g_refdata g_doc g_error g_warning g_note
           g_work g_testout g_log
           g_logfile g_printfile
           g_testcoverage
           g_verbose
           g_sasunitroot
           g_crossref
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
      call symput ('g_project'        , tsu_project);
      call symput ('g_root'           , tsu_root);
      call symput ('g_sasunitroot'    , tsu_sasunitroot);
      call symput ('g_sasunit'        , tsu_sasunit);
      call symput ('g_sasunit_os'     , tsu_sasunit_os);
      call symput ('g_sasautos'       , tsu_sasautos);
      call symput ('g_sasautos0'      , tsu_sasautos);
   %DO i=1 %TO 9;                     
      call symput ("g_sasautos&i"     , tsu_sasautos&i);
   %END;                              
      call symput ('g_autoexec'       , tsu_autoexec);
      call symput ('g_sascfg'         , tsu_sascfg);
      call symput ('g_sasuser'        , tsu_sasuser);
      call symput ('g_testdata'       , tsu_testdata);
      call symput ('g_refdata'        , tsu_refdata);
      call symput ('g_doc'            , tsu_doc);
      call symput ('g_testcoverage'   , put (tsu_testcoverage, z1.));
      call symput ('g_verbose'        , put (tsu_verbose, z1.));
      call symput ('g_crossref'       , put (tsu_crossref, z1.));
   RUN;

   %LET g_project      = &g_project;
   %LET g_root         = &g_root;
   %LET g_sasunitroot  = %_abspath(&g_root,&g_sasunitroot);
   %LET g_sasunit      = %_abspath(&g_root,&g_sasunit);
   %LET g_sasunit_os   = %_abspath(&g_root,&g_sasunit_os);
   %LET g_sasautos     = %_abspath(&g_root,&g_sasautos);
   %DO i=0 %TO 9;
      %LET g_sasautos&i = %_abspath(&g_root,&&g_sasautos&i);
   %END;
   %LET g_autoexec     = %_abspath(&g_root,&g_autoexec);
   %LET g_sascfg       = %_abspath(&g_root,&g_sascfg);
   %LET g_sasuser      = %_abspath(&g_root,&g_sasuser);
   %LET g_testdata     = %_abspath(&g_root,&g_testdata);
   %LET g_refdata      = %_abspath(&g_root,&g_refdata);
   %LET g_doc          = %_abspath(&g_root,&g_doc);
   %LET g_testcoverage = &g_testcoverage.;

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

   OPTIONS MAUTOSOURCE SASAUTOS=(SASAUTOS "&g_sasunit" "&g_sasunit_os"
   %DO i=0 %TO 9;
      %IF "&&g_sasautos&i" NE "" %THEN "&&g_sasautos&i";
   %END;     );
   
   %_oscmds;

   %put _global_;
   
   %GOTO exit;
%errexit:
   LIBNAME target;
 %exit:
%MEND _loadEnvironment;
/** \endcond */

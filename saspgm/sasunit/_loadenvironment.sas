/**
   \file
   \ingroup    SASUNIT_UTIL 

   \brief      Initialize runtime environment (macro symbols and librefs / / filerefs)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
            
   \param   i_withlibrefs    1..initialize also filerefs and librefs 
                             0..initialize only macro symbols. 
                             
*/ /** \cond */ 
%MACRO _loadEnvironment(i_withlibrefs     =1
                       ,i_caller          =SUITE
                       );
 
   %LOCAL l_macname; %LET l_macname=&sysmacroname.;
   %LOCAL l_log4SAScurrentLogLevel;

   %GLOBAL g_sasunitroot g_target g_project g_root g_sasunit g_sasunit_os g_autoexec g_sascfg g_sasuser
           g_sasautos   
           g_sasautos0  g_sasautos1  g_sasautos2  g_sasautos3  g_sasautos4  g_sasautos5  g_sasautos6  g_sasautos7  g_sasautos8  g_sasautos9 
           g_sasautos10 g_sasautos11 g_sasautos12 g_sasautos13 g_sasautos14 g_sasautos15 g_sasautos16 g_sasautos17 g_sasautos18 g_sasautos19 
           g_sasautos20 g_sasautos21 g_sasautos22 g_sasautos23 g_sasautos24 g_sasautos25 g_sasautos26 g_sasautos27 g_sasautos28 g_sasautos29 
           g_testdata g_refdata g_doc g_error g_warning g_note
           g_work g_testout g_logfile g_printfile g_caslogfile
           g_testcoverage g_crossref g_crossrefsasunit g_rep_encoding
           g_language
           ;

   %LOCAL i;
           
   %LET g_target    = %sysfunc(pathname(target));

   %*** Both macvars are dependent on scenario and testcase, values can only be assigned later ***;
   %LET g_logfile   = ;
   %LET g_printfile = ;

   %IF %_handleError(&l_macname.
                    ,InvalidTsu
                    ,%_nobs(target.tsu) < 1
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
      call symputx (catt ("G_", substr (tsu_parameterName,5)), trim(tsu_parameterValue), tsu_parameterScope);
   RUN;

   %LET g_project      = &g_project.;
   %LET g_root         = &g_root.;
   %LET g_sasunitroot  = %_abspath(&g_root,&g_sasunitroot.);
   %LET g_sasunit      = %_abspath(&g_root,&g_sasunit.);
   %LET g_sasunit_os   = %_abspath(&g_root,&g_sasunit_os.);
   %LET g_sasautos     = %_abspath(&g_root,&g_sasautos.);
   %DO i=0 %TO 29;
      %LET g_sasautos&i = %_abspath(&g_root,&&g_sasautos&i..);
   %END;
   %LET g_autoexec     = %_abspath(&g_root,&g_autoexec.);
   %LET g_sascfg       = %_abspath(&g_root,&g_sascfg.);
   %LET g_sasuser      = %_abspath(&g_root,&g_sasuser.);
   %LET g_testdata     = %_abspath(&g_root,&g_testdata.);
   %LET g_refdata      = %_abspath(&g_root,&g_refdata.);
   %LET g_doc          = %_abspath(&g_root,&g_doc.);
   %LET g_testcoverage = &g_testcoverage.;
   %LET g_rep_encoding = UTF8;

   %LET g_work     = %sysfunc(pathname(work));
   %LET g_testout  = &g_reportFolder./testDoc;
   %LET g_tempout  = &g_reportFolder./tempDoc;

   %_detectSymbols(r_error_symbol=g_error, r_warning_symbol=g_warning, r_note_symbol=g_note);

   %IF &i_withlibrefs. %THEN %DO;
         LIBNAME testout "&g_testout.";
         FILENAME testout "&g_testout.";
         LIBNAME tempout "&g_tempout.";
         FILENAME tempout "&g_tempout.";
      %IF %length(&g_testdata) %THEN %DO;
         LIBNAME testdata "&g_testdata.";
         FILENAME testdata "&g_testdata.";
      %END;
      %IF %length(&g_refdata.) %THEN %DO;
         LIBNAME refdata "&g_refdata.";
         FILENAME refdata "&g_refdata.";
      %END;
      %IF %length(&g_doc.) %THEN %DO;
         FILENAME doc "&g_doc.";
      %END;
   %END;

   %_insertAutoCallPath (&g_sasunit_os.)
   %DO i=0 %TO 29;
      %_insertAutoCallPath (&&g_sasautos&i..)
   %END;
   
   %_oscmds
   
   %if (&i_caller. = SCENARIO) %then %do;
      %let l_log4SAScurrentLogLevel=&g_log4SASScenarioLogLevel.;
      %_setLog4SASLogLevel (loggername =&g_log4SASSuiteLogger.
                           ,level      =&g_log4SASSuiteLogLevel.
                           );   
   %end;
   %else %do;
      %let l_log4SAScurrentLogLevel=&g_log4SASSuiteLogLevel.;
      %_setLog4SASLogLevel (loggername =&g_log4SASScenarioLogger.
                           ,level      =&g_log4SASScenarioLogLevel.
                           );   
      %_setLog4SASLogLevel (loggername =&g_log4SASAssertLogger.
                           ,level      =&g_log4SASAssertLogLevel.
                           );   
   %end;

   OPTIONS SOURCE SOURCE2 NOTES MAUTOSOURCE LINESIZE=MAX NOQUOTELENMAX NOMPRINT NOMLOGIC NOSYMBOLGEN NOMPRINTNEST NOMLOGICNEST MCOMPILENOTE=NONE NOMAUTOLOCDISPLAY;
   %IF (&l_log4SAScurrentLogLevel.=DEBUG) %THEN %DO;
      OPTIONS MPRINT MLOGIC SYMBOLGEN;
   %END;
   %ELSE %IF (&l_log4SAScurrentLogLevel.=TRACE) %THEN %DO;
      OPTIONS MPRINT MLOGIC SYMBOLGEN MPRINTNEST MLOGICNEST MCOMPILENOTE=ALL MAUTOLOCDISPLAY;
   %END;

   %put _global_;

   %GOTO exit;
%errexit:
   LIBNAME target;
%exit:
%MEND _loadEnvironment;
/** \endcond */
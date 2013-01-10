/**
\file
\ingroup    SASUNIT_UTIL

\brief      determine whether a test scenario has to be executed

            conditions when test scenario has to be executed
            - new test scenario
            - test scenario has been changed since last run 
            - test scenario contains a test case, where the unit under test (SAS program to 
              be tested) has been changed since last execution of the scenario. 
            - test scenario contains a unit under test which does not exist 
              (scenario has to be executed so that this will be noticed)

\param      i_scnfile absolute path to test scenario program
\param      i_changed last modification date and time of test scenario (SAS date time value)
\param      i_dir SAS dataset with all programs in all autocall libraries.
                  The data set contains the following variables: 
                  - filename absolute path to program 
                  - changed  datetime of last modification
                  - auton    autocall number 0..9
                  (dataset should be created with _sasunit_dir)
\param      r_scnid name of macro variable to return scenario id, if scenario can be found, 
                    0 otherwise
\param      r_run name of macro variable to return 1 for execute or 0 for do not execute
\return     &r_scnid and &r_run

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

/* change history
   15.12.2007 AM  Neuerstellung 
*/ 

%MACRO _sasunit_checkScenario(
   i_scnfile = 
  ,i_changed = 
  ,i_dir     = 
  ,r_scnid   = l_scnid
  ,r_run     = l_run
);

%local d_pgm;
%_sasunit_tempFileName(d_pgm)

/*-- set default return value ------------------------------------------------*/
%let &r_scnid=;
%let &r_run=0; 

/*-- standardize absolute path -----------------------------------------------*/
%local l_scnfile;
%let l_scnfile = %_sasunit_stdPath (&g_root, &i_scnfile);

/*-- determine time of last execution of test scenario -----------------------*/
%local ll_scnid l_lastrun;
%let l_lastrun=0;
%let ll_scnid=0;
proc sql noprint;
   select scn_id, compress(put(scn_start,best32.)) into :ll_scnid, :l_lastrun
   from target.scn
   where upcase(scn_path) = "%upcase(&l_scnfile)";
quit;

/*-- execute, if scenario not found or found and changed ---------------------*/
%if &l_lastrun<&i_changed %then %do;
   %put _sasunit_checkScenario <1>;
   %let &r_scnid = &ll_scnid;
   %let &r_run = 1;
   %goto exit;
%end;

/*-- determine units under test in autocall libraries and their change dtime -*/
%local l_pgmcount;
%let l_pgmcount=0;
proc sql noprint;
   select count(*) into :l_pgmcount
   from target.cas
      left join &i_dir dir 
         on upcase(cas.cas_pgm) = upcase(scan(dir.filename,-1,'/'))
            and cas.cas_auton = dir.auton
   where cas.cas_scnid = &ll_scnid
      and (&l_lastrun<dir.changed or dir.changed=.)
      and cas.cas_auton ne .
   ;
quit;

/*-- execute, if at least one unit under test is newer or is missing ---------*/
%if &l_pgmcount %then %do;
   %put _sasunit_checkScenario <2>;
   %let &r_scnid = &ll_scnid;
   %let &r_run = 1;
   %goto exit;
%end;

/*-- look for units under test not in autocall libraries ---------------------*/
proc sql noprint;
   create table &d_pgm as
      select cas.cas_pgm
      from target.cas
      where cas.cas_scnid = &ll_scnid
         and cas.cas_auton=.
   ;
quit;

/*-- do not execute if none found --------------------------------------------*/
%if %_sasunit_nobs(&d_pgm) = 0 %then %do;
   %put _sasunit_checkScenario <3>;
   %let &r_scnid = &ll_scnid;
   %let &r_run = 0;
   %goto exit;
%end;

/*-- determine last modification dtime for those units under test ------------*/
%local i;
%do i=1 %to %_sasunit_nobs(&d_pgm);
   %local l_pgm&i;
%end;
data _null_;
   set &d_pgm;
   call symput ('l_pgm' !! compress(put(_n_,8.)), trim(cas_pgm));
   call symput ('l_pgmcount', compress(put(_n_,8.)));
run;

%do i=1 %to &l_pgmcount;
   %let l_pgm&i = %_sasunit_absPath(&g_root,&&l_pgm&i);
   %_sasunit_dir(i_path=&&l_pgm&i, o_out=&d_pgm)
   
   %local l_pgmchanged;
   %let l_pgmchanged=0;
   proc sql noprint;
      select compress(put(changed,best32.)) into :l_pgmchanged
         from &d_pgm
      ;
   quit;

   /*-- execute scenario, if unit under test newer or not found --------------*/
   %if &l_lastrun < &l_pgmchanged or &l_pgmchanged=0 %then %do;
      %put _sasunit_checkScenario <4>;
      %let &r_scnid = &ll_scnid;
      %let &r_run = 1;
      %goto exit;
   %end;

%end;

/*-- do not execute scenario -------------------------------------------------*/
%put _sasunit_checkScenario <5>;
%let &r_scnid = &ll_scnid;
%let &r_run = 0;

%exit:
/*-- tidy up -----------------------------------------------------------------*/
proc datasets nolist nowarn;
   delete %scan(&d_pgm,2,.);
quit;

%MEND _sasunit_checkScenario;
/** \endcond */

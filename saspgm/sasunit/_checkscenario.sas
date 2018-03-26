/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief      determine whether a test scenario has to be executed

               conditions when test scenario has to be executed
               - new test scenario
               - test scenario has been changed since last run 
               - test scenario contains a test case, where the unit under test (SAS program to 
                 be tested) has been changed since last execution of the scenario 
               - test scenario contains a unit under test which does not exist 
                 (scenario has to be executed so that this will be noticed)
               - one of the called units under test has been changed. To make sure it still works
                 as before

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_examinee        Data set containing all SASUnit macros, test scenarios and units under test
   \param      i_scn_pre         Data set containing all test scenarios
   \param      o_scenariosToRun  Data set created in this macro holding information about scenarios that have to run
               (all data sets created in runsasunit)

               Further more the result data set dependency from macro _crossreference in work is used

*/ /** \cond */ 

%MACRO _checkScenario(i_examinee       = 
                     ,i_scn_pre        =
                     ,o_scenariosToRun =
                     );

   %GLOBAL
      d_macroList
      d_listcalling
   ;

   %LOCAL 
      l_cntObs
      d_dependency
   ;

   %LET l_cntObs = 0;

   %_tempFileName(d_dependency);
   %_tempFileName(d_listcalling);
   %_tempFileName(d_macroList);

   /* Get Scenarios and their names from target.scn */
   DATA work._scenarios;
      IF _n_ = 1 THEN DO;
         call symput ('l_cntObs',put(cnt_obs, 3.));
      END;
      DROP pos;
      SET target.scn (keep=scn_id scn_path scn_end scn_changed) nobs=cnt_obs;
      pos = find(scn_path,'/',-200)+1;
      scn_name = lowcase (substr(scn_path,pos));
      scn_filename = resolve('%_absPath(&g_root,' || scn_path || ')');
   RUN;

   PROC SQL noprint;
      create table work._findScenariosToInsertInDB as
      select . as scn_id
            ,resolve('%_stdPath(&g_root,' || filename || ')') as  scn_path length=1000
            ,changed as scn_changed
            ,. as scn_end
            ,1 as insertIntoDB
            ,filename as scn_filename
      from &i_scn_pre. where upcase (filename) not in (select upcase (scn_filename) from work._scenarios);
   QUIT;

   /* Create scn_id for new scenarios */
   DATA work._scns2insert;
      retain index &l_cntObs.;
      SET work._findScenariosToInsertInDB;
      IF scn_id EQ . THEN DO;
         index+1;
         scn_id=index;
      END;
   RUN;
   
   /* look for units under test not in autocall libraries (exa_id = 0)*/
   /* and join change datetime of examinees                           */
   PROC SQL noprint;
      create table work._curr_scenarios as
         select *
         from work._scenarios
         where upcase (scn_filename) in (select upcase (filename) from &i_scn_pre.)
      ;
      create table work._othr_scenarios as
         select *
         from work._scenarios
         where upcase (scn_filename) not in (select upcase (filename) from &i_scn_pre.)
      ;
      create table work._curr_cas_exa as
         select distinct
                cas.cas_scnid
               ,cas.cas_exaid
         from target.cas
         where cas.cas_scnid in (select scn_id from work._curr_scenarios);
      ;
      create table work._curr_examinee as
         select curr.cas_scnid
               ,max (exa.exa_changed) as exa_changed format datetime20.
         from work._curr_cas_exa curr left join target.exa
         on curr.cas_exaid = exa.exa_id
         group by cas_scnid
      ;
      create table work._scns2run as
         select scn.scn_id, scn.scn_path, scn.scn_filename, scn.scn_end, scn.scn_changed, exa.exa_changed
         from work._curr_scenarios as scn 
         left join work._curr_examinee as exa on exa.cas_scnid=scn.scn_id;
      ;
   QUIT;      

   data work._scns2run;
      set work._scns2run;
      dorun = 0;
      if (scn_end < scn_changed OR scn_end < exa_changed OR missing (exa_changed)) then do;
         dorun = 1;
      end;
   run;

   data &o_scenariosToRun.;
      set work._scns2insert work._scns2run work._othr_scenarios;
      dorun = max (dorun, insertIntoDB, 0);
      keep scn_id scn_path scn_filename scn_end scn_changed insertIntoDB DoRun;
   run;

   proc sort data=&o_scenariosToRun.;
      by scn_id;
   run;

   /* Create cross-reference and mark dependent scenarios as to be run */
   %if (&g_crossref. = 1) %then %do;
      %_crossreference(i_includeSASUnit = &g_crossrefsasunit.
                      ,i_examinee       = &i_examinee.
                      ,o_listcalling    = &d_listcalling.
                      ,o_dependency     = &d_dependency.
                      ,o_macroList      = &d_macroList.
                      );

      *** Update o_scenariosToRun with dependency information by _crossrefrence ***;
      proc sql noprint;
         *** Get modified examinees with callers ***;
         create table work._modifiedExaWithCaller as 
            select distinct exa_id as exa_id_called, exa_pgm as exa_pgm_called, Caller, CalledByCaller
               from target.exa left join &d_dependency.
               on CalledByCaller = exa_pgm
               where exa_changed >= (select tsu_lastinit from target.tsu)
                     and not missing (caller);
         *** Join exa_id for caller ***;
         create table work._modifiedExaWithCallerID as
            select distinct exa_id_called, caller, CalledByCaller, exa_id as exa_id_caller
               from work._modifiedExaWithCaller left join target.exa
               on caller = exa_pgm;
         *** Join scn_ids from caller ***;
         create table work._modifiedExaWithCallerScnID as
            select distinct exa_id_called, caller, CalledByCaller, exa_id_caller, cas_scnid
               from work._modifiedExaWithCallerID left join target.cas
               on cas_exaid = exa_id_caller
               where not missing (cas_scnid);
         *** Update scenariosToRun ***;
         update &o_scenariosToRun.
            set dorun = 1 where scn_id in (select distinct cas_scnid from work._modifiedExaWithCallerScnID);

         *** Get program name in notation as in target.cas ***;
         create table work.cas as
            select distinct (substr (cas_obj,1,index(lowcase (cas_obj),'.sas')-1)) as cas_pgm
            from target.cas;
         create table work.dep as 
            select dep.caller as lowcase_caller
                  ,coalesce (cas.cas_pgm, dep.caller) as caller
                  ,dep.called
            from &d_listcalling. as dep left join work.cas
            on lowcase (dep.caller)=lowcase(cas.cas_pgm);
         create table &d_listcalling. as 
            select dep.lowcase_caller
                  ,dep.caller
                  ,dep.called as lowcase_calledByCaller
                  ,coalesce (cas.cas_pgm, dep.called) as called
            from work.dep left join work.cas
            on lowcase (dep.called)=lowcase(cas.cas_pgm);
      quit;
   %end;

   PROC DATASETS NOLIST NOWARN LIB=WORK;
      DELETE _scenarios _findScenariosToInsertInDB _scns2insert;
      DELETE _curr_scenarios _othr_scenarios _curr_cas_exa _curr_examinee _scns2run;
      DELETE _modifiedExaWithCaller;
      DELETE _modifiedExaWithCallerID;
      DELETE _modifiedExaWithCallerScnID;
      DELETE %scan (&d_dependency.,2,.);
   QUIT;

%MEND _checkScenario;
/** \endcond */

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
               - a calling program of units under test has been changed

   \param      i_examinee        Data set containing all SASUnit macros, test scenarios and units under test
   \param      i_scn_pre         Data set containing all test scenarios
   \param      o_scenariosToRun  Data set created in this macro holding information about scenarios that have to run
               (all data sets created in runsasunit)

               Further more the result data set dependency from macro _crossreference in work is used

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
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
   DATA work.scenarios;
      IF _n_ = 1 THEN DO;
         call symput ('l_cntObs',put(cnt_obs, 3.));
      END;
      DROP pos;
      SET target.scn (keep=scn_id scn_path scn_end) nobs=cnt_obs;
      pos = find(scn_path,'/',-200)+1;
      scn_name = substr(scn_path,pos);
   RUN;

   PROC SQL noprint;
      create table work.findScenariosToInsertInDB as
      select s.scn_id
            ,CASE WHEN not missing (filename) THEN resolve('%_stdPath(&g_root,' || filename || ')')
                 ELSE scn_path
                 END as scn_path
            ,scn.changed as scn_changed
            ,s.scn_end
            ,CASE WHEN scn_id EQ . THEN 1
                 ELSE 0
                 END as insertIntoDB
      from scenarios as s
      full join &i_scn_pre. as scn
      on scn.membername=s.scn_name
      ;
   QUIT;

   /* Create scn_id for new scenarios */
   DATA work.helper1;
      retain index &l_cntObs.;
      SET work.findScenariosToInsertInDB;
      IF scn_id EQ . THEN DO;
         index+1;
         scn_id=index;
      END;
   RUN;
   
   /* look for units under test not in autocall libraries (exa_id = 0)*/
   /* and join change datetime of examinees                           */
   PROC SQL noprint;
      create table work.helper2 as
         select distinct cas_scnid
                        ,max (exa_changed) as exa_changed format datetime20.
                        ,min (cas_exaid) as exa_id
         from target.cas left join target.exa
         on cas_exaid = exa.exa_id
         group by cas_scnid
      ;
      create table &o_scenariosToRun. as
      select h1.scn_id, h1.scn_path, h1.scn_end, h1.scn_changed, h1.insertIntoDB,
         case WHEN scn_end < scn_changed OR scn_end < exa_changed OR exa_id = 0 THEN 1
              ELSE 0
              END as dorun
      from work.helper1 as h1 
      left join work.helper2 as h2 on h2.cas_scnid=h1.scn_id
      order by scn_id;
      ;
   QUIT;      

   /* Create cross-reference and mark dependent scenarios as to be run */
   %if (&g_crossref. = 1) %then %do;
      %_crossreference(i_includeSASUnit = &g_crossrefsasunit.
                      ,i_examinee       = &d_examinee.
                      ,o_listcalling    = &d_listcalling.
                      ,o_dependency     = &d_dependency.
                      ,o_macroList      = &d_macroList.
                      );

      *** Update d_scenariosToRun with dependency information vom _crossrefrence ***;
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
         update &d_scenariosToRun.
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
      DELETE helper1 helper2 findScenariosToInsertInDB;
      DELETE _modifiedExaWithCaller;
      DELETE _modifiedExaWithCallerID;
      DELETE _modifiedExaWithCallerScnID;
      DELETE %scan (&d_dependency.,2,.);
   QUIT;

%MEND _checkScenario;
/** \endcond */

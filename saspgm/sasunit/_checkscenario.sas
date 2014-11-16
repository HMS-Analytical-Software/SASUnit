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
   \param      i_dependency      Data set containing information about the calling hierarchy
   \param      i_scenariosToRun  Data set created in this macro holding information about scenarios that have to run
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
                     ,i_dependency     =
                     ,i_scenariosToRun =
                     );
   %LOCAL l_cntObs;
   %LET l_cntObs = 0;

   /* Get Scenarios and their names from target.scn */
   DATA scenarios;
      IF _n_ = 1 THEN DO;
         call symput ('l_cntObs',put(cnt_obs, 3.));
      END;
      DROP pos;
      SET target.scn(keep=scn_id scn_path scn_end) nobs=cnt_obs;
      pos = find(scn_path,'/',-200)+1;
      scn_name = substr(scn_path,pos);
   RUN;

   PROC SQL noprint;
      create table findScenariosToInsertInDB as
      select s.scn_id, scn.changed as scn_changed, s.scn_end, scn.membername as name,
         CASE WHEN scn_id EQ . THEN 1
              ELSE 0
              END as insertIntoDB
      from scenarios as s
      full join &i_scn_pre as scn
      on scn.membername=s.scn_name
      ;
   QUIT;

   /* Create scn_id for new scenarios */
   DATA helper1;
      retain index &l_cntObs;
      SET findScenariosToInsertInDB;
      IF scn_id EQ . THEN DO;
         index+1;
         scn_id=index;
      END;
   RUN;
   
   /* look for units under test not in autocall libraries */
   PROC SQL noprint;
      create table noAutocall as
         select unique cas_scnid
         from target.cas
         where cas_auton= .
      ;
      /* Map dependencies for each test scenario and check which scenario needs to be run*/
      create table Dependenciesbyscenario as
      select h.scn_id, h.name, h.scn_end, h.scn_changed, d.calledByCaller, s.changed as called_changed, h.insertIntoDB,
         case WHEN scn_end < scn_changed OR scn_end < called_changed OR h.scn_id in (select cas_scnid from noAutocall) THEN 1
              ELSE 0
              END as dorun
      from helper1 as h 
      left join &i_dependency as d on h.name = d.caller
      left join &i_examinee as s on s.membername=d.calledByCaller
      order by scn_id;
      ;
      
      /* Condense information to one observation per scenario */
      create table &i_scenariosToRun as
      select distinct d1.scn_id, e.membername as name, d1.insertIntoDB, e.filename, (select max(dorun) as dorun 
                                                                                       from Dependenciesbyscenario as d
                                                                                       where e.membername = d.name
                                                                                       group by d.name 
                                                                                    ) as dorun
      from &i_scn_pre. as e, Dependenciesbyscenario as d1
      where d1.name = e.membername
      ;
   QUIT;

%MEND _checkScenario;
/** \endcond */

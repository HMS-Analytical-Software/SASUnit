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

\param      i_examinee  Data set containing all SASUnit macros, test scenarios and units under test
\param      i_scn_pre   Data set containing all test scenarios
            (both data sets created in runsasunit)

            Further more the result data set dependency from macro _crossreference in work is used

\version    \$Revision$
\author     \$Author$
\date       \$Date$
\sa         \$HeadURL$
\copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
            This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
            For terms of usage under the GPL license see included file readme.txt
            or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _checkScenario(i_examinee=
                     ,i_scn_pre=
                     );

   /* Get Scenarios and their names from target.scn */
   DATA scenarios;
      IF _n_ = 1 THEN DO;
         retain pttrn;
         pttrn = prxparse('/\w+\.sas/');
      END;
      DROP pos pttrn;
      SET target.scn(keep=scn_id scn_path scn_end);
      pos = prxmatch(pttrn,scn_path);
      scn_name = substr(scn_path,pos);
   RUN;

   PROC SQL noprint;
      create table helper as
      select s.scn_id, scn.changed as scn_changed, s.scn_end, scn.membername as name
      from scenarios as s
      right join &i_scn_pre as scn
      on scn.membername=s.scn_name
      ;
      create table Dependenciesbyscenario as
      select h.scn_id, h.name, h.scn_end, h.scn_changed, d.calledByCaller, s.changed as called_changed
      from helper as h, dependency as d, &i_examinee as s
      where h.name = d.caller and s.membername=d.calledByCaller
      ;
   QUIT;

   /* Check if scenario needs to be run */
   DATA Dependenciesbyscenario;
      SET Dependenciesbyscenario;
      IF scn_id =. THEN DO;
         dorun = 1;
         scn_id = 0;
      END;
      ELSE IF scn_end < scn_changed or scn_end < called_changed THEN DO;
         dorun = 1;
      END;
      ELSE DO;
         dorun = 0;
      END;
   RUN;

   PROC SQL;
      create table scenariosToRun as
      select distinct d1.scn_id, e.membername as name, e.filename, (select max(dorun) as dorun 
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

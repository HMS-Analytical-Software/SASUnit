/**
   \file
   \ingroup    SASUNIT_SCN 

   \brief      Start of a new test scenario that comprises an invocation of
               a program under test and one or more assertions.

               internally: 
               - Insertion of relevant data into the test repository
               - Redirection of SAS log
               - Setting of flag g_inTestcase

   \version    \$Revision: 451 $
   \author     \$Author: klandwich $
   \date       \$Date: 2015-09-07 08:49:43 +0200 (Mo, 07 Sep 2015) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/inittestcase.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_object          relative or absolute path of the scenario source code file (optional: default=_AUTOMATIC_ -> running program is captured from session metadata.)
   \param   i_desc            description of the test case (optional: No default)

*/ /** \cond */ 

%MACRO initScenario(i_object =_AUTOMATIC_
                   ,i_desc   =_NONE_
                   );

   %global g_inScenario g_inTestCase g_inTestCall g_scnID;
   %local l_scenarioPath;
   
   %if &g_inScenario. EQ 1 %then %do;
      %put ERROR: initScenario must not be called twice!;
   %end;
   %if &g_inTestCall. EQ 1 %then %do;
      %put ERROR: initScenario must not be called within a testcall!;
   %end;
   %if &g_inTestCase. EQ 1 %then %do;
      %put ERROR: initScenario must not be called within a testcase!;
   %end;
   %let g_inTestCase=0;
   %let g_inTestCall=0;
   %let g_inScenario=0;
   
   %_readEnvMetadata;
   
   %local l_changed l_scnID;
   %let l_scnid =0;

   %if (%bquote(&i_object.) ne _AUTOMATIC_) %then %do;
       %let l_scenarioPath           =%_stdPath(&g_ROOT, &i_object.);
       %let g_runningProgramFullName =&l_scenarioPath.;
   %end;

   filename _CUR_SCN "&g_runningProgramFullName.";
   proc sql noprint;
      select put (max(1,max(scn_id)+1), z3.) into :g_scnID from target.scn;
      select modate into :l_changed from sashelp.vextfl where fileref="_CUR_SCN";
      select scn_id into :l_scnID 
         from target.scn 
         where "&g_runningProgramFullName." contains trim(scn_path);
      select scn_id into :g_scnID 
         from target.scn 
         where "&g_runningProgramFullName." contains trim(scn_path);
   quit;
   filename _CUR_SCN clear;
   
   %let l_changed="&l_changed."dt;

   proc sql noprint;
      %if (&l_scnID. = 0) %then %do;
        insert into target.scn VALUES (&g_scnID.,"%_stdpath(&g_root., &g_runningProgramFullName.)","&i_desc.",%sysfunc(datetime()),.,&l_changed.,.,.,.,.);
      %end;
      %else %do;
         update target.scn 
            set
                scn_start   =%sysfunc(datetime())
               ,scn_changed =&l_changed.
            %if (%nrbquote(&i_desc.) ne _NONE_) %then %do;
               ,scn_desc    ="&i_desc"
               %end;         
            where scn_id = &g_scnID.;
      %end;
      delete from target.cas where cas_scnid=&g_scnID.;
      delete from target.tst where tst_scnid=&g_scnID.;
   quit;
   
   /* set global macro symbols and librefs / filerefs  */
   /* includes creation of autocall paths */
   %_loadenvironment;
   
   %let g_inscenario=1;
%MEND initScenario;
/** \endcond */

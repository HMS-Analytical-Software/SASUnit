/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether a report file exists and was created during the current SAS session.

               It is possible to write an instruction into the test protocol indicating the need
               to perform a manual check of the report.

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

               Writes an entry into the test repository indicating the need to perform a manual 
               check of the report and copies the report and a given report template (optional).

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_expected     optional: file name for the expected file (full path or file in &g_refdata)
   \param   i_actual       file name for created report file (full path!)
   \param   i_desc         description of the assertion to be checked 
   \param   i_manual       1 (default): in case of a positive check result einen Eintrag indicating a manual check (empty rectangle). 
                           0: in case of a positive check result, write an entry indicating OK (green hook).
 */ /** \cond */ 

%MACRO assertReport (
    i_expected =       
   ,i_actual   =       
   ,i_desc     =       
   ,i_manual   = 1
);

   /*-- enforce sequence of calls ----------------------------------------------*/
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error: assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL l_expected l_exp_ext l_rep_ext l_result l_casid l_tstid l_path;
   /*-- get current ids for test case and test --------- ------------------------*/
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType   =assertreport
                                 ,i_scnid        =&g_scnid.
                                 ,i_casid        =&l_casid.
                                 ,i_tstid        =&l_tstid.
                                 ,r_path         =l_path
                                 );


   /*-- check for existence and check change date -------------------------------*/
   %LET l_result=2;
   %IF "&i_actual" NE "" %THEN %DO;
      %local d_dir;
      %_tempFileName(d_dir)
      %_dir(i_path=&i_actual, o_out=&d_dir)
      data _null_;
         set &d_dir nobs=nobs;
         if nobs ne 1 then stop;
         if changed < dhms (today(), hour (input ("&systime",time5.)), minute (input ("&systime",time5.)), 0) then stop;
         call symput ('l_result', '1');
         stop;
      run;
      proc sql;
         drop table &d_dir;
      quit;
      %IF %sysfunc(fileexist(&i_actual)) %THEN %LET l_rep_ext = %_getExtension(&i_actual);
   %END;

   %IF NOT &i_manual AND &l_result=1 %THEN %LET l_result=0;

   %LET l_expected = %_abspath(&g_refdata,&i_expected);
   %IF "&l_expected" NE "" %THEN %DO;
      %IF %sysfunc(fileexist(&l_expected)) %THEN %DO;
         %LET l_exp_ext = %_getExtension(&l_expected);
      %END;
   %END;

   %_asserts(
       i_type     = assertReport
      ,i_expected = &l_exp_ext
      ,i_actual   = &l_rep_ext
      ,i_desc     = &i_desc
      ,i_result   = &l_result
      ,r_casid    = l_casid
      ,r_tstid    = l_tstid
   )

   /* copy actual report if it exists */
   %IF &l_rep_ext NE %THEN %DO;
      %_copyFile(&i_actual, &l_path./_man_act&l_rep_ext);
   %END;

   /* copy expected report if it exists  */
   %IF &l_exp_ext NE %THEN %DO;
      %_copyFile(&l_expected, &l_path./_man_exp&l_exp_ext);
   %END;
%MEND assertReport;
/** \endcond */

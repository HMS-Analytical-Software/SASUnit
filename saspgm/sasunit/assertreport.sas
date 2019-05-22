/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether a report file exists and was created during the current SAS session.

               It is possible to write an instruction into the test protocol indicating the need to perform a manual check of the report. \n
               Writes an entry into the test repository indicating the need to perform a manual check of the report and copies the report and a given report template (optional).

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$

   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_expected           optional: file name for the expected file (full path or file in &g_refdata)
   \param   i_actual             file name for created report file (full path!)
   \param   i_desc               description of the assertion to be checked \n
                                 default: "Compare documents"
   \param   i_manual             1: in case of a positive check result, write an entry indicating a manual check (empty rectangle). \n
                                 0: in case of a positive check result, write an entry indicating OK (green hook). \n
                                 default: 1
*/ /** \cond */ 

%MACRO assertReport (i_expected           =       
                    ,i_actual             =       
                    ,i_desc               = Compare documents
                    ,i_manual             = 1
                    );

   /*-- verify correct sequence of calls-----------------------------------------*/
   %GLOBAL g_inTestCase;
   %endTestCall(i_messageStyle=NOTE);
   %IF %_checkCallingSequence(i_callerType=assert) NE 0 %THEN %DO;      
      %RETURN;
   %END;

   %LOCAL l_expected l_exp_ext l_rep_ext l_result l_casid l_tstid l_path l_errmsg l_macname;

   %LET l_macname=&sysmacroname;

   %*** check parameters ***;
   %LET l_rep_ext  = %_getExtension(&i_actual);

   %IF ("&i_actual." EQ "") %THEN %DO;
      %LET l_errmsg = parameter i_actual is missing!;
      %LET l_result=2;
      %GOTO Update;
   %END;

   %IF not (%sysfunc (fileexist(&i_actual.))) %THEN %DO;
      %LET l_errmsg = File i_actual (&i_actual.) does not exist!;
      %LET l_result=2;
      %GOTO Update;
   %END;

   %IF ("&i_expected." EQ "") %THEN %DO;
      %LET l_errmsg = parameter i_expected is missing!;
   %END;
   %ELSE %DO;
      %LET l_expected = %_abspath(&g_refdata,&i_expected);
      %IF (%sysfunc (fileexist(&l_expected.))) %THEN %DO;
         %LET l_exp_ext  = %_getExtension(&l_expected);
      %END;
   %END;

   /*-- check for existence and check change date -------------------------------*/
   %LET l_result=2;
   %LET l_errmsg=Report was not created anew!;
   %local d_dir;
   %_tempFileName(d_dir)
   %_noxcmd_dir(i_path=&i_actual, o_out=&d_dir)
   data _null_;
      set &d_dir nobs=nobs;
      if nobs ne 1 then stop;
      if changed < dhms (today(), hour (input ("&systime",time5.)), minute (input ("&systime",time5.)), 0) then do;
         stop;
      end;
      call symput ('l_result', '1');
      stop;
   run;
   proc sql;
      drop table &d_dir;
   quit;

   *** At this point the report is created and checked for existance ***;
   %IF &l_result. = 1 %THEN %LET l_errmsg=_NONE_;

   %IF NOT &i_manual AND &l_result=1 %THEN %LET l_result=0;

   /*-- get current ids for test case and test --------- ------------------------*/
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %if (&g_runMode.=SASUNIT_BATCH) %then %do;
      %*** create subfolder ***;
      %_createTestSubfolder (i_assertType   =assertreport
                            ,i_scnid        =&g_scnid.
                            ,i_casid        =&l_casid.
                            ,i_tstid        =&l_tstid.
                            ,r_path         =l_path
                            );

      /* copy actual report if it exists */
      %IF &l_rep_ext. NE %THEN %DO;
         %_copyFile(&i_actual, &l_path./_man_act&l_rep_ext);
      %END;

      /* copy expected report if it exists  */
      %IF &l_exp_ext. NE %THEN %DO;
         %_copyFile(&l_expected, &l_path./_man_exp&l_exp_ext);
      %END;
   %end;

   %*************************************************************;
   %*** Check if XCMD is allowed                              ***;
   %*************************************************************;
   %IF %_handleError(&l_macname.
                 ,NOXCMD
                 ,(%sysfunc(getoption(XCMD)) = NOXCMD)
                 ,Your SAS Session does not allow XCMD%str(,) therefore check your report in the report viewer.
                 ,i_verbose=&g_verbose.
                 ) 
   %THEN %DO;
      %LET l_rc    =1;
      %LET l_result=1;
      %LET l_errmsg=Your SAS Session does not allow XCMD%str(,) therefore check your report in the report viewer.;
      %GOTO Update;
   %END;

%Update:
   %_asserts(i_type     = assertReport
            ,i_expected = &l_exp_ext.
            ,i_actual   = &l_rep_ext.
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,r_casid    = l_casid
            ,r_tstid    = l_tstid
            ,i_errmsg   = &l_errmsg.
   )

%MEND assertReport;
/** \endcond */

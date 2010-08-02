/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      Check whether a report file exists and was created during the current SAS session.

               It is possible to write an instruction into the test protocol indicating the need
               to perform a manual check of the report.

               Please refer to the description of the test tools in _sasunit_doc.sas

               Writes an entry into the test repository indicating the need to perform a manual 
               check of the report and copies the report and a given report template (optional).

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_expected     optional: file name for the expected file (full path or file in &g_refdata)
   \param   i_actual       file name for created report file (full path!)
   \param   i_desc         description of the assertion to be checked 
   \param   i_manual       1 (default): in case of a positive check result einen Eintrag indicating a manual check (empty rectangle). 
                           0: in case of a positive check result, write an entry indicating OK (green hook).
 */ /** \cond */ 


/* 
   30.06.2008 AM  - kleine Dokumentationsänderung
   15.02.2008 AM  - kleine Dokumentationsänderung
   06.02.2008 AM  - umbenannt nach assertReport
                  - Parameter i_manual hinzugefügt, um auch eine Reine Prüfung auf 
                    existierendes File (mit grünem Symbol) durchführen zu können
                  - Prüfung auf neueres File hinzugefügt
                    Unterstrich vor den Dateinamen der kopierten Reports hinzugefügt, 
                    damit auch SAS-Dateien korrekt gehandhabt werden
*/

%MACRO assertReport (
    i_expected =       
   ,i_actual   =       
   ,i_desc     =       
   ,i_manual   = 1
);

/*-- enforce sequence of calls ----- -----------------------------------------*/
%GLOBAL g_inTestcase;
%IF &g_inTestcase EQ 1 %THEN %DO;
   %endTestcall;
%END;
%ELSE %IF &g_inTestcase NE 2 %THEN %DO;
   %PUT &g_error: assert must be called after initTestcase;
   %RETURN;
%END;

/*-- check for existence and check change date -------------------------------*/
%LOCAL l_rep_ext l_result;
%LET l_result=1;
%IF "&i_actual" NE "" %THEN %DO;
   %local d_dir;
   %_sasunit_tempFileName(d_dir)
   %_sasunit_dir(i_path=&i_actual, o_out=&d_dir)
data _null_;
   set &d_dir nobs=nobs;
   if nobs ne 1 then stop;
   if changed < dhms (today(), hour (input ("&systime",time5.)), minute (input ("&systime",time5.)), 0) then stop;
   call symput ('l_result', '2');
   stop;
run;
proc sql;
   drop table &d_dir;
quit;
   %IF %sysfunc(fileexist(&i_actual)) %THEN %LET l_rep_ext = %_sasunit_getExtension(&i_actual);
%END;

%IF NOT &i_manual AND &l_result=2 %THEN %LET l_result=0;

%LOCAL l_expected l_exp_ext;
%LET l_expected = %_sasunit_abspath(&g_refdata,&i_expected);
%IF "&l_expected" NE "" %THEN %DO;
   %IF %sysfunc(fileexist(&l_expected)) %THEN %DO;
      %LET l_exp_ext = %_sasunit_getExtension(&l_expected);
   %END;
%END;

%LOCAL l_casid l_tstid;
%_sasunit_asserts(
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
   %_sasunit_copyFile(&i_actual, &g_testout/_%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._man_act&l_rep_ext);
%END;

/* copy expected report if it exists  */
%IF &l_exp_ext NE %THEN %DO;
   %_sasunit_copyFile(&l_expected, &g_testout/_%substr(00&g_scnid,%length(&g_scnid))_&l_casid._&l_tstid._man_exp&l_exp_ext);
%END;

%MEND assertReport;
/** \endcond */

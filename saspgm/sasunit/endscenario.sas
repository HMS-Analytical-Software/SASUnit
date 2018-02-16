/**
   \file
   \ingroup  SASUNIT_UTIL

   \brief    ends scenario call in interactive sessions

   \version    \$Revision: 451 $
   \author     \$Author: klandwich $
   \date       \$Date: 2015-09-07 08:49:43 +0200 (Mo, 07 Sep 2015) $
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_checklog.sas $
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param    o_environment
   \param    o_starttype
*/
/** \cond */ 
%MACRO endScenario();
   %global g_inScenario g_inTestCase g_inTestCall g_scnID;

   %if &g_inScenario. NE 1 %then %do;
      %endTestcase
   %end;

   %local l_result;
   
/* Geht erst ab SAS Version 9.3
   %endTestcase
*/
/* Wegen SAS Version 9.2 muss es noch so gemacht werden */
   %if &g_inTestCase. EQ 1 %then %do;
      %endTestcase
   %end;
/* Wegen SAS Version 9.2 muss es noch so gemacht werden */

   proc sql noprint;
      select max (cas_res) into :l_result from target.cas WHERE cas_scnid=&g_scnid.;
   QUIT;

   PROC SQL NOPRINT;
      UPDATE target.scn
      SET 
         scn_res = &l_result.
        ,scn_end = %sysfunc(datetime())
      WHERE 
         scn_id = &g_scnid.;
   QUIT;

   %if (&g_runmode. = SASUNIT_INTERACTIVE) %then %do;
      *** Create formats used in reports ***;
      proc format lib=work;
         value PictName     0 = "^{style [color=green]OK}"
                            1 = "^{style [color=black]Manual}"
                            2 = "^{style [color=white background=red]Error}"
                            OTHER="?????";
      run;

      title1 "&g_nls_endScenario_001.";
      title2 "&g_nls_endScenario_002.";
      proc print data=target.scn noobs label;
         where scn_id = &g_scnid.;
         format scn_res PictName.;
         label 
            scn_id           = "&g_nls_endScenario_005."
            scn_path         = "&g_nls_endScenario_006."
            scn_desc         = "&g_nls_endScenario_007."
            scn_start        = "&g_nls_endScenario_008."
            scn_end          = "&g_nls_endScenario_009."
            scn_changed      = "&g_nls_endScenario_010."
            scn_rc           = "&g_nls_endScenario_011."
            scn_errorcount   = "&g_nls_endScenario_012."
            scn_warningcount = "&g_nls_endScenario_013."
            scn_res          = "&g_nls_endScenario_014."
         ;
      run;

      title1 "^_";
      title2 "&g_nls_endScenario_003.";
      proc print data=target.cas noobs label;
         where cas_scnid = &g_scnid.;
         format cas_res PictName.;
         label 
            cas_scnid = "&g_nls_endScenario_015."
            cas_id    = "&g_nls_endScenario_005."
            cas_exaid = "&g_nls_endScenario_016."
            cas_obj   = "&g_nls_endScenario_017."
            cas_desc  = "&g_nls_endScenario_007."
            cas_spec  = "&g_nls_endScenario_017."
            cas_start = "&g_nls_endScenario_008."
            cas_end   = "&g_nls_endScenario_009."
            cas_res   = "&g_nls_endScenario_014."
         ;
      run;

      title2 "&g_nls_endScenario_004.";
      proc print data=target.tst noobs label;
         where tst_scnid = &g_scnid.;
         format tst_res PictName.;
         by tst_casid;
         label 
            tst_scnid  = "&g_nls_endScenario_015."
            tst_casid  = "&g_nls_endScenario_019."
            tst_id     = "&g_nls_endScenario_005."
            tst_type   = "&g_nls_endScenario_020."
            tst_desc   = "&g_nls_endScenario_007."
            tst_exp    = "&g_nls_endScenario_021."
            tst_act    = "&g_nls_endScenario_022."
            tst_res    = "&g_nls_endScenario_024."
            tst_errmsg = "&g_nls_endScenario_023."
         ;
      run;
   %end;

   %LET g_inScenario=0;
%MEND endScenario;
/** \endcond */

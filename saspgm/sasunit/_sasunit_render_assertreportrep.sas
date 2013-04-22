/** \file
   \ingroup    SASUNIT_REPORT

   \brief      copy reports for assertReport and create frame page for comparison where necessary
               (if two reports have been specified)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_assertype    type of assert beeing done. It is know be the program itself, but nevertheless specified as parameter.
   \param   i_repdata      name of reporting dataset containing information on the assert.
   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder
*/ /** \cond */  

%MACRO _sasunit_render_assertReportRep (i_assertype=
                                       ,i_repdata  =
                                       ,i_scnid    =
                                       ,i_casid    = 
                                       ,i_tstid    = 
                                       ,o_html     = 
                                       ,o_path     = 
                                       );

   %local l_ifile l_ofile l_path ;

   title;footnote;

   %_sasunit_getTestSubfolder (i_assertType=assertReport
                              ,i_root      =&g_target./tst
                              ,i_scnid     =&i_scnid.
                              ,i_casid     =&i_casid.
                              ,i_tstid     =&i_tstid.
                              ,r_path      =l_path
                              );

   proc sql noprint;
      select tst_act, tst_exp into :l_extAct,:l_extExp from &i_repdata.
      where scn_id=&i_scnid. AND cas_id=&i_casid. AND tst_id=&i_tstid.;
   quit;

   %let l_ifile=&l_path./_man_;
   %let l_ofile=&o_path./_&i_scnid._&i_casid._&i_tstid._man_;

   %if %sysfunc(fileexist(%nrbquote(&l_ifile.exp&l_extexp.))) %then %do;
      %_sasunit_copyFile (%nrbquote(&l_ifile.exp&l_extexp.), &l_ofile.exp%nrbquote(&l_extexp.));
   %end;   
   %if %sysfunc(fileexist(%nrbquote(&l_ifile.act&l_extact.))) %then %do;
      %_sasunit_copyFile (%nrbquote(&l_ifile.act&l_extact.), &l_ofile.act%nrbquote(&l_extact.));
   %end;

   %if %sysfunc(fileexist(%nrbquote(&l_ifile.exp&l_extexp.))) and %sysfunc(fileexist(%nrbquote(&l_ifile.act&l_extact.))) %then %do;
      %if (&o_html.) %then %do;
         data _null_;
            file "&o_path./_&i_scnid._&i_casid._&i_tstid._man_rep.html";
            %_sasunit_reportHeaderHTML(%str(&g_nls_reportMan_001 &i_scnid - &g_nls_reportMan_002 &i_casid - &g_nls_reportMan_003 &i_tstid - &g_nls_reportMan_004));
            put '<frameset rows="50%,50%">';
            put "   <frame src=""_&i_scnid._&i_casid._&i_tstid._man_exp&l_extexp"" name=""Expected"">";
            put "   <frame src=""_&i_scnid._&i_casid._&i_tstid._man_act&l_extact"" name=""Actual"">";
            put "</frameset>";
            put '</body>';
            put '</html>';
         run; 
      %end;
   %end;
%MEND _sasunit_render_assertReportRep;
/** \endcond */

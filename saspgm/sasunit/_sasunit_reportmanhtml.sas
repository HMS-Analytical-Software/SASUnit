/** \file
   \ingroup    SASUNIT_REPORT

   \brief      copy reports for assertReport and create frame page for comparison where necessary
               (if two reports have been specified)

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   i_extexp       extension of the expected report file with leading dot (for instance .pdf), 
                           may be empty, in which case report will not be copied
   \param   i_extact       extension of the actual report file with leading dot (for instance .pdf), 
                           may be empty, in which case report will not be copied
   \param   o_html         complete path to output file for frameset, 
                           if two reports should be compared
   \param   o_output       output folder for reports 

*/ /** \cond */  

/* change log
   22.07.2009 AM  necessary modifications for LINUX
   19.08.2008 AM  national language support
   11.08.2008 AM  Frameseite erzeugen, wenn zwei Reports verglichen werden.
   05.02.2008 AM  Unterstrich zu Beginn der Kopierziele hinzugefügt, 
                  damit auch SAS-Dateien korrekt verarbeitet werden.
*/ 

%MACRO _sasunit_reportManHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
  ,i_extexp  = 
  ,i_extact  = 
  ,o_html    = 
  ,o_output  = 
);

%local l_ifile l_ofile;
%let l_ifile=&g_target/tst/_&i_scnid._&i_casid._&i_tstid._man_;
%let l_ofile=&o_output/_&i_scnid._&i_casid._&i_tstid._man_;

%if %sysfunc(fileexist(&l_ifile.exp&i_extexp)) %then %do;
   %_sasunit_copyFile (&l_ifile.exp&i_extexp, &l_ofile.exp&i_extexp);
%end;
%if %sysfunc(fileexist(&l_ifile.act&i_extact)) %then %do;
   %_sasunit_copyFile (&l_ifile.act&i_extact, &l_ofile.act&i_extact);
%end;

%if %sysfunc(fileexist(&l_ifile.exp&i_extexp)) and %sysfunc(fileexist(&l_ifile.act&i_extact)) %then %do;
data _null_;
   file "&o_html";
   %_sasunit_reportHeaderHTML(%str(&g_nls_reportMan_001 &i_scnid - &g_nls_reportMan_002 &i_casid - &g_nls_reportMan_003 &i_tstid - &g_nls_reportMan_004));
   put '<frameset rows="50%,50%">';
   put "   <frame src=""_&i_scnid._&i_casid._&i_tstid._man_exp&i_extexp"" name=""Expected"">";
   put "   <frame src=""_&i_scnid._&i_casid._&i_tstid._man_act&i_extact"" name=""Actual"">";
   put "</frameset>";
   put '</body>';
   put '</html>';
run; 
%end;

%MEND _sasunit_reportManHTML;
/** \endcond */

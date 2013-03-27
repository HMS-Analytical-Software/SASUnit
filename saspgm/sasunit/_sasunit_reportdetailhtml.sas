/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create page with detail information of a test case in HTML format

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   i_scnid        scenario id of test case
   \param   i_casid        id of test case
   \param   o_html         output file in HTML format

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Rework assertion framework: Use of new rendering macros
   29.01.2013 BB  Hard coded date and time formats replaced. ReportDetail formats 49 and 50 applied.
   08.01.2013 KL  Empty cells are rendered incorrectly in MS IE. So &nbsp; is now used as contents of an empty cell
   26.09.2008 AM  bug fixing NLS: standard description texts for assertLog(Msg)
   18.08.2008 AM  added national language support
   11.08.2008 AM  Frameseite für den Vergleich zweier Reports bei ASSERTREPORT einbinden
   07.07.2008 AM  Formatierung für assertColumns verbessert
   05.02.2008 AM  assertManual nach assertReport umgestellt
   29.12.2007 AM  Informationen zum Prüfling hinzugefügt
   15.12.2007 AM  überflüssige Variable hlp entfernt.
*/ 

%MACRO _sasunit_reportDetailHTML (
   i_repdata =
  ,i_scnid   =
  ,i_casid   = 
  ,o_html    =
);

   %LOCAL
      l_nls_reportdetail_errors
      l_NumAssert
   ;
   %LET l_nls_reportdetail_errors   = %STR(error(s));

   proc sql noprint;
      select count (distinct tst_type) into :_numAsserts from target.tst where tst_scnid = &i_scnid AND tst_casid = &i_casid;
   quit;

   %do l_NumAssert=1 %to &_numAsserts.;
       %local assertType&l_NumAssert.
       ;
   %end;

   /* 
      substr is necessary because macronames may only be up to 32 characters!
      We should think about renaming the macro:                              
      _utl_xxx  for utility macros
      _rpt_xxx  for reporting macros
      _rdr_xxx  for rendering macros (if the should be separated from _rpt_xxx)
   
      _utl_copydir
      _utl_asserts
      _utl_checklog
      _rpt_detailHTML
      _rdr_assertPerformanceExp
   */
   proc sql noprint;
      select distinct substr(tst_type,1,13) into :assertType1-:assertType%cmpres(&_numAsserts.) from target.tst where tst_scnid = &i_scnid AND tst_casid = &i_casid;
   quit;

   DATA _NULL_;
      SET &i_repdata END=eof;
      WHERE scn_id = &i_scnid AND cas_id = &i_casid;

      LENGTH 
         abs_path    $  256 
         hlp         $  200 
         hlp2        $  200
         errcountmsg $  50
      ;

      FILE "&o_html";

      IF _n_=1 THEN DO;
         %_sasunit_reportPageTopHTML(
            i_title   = %str(&g_nls_reportDetail_001 &i_scnid..&i_casid | &g_project - &g_nls_reportDetail_002)
           ,i_current = 0
         );
         %_sasunit_reportScenarioTestCase;

         PUT '<table>';
         PUT '<tr>';
         PUT '   <td class="tabheader">' "&g_nls_reportDetail_009</td>";
         PUT '   <td class="tabheader">' "&g_nls_reportDetail_010</td>";
         PUT '   <td class="tabheader">' "&g_nls_reportDetail_011</td>";
         PUT '   <td class="tabheader">' "&g_nls_reportDetail_012</td>";
         PUT '   <td class="tabheader">' "&g_nls_reportDetail_013</td>";
         PUT '   <td class="tabheader">' "&g_nls_reportDetail_014</td>";
         PUT '</tr>';
      END;

      PUT '<tr id="tst' tst_id z3. '">';

      SELECT(upcase(tst_type));
         WHEN ('ASSERTLOG') DO; 
            IF tst_desc=' ' THEN tst_desc="&g_nls_reportDetail_041";
         END;
         WHEN ('ASSERTLOGMSG') DO; 
            IF tst_desc=' ' THEN tst_desc="&g_nls_reportDetail_047";
         END;
         OTHERWISE;
      END;

      if tst_act="" then tst_act='&nbsp;';
      if tst_exp="" then tst_exp='&nbsp;';
      
      %_sasunit_render_idColumn   (i_sourceColumn=tst_id, i_format=z3.);
      %_sasunit_render_dataColumn (i_sourceColumn=tst_type);
      %_sasunit_render_dataColumn (i_sourceColumn=tst_desc);

      %do l_NumAssert=1 %to &_numAsserts;
         if (upcase(tst_type)="%upcase(&&asserttype&l_NumAssert.)") then do;
            %_sasunit_render_&&asserttype&l_NumAssert..Exp (i_sourceColumn=tst_exp);
            %_sasunit_render_&&asserttype&l_NumAssert..Act (i_sourceColumn=tst_act);
         end;
      %end;

      %_sasunit_render_iconColumn (i_sourceColumn=tst_res);

      PUT '</tr>';

      IF eof THEN DO;
         PUT '</table>';
         %_sasunit_reportFooterHTML();
      END;
   run;
 
%MEND _sasunit_reportDetailHTML;
/** \endcond */

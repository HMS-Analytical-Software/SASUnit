/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertRecordCount

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param      i_sourceColumn   name of the column holding the value
   \param      o_html           Test report in HTML-format?
   \param      o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertRecordCountAct (i_sourceColumn=
                                    ,o_html=0
                                    ,o_targetColumn=
                                    );
         
   hlp = trim(left(&i_sourceColumn.));
   select (hlp);
       when (-1) hlp = "&g_nls_reportRecordCount_001.";
       when (-2) hlp = "&g_nls_reportRecordCount_002.";
       when (-3) hlp = "&g_nls_reportRecordCount_003.";
       when (-4) hlp = "&g_nls_reportRecordCount_004.";
       when (-5) hlp = "&g_nls_reportRecordCount_005.";
       otherwise hlp = trim(hlp);
   end;

   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );
                       
                       
   href     = catt ('_', put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   %if (&o_html.) %then %do;
      href_act = catt (href,'_assertrecordcount_rep.html');
   %end;
   
   &o_targetColumn. = catt ("^{style [flyover=""&g_nls_reportRecordCount_007"" url=""", href_act, """] &g_nls_reportRecordCount_006. } ^n ");
   &o_targetColumn. = catt (hlp, "^n", &o_targetColumn.);
%mend _render_assertRecordCountAct;
/** \endcond */

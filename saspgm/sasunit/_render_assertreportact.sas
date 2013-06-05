/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertReport

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn   name of the column holding the value
   \param   i_expectedColumn name of the column holding the expected value.<em>(optional: Default=tst_exp)</em>
   \param   o_html           Test report in HTML-format?
   \param   o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertReportAct (i_sourceColumn=
                                       ,i_expectedColumn=tst_exp
                                       ,o_html=
                                       ,o_targetColumn=
                                       );
   IF &i_sourceColumn. EQ '^_' OR &i_sourceColumn. EQ '' THEN DO;
      %** While actual report does not exist, render the column in error state ***;
      &i_sourceColumn. = "&g_nls_reportDetail_048";
      %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                                  ,i_columnType=datacolumnerror
                                  ,o_targetColumn=&o_targetColumn.
                                  );
   END;
   ELSE DO;
      href     = catt ("_", put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
      href_act = catt (href,'_man_act');
      %if (&o_html.) %then %do;
         href_rep = catt (href,'_man_rep.html');
      %end;
      IF &i_expectedColumn. NE '^_' AND &i_expectedColumn. NE ' ' THEN DO; 
         %*** Link to reporting html, if both results exist ***;
         i_linkColumn = href_rep;
         i_linkTitle  = "&g_nls_reportDetail_020.";
      END;
      ELSE DO; 
         %*** Link to expected document, if only one results exists ***;
         %*** Document type is contained in tst_exp                 ***;
         i_linkColumn = catt (href_act, &i_sourceColumn.);
         i_linkTitle  = "&g_nls_reportDetail_023.";
      END;
      IF tst_res=2 THEN hlp = trim (&i_sourceColumn.) !! " - &g_nls_reportDetail_022!";
      ELSE hlp = &i_sourceColumn.;
      %_render_dataColumn (i_sourceColumn=hlp
                                  ,i_linkTitle=i_linkTitle
                                  ,i_linkColumn=i_linkColumn
                                  ,o_targetColumn=&o_targetColumn.
                                  );
   END;
%mend _render_assertReportAct;
/** \endcond */

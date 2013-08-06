/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertReport

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   i_actualColumn name of the column holding the actual value.<em>(optional: Default=tst_act)</em>
   \param   o_html           Test report in HTML-format?
   \param   o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertReportExp (i_sourceColumn=
                               ,i_actualColumn=tst_act
                               ,o_html=
                               ,o_targetColumn=
                               );
   IF &i_sourceColumn. EQ '^_' OR &i_sourceColumn. EQ ' ' THEN DO;
      %** render empty actual column ***;
      %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                          ,o_targetColumn=&o_targetColumn.
                          );
   END;
   ELSE DO;
      href     = catt ("_", put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
      href_exp = catt (href,'_man_exp');
      %if (&o_html.) %then %do;
         href_rep = catt (href,'_man_rep.html');
      %end;
      IF &i_actualColumn. NE '^_' AND &i_actualColumn. NE ' ' THEN DO; 
         %*** Link to reporting html, if both results exist ***;
         i_linkColumn = href_rep;
         i_linkTitle  = "&g_nls_reportDetail_020.";
      END;
      ELSE DO; 
         %*** Link to expected document, if only one results exists ***;
         %*** Document type is contained in tst_exp                 ***;
         i_linkColumn = catt (href_exp, &i_sourceColumn.);
         i_linkTitle  = "&g_nls_reportDetail_021.";
      END;
      %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                          ,i_linkTitle=i_linkTitle
                          ,i_linkColumn=i_linkColumn
                          ,o_targetColumn=&o_targetColumn.
                          );
   END;
%mend _render_assertReportExp;
/** \endcond */

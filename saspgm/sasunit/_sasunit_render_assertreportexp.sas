/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertReport

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   i_actualColumn name of the column holding the actual value.<em>(optional: Default=tst_act)</em>
   \param   i_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Created
*/ 

%macro _sasunit_render_assertReportExp (i_sourceColumn=
                                       ,i_actualColumn=tst_act
                                       ,i_targetColumn=
                                       );
   IF &i_sourceColumn. EQ '&nbsp;' OR &i_sourceColumn. EQ ' ' THEN DO;
      %** render empty actual column ***;
      %_sasunit_render_dataColumn (i_sourceColumn=&i_sourceColumn.);
   END;
   ELSE DO;
      IF &i_actualColumn. NE '&nbsp;' AND &i_actualColumn. NE ' ' THEN DO; 
         %*** Link to reporting html, if both results exist ***;
         i_linkColumn = catt ("_", put (scn_id, z3.), "_", put (cas_id, z3.), "_", put (tst_id, z3.), "_rep.html");
         i_linkTitle  = "&g_nls_reportDetail_020.";
      END;
      ELSE DO; 
         %*** Link to expected document, if only one results exists ***;
         %*** Document type is contained in tst_exp                 ***;
         i_linkColumn = catt ("_", put (scn_id, z3.), "_", put (cas_id, z3.), "_", put (tst_id, z3.), "_man_exp", &i_sourceColumn.);
         i_linkTitle  = "&g_nls_reportDetail_021.";
      END;
      %_sasunit_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                                  ,i_linkTitle=i_linkTitle
                                  ,i_linkColumn=i_linkColumn
                                  );
   END;
%mend _sasunit_render_assertReportExp;
/** \endcond */

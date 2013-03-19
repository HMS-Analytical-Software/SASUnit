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
   \param   i_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Created
*/ 
%macro _sasunit_render_assertReportAct (i_sourceColumn=
                                       ,i_expectedColumn=tst_exp
                                       ,i_targetColumn=
                                       );
   IF (upcase(tst_type) = 'ASSERTREPORT') THEN DO;
      IF &i_sourceColumn. EQ '&nbsp;' OR &i_sourceColumn. EQ '' THEN DO;
         %** While actual report does not exist, render the column in error state ***;
         &i_sourceColumn. = "&g_nls_reportDetail_048";
         %_sasunit_render_dataColumn (i_sourceColumn=&i_sourceColumn., i_columnType=datacolumnerror);
      END;
      ELSE DO;
         IF &i_expectedColumn. NE '&nbsp;' AND &i_expectedColumn. NE ' ' THEN DO; 
            %*** Link to reporting html, if both results exist ***;
            i_linkColumn = catt ("_", put (scn_id, z3.), "_", put (cas_id, z3.), "_", put (tst_id, z3.), "_rep.html");
            i_linkTitle  = "&g_nls_reportDetail_020.";
         END;
         ELSE DO; 
            %*** Link to expected document, if only one results exists ***;
            %*** Document type is contained in tst_exp                 ***;
            i_linkColumn = catt ("_", put (scn_id, z3.), "_", put (cas_id, z3.), "_", put (tst_id, z3.), "_man_act", &i_sourceColumn.);
            i_linkTitle  = "&g_nls_reportDetail_023.";
         END;
         IF tst_res=1 THEN hlp = trim (&i_sourceColumn.) !! " - &g_nls_reportDetail_022!";
         ELSE hlp = &i_sourceColumn.;
         %_sasunit_render_dataColumn (i_sourceColumn=hlp
                                     ,i_linkTitle=i_linkTitle
                                     ,i_linkColumn=i_linkColumn
                                     );
      END;
   END;
%mend _sasunit_render_assertReportAct;
/** \endcond */

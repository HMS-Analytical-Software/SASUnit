/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertColumns

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   i_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Created
*/ 

%macro _sasunit_render_assertColumnsAct (i_sourceColumn=
                                        ,i_targetColumn=
                                        );
   IF (upcase(tst_type) = 'ASSERTCOLUMNS') THEN DO;
      PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportDetail_016" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_act.html">' "&g_nls_reportDetail_038" '</a><br />';
      PUT '                          <a class="lightlink" title="' "&g_nls_reportDetail_017" '" href="' scn_id z3. '_' cas_id z3. '_' tst_id z3. '_cmp_rep.html">' "&g_nls_reportDetail_039" '</a><br />' &i_sourceColumn. '</td>';
   END;
%mend _sasunit_render_assertColumnsAct;
/** \endcond */

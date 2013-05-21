/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertLibrary

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

/* change log
   14.03.2013 KL  Created
*/ 

%macro _sasunit_render_assertLibraryExp (i_sourceColumn=
                                        ,o_html=
                                        ,o_targetColumn=
                                        );

   href     = catt (put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   %if (&o_html.) %then %do;
      href_exp = catt (href,'_library_exp.html');
   %end;
   &o_targetColumn. = catt ("^{style [flyover=""&g_nls_reportDetail_018."" url=""", href_exp, """] &g_nls_reportDetail_040. }^n^n", &i_sourceColumn.);
%mend _sasunit_render_assertLibraryExp;
/** \endcond */

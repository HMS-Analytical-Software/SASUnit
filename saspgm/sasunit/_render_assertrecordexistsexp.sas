/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertRecordExists

   \version \$Revision: 191 $
   \author  \$Author: b-braun $
   \date    \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa      \$HeadURL: https://menrath@svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertequalsexp.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertRecordExistsExp (i_sourceColumn=
                                     ,o_html=
                                     ,o_targetColumn=
                                     );
   %_render_dataColumn(i_sourceColumn=&i_sourceColumn.
                      ,o_targetColumn=&o_targetColumn.
                      );
%mend _render_assertRecordExistsExp;
/** \endcond */

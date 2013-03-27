/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertLog

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

%macro _sasunit_render_assertLogAct (i_sourceColumn=
                                    ,i_targetColumn=
                                    );
   hlp = "&g_nls_reportDetail_036: " !! trim(scan(&i_sourceColumn.,1,'#')) !! ", &g_nls_reportDetail_037: " !! trim(scan(&i_sourceColumn.,2,'#'));
   %_sasunit_render_dataColumn (i_sourceColumn=hlp
                               ,i_targetColumn=&i_targetColumn.
                               );
%mend _sasunit_render_assertLogAct;
/** \endcond */

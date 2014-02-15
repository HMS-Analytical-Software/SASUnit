/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertRecordCount

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param      i_sourceColumn   name of the column holding the value
   \param      i_expectedColumn name of the column holding the expected value.<em>(optional: Default=tst_exp)</em>
   \param      o_html           Test report in HTML-format?
   \param      o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertRecordCountAct (i_sourceColumn=
                                    ,o_html=
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
%mend _render_assertRecordCountAct;
/** \endcond */
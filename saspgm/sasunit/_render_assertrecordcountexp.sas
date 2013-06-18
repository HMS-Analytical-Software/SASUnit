/** \file
   \ingroup    SASUNIT_REPORT
	 
   \brief      renders the layout of the expected column for assertRecordCount

   \version \$Revision: 191 $
   \author  \$Author: b-braun $
   \date    \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa      \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertRecordCountExp.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   i_actualColumn name of the column holding the actual value.<em>(optional: Default=tst_act)</em>
   \param   o_html           Test report in HTML-format?
   \param   o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertRecordCountExp (i_sourceColumn=
                                   ,o_html=
                                   ,o_targetColumn=
                                   );
				hlp = &i_sourceColumn.;
				select (hlp);
					 when (-1) hlp = "&g_nls_reportRecordCount_001.";
					 when (-2) hlp = "&g_nls_reportRecordCount_002.";
					 when (-3) hlp = "&g_nls_reportRecordCount_003.";
					 when (-4) hlp = "&g_nls_reportRecordCount_004.";
					 when (-5) hlp = "&g_nls_reportRecordCount_005.";
					 otherwise;
				end;	
			
			
      %_render_dataColumn (i_sourceColumn=hlp
                          ,o_targetColumn=&o_targetColumn.
                          );
%mend _render_assertRecordCountExp;
/** \endcond */

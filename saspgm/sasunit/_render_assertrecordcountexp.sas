/**
   \file
   \ingroup    SASUNIT_REPORT
    
   \brief      renders the layout of the expected column for assertRecordCount

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param      i_sourceColumn name of the column holding the value
   \param      o_html           Test report in HTML-format?
   \param      o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 
%macro _render_assertRecordCountExp (i_sourceColumn=
                                    ,o_html=0
                                    ,o_targetColumn=
                                    );
                                   
   hlp = &i_sourceColumn.;
   select (hlp);
       when ("-1") hlp = "&g_nls_reportRecordCount_001.";
       when ("-2") hlp = "&g_nls_reportRecordCount_002.";
       when ("-3") hlp = "&g_nls_reportRecordCount_003.";
       when ("-4") hlp = "&g_nls_reportRecordCount_004.";
       when ("-5") hlp = "&g_nls_reportRecordCount_005.";
       otherwise;
   end;  
         
   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );
%mend _render_assertRecordCountExp;
/** \endcond */
/** \file
   \ingroup    SASUNIT_REPORT
    
   \brief      renders the layout of the expected column for assertPrimaryKey

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertPrimaryKeyExp (i_sourceColumn=
                                   ,o_html=
                                   ,o_targetColumn=
                                   );
                                   
   hlp = "&g_nls_reportPrimaryKey_006.";      
   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );
                       
%mend _render_assertPrimaryKeyExp;
/** \endcond */
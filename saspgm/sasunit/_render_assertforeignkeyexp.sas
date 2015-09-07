/** \file
   \ingroup    SASUNIT_REPORT
    
   \brief      renders the layout of the expected column for assertForeignKey

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_sourceColumn name of the column holding the value
   \param   i_actualColumn name of the column holding the actual value.<em>(optional: Default=tst_act)</em>
   \param   o_html           Test report in HTML-format?
   \param   o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertForeignKeyExp (i_sourceColumn=
                                   ,o_html=0
                                   ,o_targetColumn=
                                   );
                                   
   hlp2 = &i_sourceColumn.;                                  
   select (hlp2);
      when ("TRUE") hlp = "&g_nls_reportForeignKey_016. " || "&g_nls_reportForeignKey_017.";
      otherwise     hlp = "&g_nls_reportForeignKey_016. " || "&g_nls_reportForeignKey_018.";
   end;                    
   hlp = catt (hlp,"^n");
      
   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );
                       
%mend _render_assertForeignKeyExp;
/** \endcond */

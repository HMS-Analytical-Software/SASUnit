/**
   \file
   \ingroup    SASUNIT_REPORT
    
   \brief      renders the layout of the expected column for assertTableExists

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
%macro _render_assertTableExistsExp (i_sourceColumn=
                                    ,o_html=0
                                    ,o_targetColumn=
                                    );
                                   
   hlp2 = scan(&i_sourceColumn., 1, ":");
   if (hlp2 in ("DATA", "VIEW", "CATALOG")) then do;
      select (hlp2);
         when ("DATA")     hlp = "&g_nls_reportTableExist_004.";
         when ("VIEW")     hlp = "&g_nls_reportTableExist_005.";
         when ("CATALOG")  hlp = "&g_nls_reportTableExist_006.";
         otherwise;
      end;

      hlp2 = scan(&i_sourceColumn., 2, ":");
      hlp = catx(" ",hlp,hlp2);
      hlp2 = scan(&i_sourceColumn., 3, ":");
      select (hlp2);
         when (0) hlp = catt(hlp," &g_nls_reportTableExist_007.");
         when (1) hlp = catt(hlp," &g_nls_reportTableExist_008.");
         otherwise;
      end;
   end;
   else do;
      /* invalid type */
      hlp = tst_errMsg;    
   end;
 
   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );

%mend _render_assertTableExistsExp;
/** \endcond */
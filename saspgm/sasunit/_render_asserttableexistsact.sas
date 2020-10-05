/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertTableExists

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param      i_sourceColumn   name of the column holding the value
   \param      o_html           Test report in HTML-format?
   \param      o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 
%macro _render_assertTableExistsAct (i_sourceColumn=
                                    ,o_html=0
                                    ,o_targetColumn=
                                    );
                                   
   hlp2 = scan(&i_sourceColumn., 1, "#");
   select (hlp2);
      when (-2) hlp = "&g_nls_reportTableExist_009.";
      when (-1) hlp = "&g_nls_reportTableExist_001.";
      when ( 0) hlp = "&g_nls_reportTableExist_002.";
      when ( 1) hlp = "&g_nls_reportTableExist_003.";
       otherwise;
   end;

   hlp2 = scan(&i_sourceColumn., 2, "#");
   if (length(trim(hlp2)) > 10) then do;
      hlp2 = put(input(compress(put(hlp2,32.)),32.),&g_nls_reportDetail_050.);
      hlp  = catx(" ", hlp,"^n","&g_nls_reportTableExist_010." ,hlp2);
      hlp2 = scan(&i_sourceColumn., 3, "#");
      hlp2 = put(input(compress(put(hlp2,32.)),32.),&g_nls_reportDetail_050.);
      hlp  = catx(" ", hlp,"^n","&g_nls_reportTableExist_011." ,hlp2);
   end;
   
   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );
                       
%mend _render_assertTableExistsAct;
/** \endcond */
/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertLogMsg

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */  

%macro _render_assertLogMsgExp (i_sourceColumn=
                               ,o_html=0
                               ,o_targetColumn=
                               );
   hlp  = substr(&i_sourceColumn.,1,1); 
   if hlp='1' then hlp="&g_nls_reportDetail_042"; 
   else            hlp="&g_nls_reportDetail_043"; 
   &i_sourceColumn. = substr(&i_sourceColumn.,2);
   hlp = "&g_nls_reportDetail_044 " !! trim(&i_sourceColumn.) !! " " !! trim(hlp);
   %_render_dataColumn (i_sourceColumn=hlp
                       ,o_targetColumn=&o_targetColumn.
                       );
%mend _render_assertLogMsgExp;
/** \endcond */

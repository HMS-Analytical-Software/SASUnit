/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertExternal

   \version    \$Revision: 315 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertequalsact.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */  

%macro _render_assertExternalAct (i_sourceColumn=
                               ,o_html=
                               ,o_targetColumn=
                               );
   hlp = TRIM(LEFT(&i_sourceColumn.));
   SELECT (hlp);
       WHEN (-2)  hlp = "&g_nls_reportExternal_001.";
       WHEN (-3)  hlp = "&g_nls_reportExternal_002.";
       WHEN (-4)  hlp = "&g_nls_reportExternal_003.";

       otherwise hlp = hlp;
   end;
   
   %_render_dataColumn(i_sourceColumn=hlp
                      ,o_targetColumn=&o_targetColumn.
                      );
%mend _render_assertExternalAct;
/** \endcond */

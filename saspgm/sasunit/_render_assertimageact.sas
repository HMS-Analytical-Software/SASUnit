/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertImage

   \version    \$Revision: 260 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-09-08 20:47:54 +0200 (So, 08 Sep 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertcolumnsact.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn       name of the column holding the value
   \param   o_html               Test report in HTML-format?
   \param   o_targetColumn       name of the target column holding the ODS formatted value

*/ /** \cond */ 

%MACRO _render_assertImageAct (i_sourceColumn=
                              ,o_html=
                              ,o_targetColumn=
                              );                    
                              
   hlp       = SCAN(TRIM(LEFT(&i_sourceColumn.)),1,"#");
   extension = SCAN(TRIM(LEFT(&i_sourceColumn.)),2,"#");

   SELECT (hlp);
       WHEN (-2)  hlp = "&g_nls_reportText_001.";
       WHEN (-3)  hlp = "&g_nls_reportText_002.";
       WHEN (-4)  hlp = "&g_nls_reportText_003.";

       otherwise hlp = hlp;
   end;

   href     = CATT ('_',PUT (scn_id, z3.),'_',PUT (cas_id, z3.),'_',PUT (tst_id, z3.));
   %IF (&o_html.) %THEN %DO;
      href_act = CATT (href,'_image_act',extension);
      href_rep = CATT (href,'_image_diff.png');
   %END;
   &o_targetColumn. = CATT ("^{style [flyover=""&g_nls_reportImage_005"" url=""", href_act, """] &g_nls_reportImage_004. } ^n ");
   &o_targetColumn. = CATT (&o_targetColumn., " ^{style [flyover=""&g_nls_reportImage_005"" url=""", href_rep, """] &&g_nls_reportImage_006. } ^n ", hlp);
%MEND _render_assertImageAct;
/** \endcond */

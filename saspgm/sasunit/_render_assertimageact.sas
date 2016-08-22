/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertImage

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
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
   imagepath = SCAN(TRIM(LEFT(&i_sourceColumn.)),3,"#");

   SELECT (hlp);
       WHEN (-2)  hlp = "&g_nls_reportImage_009.";
       WHEN (-3)  hlp = "&g_nls_reportImage_001.";
       WHEN (-4)  hlp = "&g_nls_reportImage_010.";
       WHEN (-5)  hlp = "&g_nls_reportImage_002.";
       WHEN (-6)  hlp = "&g_nls_reportImage_011.";
       WHEN (-7)  hlp = "&g_nls_reportImage_003.";
       WHEN (-8)  hlp = "&g_nls_reportImage_012.";

       otherwise hlp = hlp;
   end;

   href         = CATT ('_',PUT (scn_id, z3.),'_',PUT (cas_id, z3.),'_',PUT (tst_id, z3.));
   
   %IF (&o_html.) %THEN %DO;
      href_act = CATT (href,'_image_act',extension);
      href_rep = CATT (href,'_image_diff.png');
   %END;
   
   tooltip_act  = catx(" ","&g_nls_reportImage_005.:", imagepath);
   tooltip_cmp  = "&g_nls_reportImage_006.";

   &o_targetColumn. = CATT ("^{style [flyover=""", tooltip_act , """ url=""", href_act, """] &g_nls_reportImage_004. } ^n ");
   &o_targetColumn. = CATT (&o_targetColumn., " ^{style [flyover=""", tooltip_cmp , """ url=""", href_rep, """] &g_nls_reportImage_006. } ^n ", hlp);
%MEND _render_assertImageAct;
/** \endcond */

/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertImage

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

%MACRO _render_assertImageExp (i_sourceColumn=
                              ,o_html=
                              ,o_targetColumn=
                              );
                              
   hlp       = SCAN(TRIM(LEFT(&i_sourceColumn.)),1,"#");
   extension = SCAN(TRIM(LEFT(&i_sourceColumn.)),2,"#");
   imagepath = SCAN(TRIM(LEFT(&i_sourceColumn.)),3,"#");
                              
   href     = catt ('_',put (scn_id, z3.),'_',put (cas_id, z3.),'_',put (tst_id, z3.));
   tooltip  = catx(" ","&g_nls_reportImage_008.:", imagepath);
   %IF (&o_html.) %THEN %DO;
      href_exp = catt (href,'_image_exp',extension);
   %END;
   &o_targetColumn. = catt ("^{style [flyover=""", tooltip , """ url=""", href_exp, """] &g_nls_reportImage_007. } ^n &g_nls_reportImage_014.:", " " !! extension, " ^n &g_nls_reportImage_013.:", " " !! hlp);
%MEND _render_assertImageExp;
/** \endcond */

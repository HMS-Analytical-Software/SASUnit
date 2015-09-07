/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the icon column

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_sourceColumnname name of the column holding the value
   \param   o_html             Test report in HTML-format?
   \param   i_targetColumn     name of the column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_iconcolumn (i_sourceColumn=
                          ,o_html=0
                          ,o_targetColumn=
                          );

   %local l_pictNameFmt;

   %let l_pictNameFmt=PictName.;
   %if (&o_html.) %then %do;
      %let l_pictNameFmt=PictNameHTML.;
   %end;

   &o_targetColumn. = '^{style [postimage="' !! trim(put (&i_sourceColumn., &l_pictNameFmt.)) !! '" flyover="' !! trim(put (&i_sourceColumn., PictDesc.)) !! '" fontsize=0pt]' !! &i_sourceColumn !! '}';
%mend _render_iconcolumn;
/** \endcond */

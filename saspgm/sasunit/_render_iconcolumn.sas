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
			   
   \param   i_sourceColumnname Name of the column holding the value
   \param   o_html             Test report in HTML-format?
   \param   o_targetColumn     Name of the column holding the ODS formatted value
   \param   i_iconOffset       Offset for the image name format. (Optional: Default=.)

*/ /** \cond */ 
%macro _render_iconColumn (i_sourceColumn=
                          ,o_html=0
                          ,o_targetColumn=
                          ,i_iconOffset=.
                          );

   %local l_pictNameFmt;

   %let l_pictNameFmt=PictName.;
   %if (&o_html.) %then %do;
      %let l_pictNameFmt=PictNameHTML.;
   %end;

   &o_targetColumn. = '^{style [postimage="' !! "&i_iconOffset./" !! trim(put (&i_sourceColumn., &l_pictNameFmt.)) !! '" flyover="' !! trim(put (&i_sourceColumn., PictDesc.)) !! '" fontsize=0pt]' !! &i_sourceColumn !! '}';
%mend _render_iconColumn;
/** \endcond */
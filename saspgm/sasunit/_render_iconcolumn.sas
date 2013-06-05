/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the icon column

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumnname name of the column holding the value
   \param   i_targetColumn     name of the column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_iconcolumn (i_sourceColumn=
                                  ,o_html=
                                  ,o_targetColumn=
                                  );

   %local l_pictNameFmt;

   %let l_pictNameFmt=PictName.;
   %if (&o_html.) %then %do;
      %let l_pictNameFmt=PictNameHTML.;
   %end;

   &o_targetColumn. = '^{style [postimage="' !! trim(put (&i_sourceColumn., &l_pictNameFmt.)) !! '" flyover="' !! trim(put (&i_sourceColumn., PictDesc.)) !! '"] }';
%mend _render_iconcolumn;
/** \endcond */

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

/* change log
   07.03.2013 KL  Created
*/ 

%macro _sasunit_render_iconcolumn (i_sourceColumn=
                                  ,i_targetColumn=
                                  );
   PUT '   <td class="iconcolumn"><img src=' @;
   SELECT (&i_sourceColumn.);
      WHEN (0) PUT '"ok.png" alt="OK"' @;
      WHEN (1) PUT '"error.png" alt="' "&g_nls_reportDetail_025" '"' @;
      WHEN (2) PUT '"manual.png" alt="' "&g_nls_reportDetail_026" '"' @;
      OTHERWISE PUT '"?????" alt="' "&g_nls_reportDetail_027" '"' @;
   END;
   PUT '></img></td>';
%mend _sasunit_render_iconcolumn;
/** \endcond */

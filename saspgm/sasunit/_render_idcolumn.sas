/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of any id column

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
   \param   i_format       name of the format that will be applied to the value. <em>(optional: _NONE_)</em>.
   \param   i_linkColumn   name of the column holding the value for the path (href) og the link. <em>(optional: _NONE_)</em>.
   \param   i_linkTitle    name of the column holding the value for the title (flyover) of the link. <em>(optional: _NONE_)</em>.
   \param   i_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_idcolumn (i_sourceColumn=
                        ,i_format=_NONE_
                        ,i_linkColumn=_NONE_
                        ,i_linkTitle=_NONE_
                        ,o_targetColumn=
                        );

      %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                          ,i_format=&i_format.
                          ,i_linkColumn=&i_linkColumn.
                          ,i_linkTitle=&i_linkTitle.
                          ,o_targetColumn=&o_targetColumn.
                          );
%mend _render_idcolumn;
/** \endcond */

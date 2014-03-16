/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertPerformance

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
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */ 

%macro _render_assertPerformanceAct (i_sourceColumn=
                                    ,i_format=_NONE_
                                    ,o_html=0
                                    ,o_targetColumn=
                                    );
   %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                       ,i_format      =&i_format.
                       ,o_targetColumn=&o_targetColumn.
                       );
%mend _render_assertPerformanceAct;
/** \endcond */

/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertPerformance

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_sourceColumn name of the column holding the value
   \param   i_format       name of the format that will be applied to the value. <em>(optional: _NONE_)</em>.
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */  

%macro _render_assertPerformanceExp (i_sourceColumn=
                                    ,i_format=_NONE_
                                    ,o_html=0
                                    ,o_targetColumn=
                                    );
   %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                       ,i_format      =&i_format.
                       ,o_targetColumn=&o_targetColumn.
                       );
%mend _render_assertPerformanceExp;
/** \endcond */

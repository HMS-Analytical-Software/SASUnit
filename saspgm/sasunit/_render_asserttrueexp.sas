/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the expected column for assertTrue

   \author     \$Author$
   \author     Author: canczc
   \param   i_sourceColumn name of the column holding the value
   \param   o_html         Test report in HTML-format?
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */  
%macro _render_assertTrueExp (i_sourceColumn=
                         		,o_html=0
                         		,o_targetColumn=
                         	);
   %_render_dataColumn (i_sourceColumn=&i_sourceColumn.
                       ,o_targetColumn=&o_targetColumn.
                       );
%mend _render_assertTrueExp;
/** \endcond */
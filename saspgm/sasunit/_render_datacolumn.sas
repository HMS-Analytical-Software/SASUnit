/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of a generic data column

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://github.com/HMS-Analytical-Software/SASUnit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  Copyright 2010-2023 HMS Analytical Software GmbH, http://www.analytical-software.de
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GNU Lesser General Public License see included file README.md
               or https://github.com/HMS-Analytical-Software/SASUnit/wiki/readme/.
			   
   \param   i_sourceColumn name of the column holding the value
   \param   i_format       name of the format that will be applied to the value. <em>(optional: _NONE_)</em>.
   \param   i_linkColumn   name of the column holding the value for the path (href) or the link. <em>(optional: _NONE_)</em>.
   \param   i_linkTitle    name of the column holding the value for the title (flyover) of the link. <em>(optional: _NONE_)</em>.
   \param   i_columnType   type of the column as defined in the CSS ("datacolumn" / "datacolumnerror"). <em>(optional: _NONE_)</em>.
   \param   o_targetColumn name of the target column holding the ODS formatted value

*/ /** \cond */  
%macro _render_dataColumn (i_sourceColumn=
                          ,i_format=_NONE_
                          ,i_linkColumn=_NONE_
                          ,i_linkTitle=_NONE_
                          ,i_columnType=_NONE_
                          ,o_targetColumn=
                          );

      %local l_format l_doStyle l_doBrackets;

      %let l_doStyle    = %eval (&i_columnType. ne _NONE_ OR &i_linkColumn. ne _NONE_ OR &i_linkTitle. ne _NONE_);
      %let l_doBrackets = %eval (&i_linkColumn. ne _NONE_ OR &i_linkTitle. ne _NONE_);

      %let l_format=;
      %if (&i_format. ne _NONE_) %then %do;
         %let l_format=&i_format.;
      %end;
      %let i_columnType=%lowcase(&i_columnType.);

      %if (&l_doStyle.) %then %do;
         &o_targetColumn. = "^{style";
      %end;
      %else %do;
         &o_targetColumn. = "";
      %end;
      %if (&i_columnType. ne _none_) %then %do;
         &o_targetColumn. = catt (&o_targetColumn., " &i_columnType.");
      %end;
      %if (&l_doBrackets.) %then %do;
         &o_targetColumn. = catt (&o_targetColumn., " [");
      %end;
      %if (&i_linkTitle. ne _NONE_) %then %do;
         &o_targetColumn. = catt (&o_targetColumn., 'flyover="',&i_linkTitle.,'"');
      %end;
      %if (&i_linkColumn. ne _NONE_) %then %do;
         &o_targetColumn. = catt (&o_targetColumn., ' url="',&i_linkColumn.,'"');
      %end;
      %if (&l_doBrackets.) %then %do;
         &o_targetColumn. = catt (&o_targetColumn., "]");
      %end;
      %if (&i_format. ne _NONE_) %then %do;
         %if (&l_doStyle.) %then %do;
            &o_targetColumn. = catt (&o_targetColumn., " " !! put (&i_sourceColumn., &l_format.));
         %end;
         %else %do;
            &o_targetColumn. = catt (&o_targetColumn., put (&i_sourceColumn., &l_format.));
         %end;
      %end;
      %else %do;
         if (vtype(&i_sourceColumn.)="N") then do;
            _formatName="BEST32.";
            %if (&l_doStyle.) %then %do;
               &o_targetColumn. = catt (&o_targetColumn., " " !! compress (putn (&i_sourceColumn., _formatName)));
            %end;
            %else %do;
               &o_targetColumn. = catt (&o_targetColumn., compress (putn (&i_sourceColumn., _formatName)));
            %end;
         end;
         else do;
            %if (&l_doStyle.) %then %do;
               &o_targetColumn. = catt (&o_targetColumn., " " !! &i_sourceColumn.);
            %end;
            %else %do;
               &o_targetColumn. = catt (&o_targetColumn., &i_sourceColumn.);
            %end;
         end;
      %end;
      %if (&l_doStyle.) %then %do;
         &o_targetColumn. = catt (&o_targetColumn., "}");
      %end;
%mend _render_dataColumn;
/** \endcond */
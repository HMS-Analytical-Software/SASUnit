/** \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of a generic data column

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_sourceColumn name of the column holding the value
   \param   i_format       name of the format that will be applied to the value. <em>(optional: _NONE_)</em>.
   \param   i_linkColumn   name of the column holding the value for the path (href) og the link. <em>(optional: _NONE_)</em>.
   \param   i_linkTitle    name of the column holding the value for the title (flyover) of the link. <em>(optional: _NONE_)</em>.
   \param   i_targetColumn name of the target column holding the ODS formatted value
   \param   i_columnType   type of the column as defined in the CSS ("datacolumn" / "datacolumnerror"). <em>(optional: datacolumn)</em>.

*/ /** \cond */ 

/* change log
   26.02.2013 KL  Created
*/ 

%macro _sasunit_render_datacolumn (i_sourceColumn=
                                  ,i_format=_NONE_
                                  ,i_linkColumn=_NONE_
                                  ,i_linkTitle=_NONE_
                                  ,i_targetColumn=
                                  ,i_columnType=datacolumn
                                  );

      %local l_format;
      %let l_format=;
      %if (&i_format. ne _NONE_) %then %do;
         %let l_format=&i_format.;
      %end;
      %let i_columnType=%lowcase(&i_columnType.);

      PUT "<td class=""&i_columnType."">" @;
      %if (&i_linkColumn. ne _NONE_) %then %do;
         PUT '<a class="lightlink" ' @;
         %if (&i_linkTitle ne _NONE_) %then %do;
            PUT 'title="' &i_linkTitle. '" ' @;
         %end;
         PUT 'href="' &i_linkColumn. '">' @;
      %end;
      PUT &i_sourceColumn. &l_format. @;
      %if (&i_linkColumn. ne _NONE_) %then %do;
         PUT '</a>' @;
      %end;
      PUT '</td>';

%mend _sasunit_render_datacolumn;
/** \endcond */

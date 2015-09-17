/**
   \file

   \brief   Render header section of program documentation 

   \details Works on a pre-defined dataset and separates simple tags from complex ones.

            Simple tags are those that consists of a tagname and a value like \\brief or \\author
            Complex tags consist of tagname parameter name and a value like \\retval or \\param

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param   i_lib      Library of input data set
   \param   i_data     Name of input data set
   \param   i_language Lanuage in which the documentation should be created. (optional: Default=EN)

   \return reporting object
*/ /** \cond */
%macro _reportPgmHeader (i_lib=, i_data=, i_language=EN);

   data WORK._RPGH;
      set &i_lib..&i_data.;
      new_name=name;
      lag_name=lag(name);
      if (name ne '' AND lag_name eq name) then do;
         new_name='';
      end;
      if (tag="\details") then do;
         tag = "\brief";
      end;
      tag_text=tag;
   run;

   data WORK._RPGH_HEADER;
      set _RPGH (where=(tag_sort like "00%"));
   run;

   %if (%_nobs (WORK._RPGH_HEADER) < 1) %then %do;
      data work._empty_dataset;
         length tag $20 new_description $3200;
         tag = " ";
         new_description = "&g_nls_reportPgmDoc_024.";
      run;

      proc report data=work._empty_dataset nowd missing 
         style(column)=pgmDocBlindData [just=center]
         style(header)=blindHeader
         style(report)={width=60em 
                        borderspacing =  0px
                        paddingtop    =  3px 
                        paddingleft   = 11px 
                        paddingright  = 11px 
                        paddingbottom =  3px 
                       }
         ;

         column tag new_description;

         define tag             / order noprint;
         define new_description / display;

         compute before tag / style=PgmDocHeader;
            line tag $HeaderText.;
         endcomp;
         compute after tag / style=blindHeader;
            line " ";
         endcomp;
      run;
   %end;
   %else %do;
      proc report data=WORK._RPGH_HEADER nowd missing 
         style(column)=pgmDocBlindData
         style(header)=blindHeader
         style(report)={width=60em 
                        borderspacing =  0px
                        paddingtop    =  3px 
                        paddingleft   = 11px 
                        paddingright  = 11px 
                        paddingbottom =  3px 
                       }
         ;

         column tag_sort tag tag_text new_description;

         define tag_sort        / order noprint;
         define tag             / order noprint;
         define tag_text        / display noprint;
         define new_description / display;

         compute before tag / style=PgmDocHeader;
            line tag $HeaderText.;
         endcomp;
         compute tag_text;
            if (trim(tag_text)="\bug") then do;
               call define (_ROW_, "style", "style=pgmDocBugData");
            end;
            if (trim(tag_text)="\test") then do;
               call define (_ROW_, "style", "style=pgmDocTestData");
            end;
            if (trim(tag_text)="\todo") then do;
               call define (_ROW_, "style", "style=pgmDocToDoData");
            end;
            if (trim(tag_text)="\remark") then do;
               call define (_ROW_, "style", "style=pgmDocRemarkData");
            end;
            if (trim(tag_text)="\deprecated") then do;
               call define (_ROW_, "style", "style=pgmDocDepData");
            end;
         endcomp;
         compute after tag / style=blindHeader;
            line " ";
         endcomp;
      run;
   %end;

   title;

   proc report data=WORK._RPGH (where=(tag_sort like "01%")) nowd missing 
      style(column)=pgmDocBlindData
      style(header)=blindHeader
      style(report)=pgmDocBlindData {width=60em cellspacing=0}
      ;

      column tag_sort tag new_name new_description;

      define tag_sort / order noprint;
      define tag / order noprint format=$HeaderText.;
      define new_name / display style(column)=pgmDocBlindDataStrong;
      define new_description / display;

      compute before tag  / style=PgmDocHeader;
         line tag $HeaderText.;
      endcomp;
   run;
%mend _reportPgmHeader;
/** \endcond */

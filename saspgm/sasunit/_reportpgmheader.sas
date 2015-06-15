/**
   \file
   \todo Header
*/ /** \cond */
%macro _reportPgmHeader (i_lib=, i_data=, i_language=EN);

   data WORK._RPGH;
      set &i_lib..&i_data.;
      new_name=name;
      lag_name=lag(name);
      if (name ne '' AND lag_name eq name) then do;
         new_name='';
      end;
   run;

   proc report data=WORK._RPGH (where=(tag_sort like "00%")) nowd missing 
      style(column)=pgmDocBlindData
      style(header)=blindHeader
      style(report)={width=60em}
      ;

      column tag_sort tag new_description;

      define tag_sort / group noprint;
      define tag / group noprint format=$HeaderText.;
      define new_description / display;

      compute before tag / style=PgmDocHeader;
         line tag $HeaderText.;
      endcomp;
   run;
   title;
   proc report data=WORK._RPGH (where=(tag_sort like "01%")) nowd missing 
      style(column)=pgmDocData
      style(header)=blindHeader
      style(report)={width=60em}
      ;

      column tag_sort tag new_name new_description;

      define tag_sort / group noprint;
      define tag / group noprint format=$HeaderText.;
      define new_name / display style(column)=pgmDocDataStrong;
      define new_description / display;

      compute before tag  / style=PgmDocHeader;
         line tag $HeaderText.;
      endcomp;
   run;
%mend _reportPgmHeader;
/** \endcond */

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
      if (tag="\details") then do;
         tag = "\brief";
      end;
      tag_text=tag;
   run;

   proc report data=WORK._RPGH (where=(tag_sort like "00%")) nowd missing 
      style(column)=pgmDocBlindData
      style(header)=blindHeader
      style(report)={width=60em}
      ;

      column tag_sort tag tag_text new_description;

      define tag_sort / order noprint;
      define tag / order noprint;
      define tag_text / display noprint;* format=$HeaderText.;
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
   run;

   title;

   proc report data=WORK._RPGH (where=(tag_sort like "01%")) nowd missing 
      style(column)=pgmDocData
      style(header)=blindHeader
      style(report)={width=60em}
      ;

      column tag_sort tag new_name new_description;

      define tag_sort / order noprint;
      define tag / order noprint format=$HeaderText.;
      define new_name / display style(column)=pgmDocDataStrong;
      define new_description / display;

      compute before tag  / style=PgmDocHeader;
         line tag $HeaderText.;
      endcomp;
   run;
%mend _reportPgmHeader;
/** \endcond */

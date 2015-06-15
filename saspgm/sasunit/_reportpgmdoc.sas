/**
   \file
   \todo title statment lanuguage specific
   \todo Header
   \test Hugo
   \bug Fritz
*/ /** \cond */
%macro _reportpgmdoc (i_language=
                     ,o_html=
                     ,o_pdf=
                     ,o_path=
                     ,o_pgmdoc_sasunit=
                     );

   %local 
      l_anzMacros 
      i 
      l_Path 
      l_outputPath 
      l_macroName 
      l_pageName
      l_anzToDo
      l_anzTest
      l_anzBug 
      l_anzDep 
   ;

   %if (%sysfunc(exist (WORK._bugdoc))) %then %do;
      proc delete data=WORK._bugdoc;
      run;
   %end;
   %if (%sysfunc(exist (WORK._testdoc))) %then %do;
      proc delete data=WORK._testdoc;
      run;
   %end;
   %if (%sysfunc(exist (WORK._tododoc))) %then %do;
      proc delete data=WORK._tododoc;
      run;
   %end;

   proc format lib=work;
      value $HeaderText
         "\brief"           = "&g_nls_reportPgmDoc_001."
         "\details"         = "&g_nls_reportPgmDoc_001."
         "\author"          = "&g_nls_reportPgmDoc_002."
         "\date"            = "&g_nls_reportPgmDoc_003."
         "\sa"              = "&g_nls_reportPgmDoc_004."
         "\bug"             = "&g_nls_reportPgmDoc_005."
         "\test"            = "&g_nls_reportPgmDoc_006."
         "\todo"            = "&g_nls_reportPgmDoc_007."
         "\version"         = "&g_nls_reportPgmDoc_008."
         "\param"           = "&g_nls_reportPgmDoc_009."
         "\return"          = "&g_nls_reportPgmDoc_010."
         "\retval"          = "&g_nls_reportPgmDoc_011."
         "\remark"          = "&g_nls_reportPgmDoc_012."
         "\copyright"       = "&g_nls_reportPgmDoc_013."
         "_label_todolist_" = "&g_nls_reportPgmDoc_014."
         "_label_testlist_" = "&g_nls_reportPgmDoc_015."
         "_label_buglist_"  = "&g_nls_reportPgmDoc_016."
         "_label_deplist_"  = "&g_nls_reportPgmDoc_020."
         "\deprecated"      = "&g_nls_reportPgmDoc_023."
         ;

      value $TagSort
         "\brief"      = "000"
         "\details"    = "000"
         "\version"    = "001"
         "\author"     = "002"
         "\date"       = "003"
         "\sa"         = "004"
         "\bug"        = "005"
         "\test"       = "006"
         "\todo"       = "007"
         "\remark"     = "008"
         "\deprecated" = "009"
         "\return"     = "00A"
         "\copyright"  = "00B"
         "\param"      = "011"
         "\retval"     = "012"
         ;
   run;

   %*** Get all macros to be documented ***;
   proc sql noprint;
      select count (*) into :l_anzMacros 
         from target.exa
         %if (&o_pgmdoc_sasunit. = 0) %then %do;
            where exa_auton >= 2
         %end;
         ;
   quit;

   %do i=1 %to &l_anzMacros.;
      %local l_macroFileName&i. l_macroName&i.;
   %end;

   proc sql noprint;
      select exa_filename into :l_macroFileName1- 
         from target.exa
         %if (&o_pgmdoc_sasunit. = 0) %then %do;
            where exa_auton >= 2
         %end;
         order by exa_id
         ;

      create table work._macros as 
         select distinct exa_id, exa_pgm, cas_obj
            from target.exa left join target.cas
            on exa_id=cas_exaid
            %if (&o_pgmdoc_sasunit. = 0) %then %do;
               where exa_auton >= 2
            %end;
         ;
      select coalesce (trim (cas_obj), trim(exa_pgm)) into :l_macroName1-    
         from work._macros
         order by exa_id
         ;
   quit;
   %put _local_;

   options nocenter;
   ods listing close;

   %do i=1 %to &l_anzMacros;

      %_scanHeader (MacroName  = &&l_macroName&i.
                   ,FilePath   = &&l_macroFileName&i.
                   ,LiboutDoc  = WORK
                   ,DataOutDoc = _Pgm&i.
                   ,i_language = &i_language.
                   );

      data work._pgmsrc&i.;
         length Text $400 CommentOpen idxCommentOpen idxCommentClose 8;
         retain CommentOpen 0;
         infile "&&l_macroFileName&i.";
         input;
         Text=_INFILE_;
         idxCommentOpen=index (Text, '/** ');
         if (idxCommentOpen > 0) then do;
            CommentOpen=1;
         end;
         if (not CommentOpen) then do;
            Text = tranwrd (Trim(Text), "^{", "°["); 
            Text = tranwrd (Trim(Text), "}", "]"); 
            output;
         end;
         idxCommentClose=index (Text, '*/');
         if (idxCommentClose > 0) then do;
            CommentOpen=0;
         end;
         keep Text;
      run;

      data work._pgmsrc_view / view=work._pgmsrc_view;
         set work._pgmsrc&i.;
         length ObsNum $80;
         ObsNum = put (_N_,z5.);
      run;

      %let l_title=&g_nls_reportPgmDoc_022. | &g_project - &g_nls_reportPgmDoc_021.;
      title j=c "&l_title.";
      title2 j=c "&&g_nls_reportPgmDoc_017. &&l_macroName&i..";

      %let l_pageName = %sysfunc (tranwrd (&&l_macroName&i..,%str(.sas),%str()));
      %if (&o_html.) %then %do;
         ods html4 file="&o_Path./pgm_&l_pageName..html"
                    (TITLE="&l_title.") 
                    headtext='<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.SASUnit stylesheet=(URL="css/SAS_SASUnit.css")
                    encoding="&g_rep_encoding.";
      %end;

      %_reportPgmHeader (i_lib=WORK, i_data=_Pgm&i., i_language=&i_language.);

      title2 j=c "&g_nls_reportPgmDoc_018. &&l_macroName&i..";

      proc print data=work._pgmsrc_view noobs
         style(report)=blindTable [borderwidth=0]
         style(column)=pgmDocSource
         style(header)=blindHeader;

         var ObsNum Text;
      run;
      %if (&o_html.) %then %do;
         %_closeHtmlPage;
      %end;

   %end;

   %if (&o_html.) %then %do;
      ods html4 file="&o_Path./_PgmDoc_Lists.html" style=styles.sasunit stylesheet=(url="css/SAS_SASUnit.css"); 
   %end;

   %let l_anzToDo=%_nobs(_ToDoDoc);
   %let l_anzTest=%_nobs(_TestDoc);
   %let l_anzBug =%_nobs(_BugDoc);
   %let l_anzDep =%_nobs(_DepDoc);

   %if (%eval(&l_anzToDo.+&l_anzTest.+&l_anzBug.+&l_anzDep.)) %then %do;
      title j=c "&g_nls_reportPgmDoc_019.";
      %if (&l_anzToDo.) %then %do;
         %PrintDocList(lib=WORK
                      ,data=_ToDoDoc
                      ,title=%sysfunc (putc (_label_todolist_, $Headertext.))
                      ,style=pgmDocToDoHeader
                      );
      %end;
      %if (&l_anzTest.) %then %do;
         %PrintDocList(lib=WORK
                      ,data=_TestDoc
                      ,title=%sysfunc (putc (_label_testlist_, $Headertext.))
                      ,style=pgmDocTestHeader
                      );
      %end;
      %if (&l_anzBug.) %then %do;
         %PrintDocList(lib=WORK
                      ,data=_BugDoc
                      ,title=%sysfunc (putc (_label_buglist_,  $Headertext.))
                      ,style=pgmDocBugHeader
                      );
      %end;
      %if (&l_anzDep.) %then %do;
         %PrintDocList(lib=WORK
                      ,data=_DepDoc
                      ,title=%sysfunc (putc (_label_deplist_,  $Headertext.))
                      ,style=pgmDocDepHeader
                      );
      %end;
   %end;
   %else %do;
      data test;
         Text="";output;
      run;
      proc print data=test
            style(report)=blindTable [borderwidth=0]
            style(column)=blindHeader
            style(header)=blindHeader;

         var Text;
      run;
   %end;

   %if (&o_html.) %then %do;
      %_closeHtmlPage;
   %end;

   options center;
   ods listing;
%mend;

%macro PrintDocList (lib=, data=, title=, style=);
   proc sort data=&lib..&data.;
      by macroname obs_sort;
   run;

   data work._view / view=work._view;
      set &lib..&data.;
      idx = find (macroname, '.sas', 'it');
      ReportColumns= catt ('^{style [url="pgm_', substr (macroname,1,idx) !! 'html"] ', macroname, '}');
   run;
 
   proc report data=work._view nowd missing
      style(report)={width=60em}
      style(header)=blindHeader
      style(lines)=&style. 
      style(column)=pgmDocData [textalign=left]
      ;

      column ReportColumns obs_sort new_description;

      define ReportColumns / group style(column)=pgmDocDataStrong [width=20em];
      define obs_sort / group noprint;
      define new_description / display;

      compute before;
         line "&title.";
      endcomp;
   run;
   title;
%mend;
/** \endcond */

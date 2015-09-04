/**
   \file

   \brief   Create program documentation

   \details Loops over all examinees. SASUnit macros may be included by specifying o_pdmdoc_sasunit.
            Each examinee is scaned for specific tags. This information is gather in a seperate documentation per examinee

            The following tags will be collect into lists on an additional page:
            - todo
            - bug
            - test
            - remark
            - deprecated

   \version    \$Revision: 315 $
   \author     \$Author: klandwich $
   \date       \$Date: 2014-02-28 10:25:18 +0100 (Fr, 28 Feb 2014) $
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_termscenario.sas $   
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \return program documentation
*/ /** \cond */
%macro _reportpgmdoc (i_language=
                     ,i_repdata=
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
   %if (%sysfunc(exist (WORK._depdoc))) %then %do;
      proc delete data=WORK._depdoc;
      run;
   %end;
   %if (%sysfunc(exist (WORK._grpdoc))) %then %do;
      proc delete data=WORK._grpdoc;
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
         other         = "___"
         ;
   run;

   %*** Get all macros to be documented ***;
   data work.exa;
      set target.exa
         %if (&o_pgmdoc_sasunit. = 0) %then %do;
            where exa_auton >= 2
         %end;
         ;
   run;

   proc sql noprint;
      select count (*) into :l_anzMacros 
         from work.exa;
   quit;

   %do i=1 %to &l_anzMacros.;
      %local l_macroFileName&i. l_macroName&i. l_macroDisplayName&i. l_macroLink;
   %end;

   proc sql noprint;
      select exa_filename into :l_macroFileName1-:l_macroFileName%cmpres(&l_anzMacros.)
         from work.exa
         order by exa_id
         ;
      select catt ("src/", put (exa_auton, z2.), "/", exa_pgm) into :l_macroLink1-:l_macroLink%cmpres(&l_anzMacros.)
         from work.exa
         order by exa_id
         ;
      create table work._macros as 
         select distinct exa_id, exa_pgm, cas_obj, exa_auton
            from work.exa left join target.cas
            on exa_id=cas_exaid
         ;
      select trim(exa_pgm) into :l_macroName1-:l_macroName%cmpres(&l_anzMacros.)
         from work._macros
         order by exa_id
         ;
      select trim (coalesce (cas_obj, exa_pgm)) into :l_macroDisplayName1-:l_macroDisplayName%cmpres(&l_anzMacros.)
         from work._macros
         order by exa_id
         ;
   quit;

   options nocenter;
   ods listing close;

   %do i=1 %to &l_anzMacros;
      %if (%sysfunc (fileexist(&&l_macroFileName&i.))) %then %do;
         %_scanHeader (MacroName        = &&l_macroName&i.
                      ,FilePath         = &&l_macroFileName&i.
                      ,LiboutDoc        = WORK
                      ,DataOutDoc       = _Pgm&i.
                      ,i_language       = &i_language.
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
         title2 j=c "&&g_nls_reportPgmDoc_017. &&l_macroDisplayName&i..";

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

         title2 j=c "&g_nls_reportPgmDoc_018. &&l_macroDisplayName&i..";
         title3 j=c height=10pt link="&&l_macroLink&i." "[&g_nls_reportAuton_027.]";

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
   %end;

   %if (&o_html.) %then %do;
      ods html4 file="&o_Path./_PgmDoc_Lists.html" style=styles.sasunit stylesheet=(url="css/SAS_SASUnit.css"); 
   %end;

   %let l_anzToDo=%_nobs(_ToDoDoc);
   %let l_anzTest=%_nobs(_TestDoc);
   %let l_anzBug =%_nobs(_BugDoc);
   %let l_anzDep =%_nobs(_DepDoc);

   title j=c "&g_nls_reportPgmDoc_019.";
   %if (%eval(&l_anzToDo.+&l_anzTest.+&l_anzBug.+&l_anzDep.)) %then %do;
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
      proc print data=test noobs label
            style(report)=blindTable [borderwidth=0]
            style(column)=blindHeader
            style(header)=blindHeader;

         var Text;
      run;
   %end;

   %if (&o_html.) %then %do;
      %_closeHtmlPage;
   %end;

   %*** eliminate empty groups              ***;
   %*** Loop until no more rows are deleted ***;
   %let l_sqlobs=1;
   %do %until (&l_sqlobs. = 0);
      proc sql noprint;
         create table work._GrpDoc2Delete as 
            select distinct parent 
            from work._GrpDoc;
         delete * from work._GrpDoc where Type="Group" and child not in (select distinct parent from work._GrpDoc2Delete);
      quit;
      %let l_sqlobs=&sqlobs.;
      proc sql noprint;
         drop table work._GrpDoc2Delete;
      quit;
   %end;

   proc sort data=work._GrpDoc;
      by parent child;
   run;

   data work._GrpDoc;
      set work._GrpDoc;
      by parent child;
      if (missing (childText)) then do;
         childText=child;
      end;
      keep parent child childText ChildDesc;
      if last.child;
   run;

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
      style(report)=pgmDocBlindData {width=60em}
      style(header)=blindHeader
      style(lines)=&style. 
      style(column)=pgmDocBlindData [textalign=left]
      ;

      column ReportColumns obs_sort new_description;

      define ReportColumns / group style(column)=pgmDocBlindDataStrong [width=20em];
      define obs_sort / group noprint;
      define new_description / display;

      compute before;
         line "&title.";
      endcomp;
   run;
   title;
%mend;
/** \endcond */

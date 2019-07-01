/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      Processes the output of the MCOVERAGE and MCOVERAGELOC system options 
               available in SAS 9.3 in order to assess test coverage.
               <BR>
               A html representation of a given macro source code file is generated, 
               showing which lines of code were executed during tests.

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param      i_macroName         name of the macro for which test coverage is assessed
   \param      i_macroLocation     path of the folder containing the source code file of the macro  
   \param      i_mCoverageName     name of the SAS dataset with converted coverage analysis text file
   \param      i_mCoverageLibrary  library of the SAS dataset with converted coverage analysis text file
   \param      o_outputFile        name of the resulting html file
   \param      o_outputPath        path of the folder in which the result html file is generated
   \param      o_resVarName        optional name of macroVariable in wich coverage percentage result is written
   \param      o_html              Test report in HTML-format?
   \param      i_style             Name of the SAS style and css file to be used. 

*/ /** \cond */ 

%macro _reportTcgHTML(i_macroName=
                     ,i_macroLocation=
                     ,i_mCoverageName=
                     ,i_mCoverageLibrary=
                     ,o_outputFile=
                     ,o_outputPath=
                     ,o_resVarName=
                     ,o_html=0
                     ,i_style=
                     );

   %local l_MacroName;
   %local l_MCoverageName;
   %local l_linesize;
   %local l_MissingLines;
   %local l_title;

   %let l_MacroName=%lowcase(&i_macroName.);
   %let l_MCoverageName=%lowcase(&i_mCoverageName.);

   /*** Check existence of input files */
   %IF (NOT %SYSFUNC(EXIST(&i_mCoverageLibrary..&l_MCoverageName.)) OR &l_MCoverageName=) %THEN %DO;
     %PUT  ERROR(SASUNIT): Input dataset with converted coverage data does not exist.;
     %GOTO _macExit;
   %END;
   %IF (NOT %SYSFUNC(FILEEXIST(&i_macroLocation./&l_MacroName.)) OR &l_MacroName=) %THEN %DO;
     %PUT  ERROR(SASUNIT): Input file with macro code does not exist.;
     %GOTO _macExit;
   %END;

   /*** Read records from SAS data set and keep only those of given macro ***/
   /*** Keep only one record per combination of record, type first_line and last_line ***/
   proc sort data=&i_mCoverageLibrary..&l_MCoverageName. (where=(upcase (MacName)="%scan(%upcase(&l_MacroName.),1,.)")) out=WORK._MCoverage1 nodupkey;
      by Firstline RecordType LastLine;
   run;

   /*** Get the covered rows of the macro ***/;
   data WORK._MCoverage2;
      set WORK._MCoverage1;

      /*** Keep value of last record the detect changes from one observation to the other ***/
      lag_LastLine = lag (LastLine);
      lag_FirstLine = lag (FirstLine);

      /*** Generate line numbers for covered contributing rows ***/;
      /*** 2 3 5 MacName .         will be converted to:                            ***/
      /*** 2 3 5 MacName 2                                                          ***/
      /*** 2 3 5 MacName 3                                                          ***/
      /*** 2 3 5 MacName 4                                                          ***/
      /*** 2 3 5 MacName 5                                                          ***/
      if (RecordType in (2)) then do;
         do _line_ = FirstLine to LastLine;
            output;
         end;
      end;

      /*** Generate line numbers for non-contributing rows ***/
      /*** 3 3 5 MacName .         will be converted to:                            ***/
      /*** 3 3 5 MacName 2                                                          ***/
      /*** 3 3 5 MacName 3                                                          ***/
      /*** 3 3 5 MacName 4                                                          ***/
      /*** 3 3 5 MacName 5                                                          ***/
      if (RecordType in (3)) then do;
         do nonEx = FirstLine to LastLine;
            output;
         end;
      end;
   run;

   /*** Due to the order of check in above data step, line numbers are not sorted properly ***/
   /*** Sort lines and generate a second data set with non-contributing rows ***/
   proc sort data=WORK._MCoverage2 out=WORK._MCoverage3 NODUPKEY;
      by _line_;
   run;
   proc sort data=WORK._MCoverage2 out=WORK._NonEx NODUPKEY;
      by nonEx;
   run;

   /*** Enumerate lines in source code file , flagging all lines before %macro statement with -1 ***/
   data WORK.rowsOfInputFile;
      length srcrow $300 nCounter 8;  
      retain srcrow " " nCounter -1; 
      infile "&i_macroLocation./&l_MacroName.";
      input;
      srcrow = _INFILE_;
      if (index (compress (upcase (srcrow)), "%nrstr(%MACRO)%scan(%upcase(&l_MacroName.),1,.)(") 
          OR index (compress (upcase (srcrow)), "%nrstr(%MACRO)%scan(%upcase(&l_MacroName.),1,.);") 
         ) then do;
         nCounter = 0;
      end;
      if (nCounter >= 0) then do;
         nCounter=nCounter+1;
      end;
   run;
   
   /*** Read all lines not explicitly marked as covered          ***/
   /*** This can result in selecting no rows! So we need to      ***/
   /*** preassign a value to missinglines. Does zero sound okay? ***/
   %let MissingLines=0;
   %let l_MissingLines = 0;
   proc sql noprint;
      select distinct nCounter into :l_MissingLines separated by ' ' from WORK.rowsOfInputFile 
      where nCounter not in (select distinct _line_ from WORK._MCoverage3 where _line_ not eq .);
   quit;

   /*** If there is an %if-statement with %do and %end an adjustment is made: ***/
   /*** If the %if-expression is evaluated to false then the corresponding    ***/
   /*** %end is not marked as covered... therefore it is marked manually,     ***/
   /*** same procedure for %mend                                              ***/
   
   data WORK.MCoverage /*(keep=srcrow nCounter covered srcRowCopy)*/;
      length srcrow $300 nCounter 8 srcRowCopy $2048 inExecutedBlock 8 inExecutedMBlock 8;
      retain srcrow " " nCounter -1 inExecutedBlock 0 inExecutedMBlock 0;
      label srcrow="Macrostatements"; 
      infile "&i_macroLocation./&l_MacroName.";
      input;
      if (index (upcase (_INFILE_), "%nrstr(%MACRO )%scan(%upcase(&l_MacroName.),1,.)")) then do;
        if not(1 in (&l_MissingLines.)) then do;
           inExecutedMBlock = inExecutedMBlock + 1;
       end;
         nCounter=0;
      end;
      if (nCounter >= 0) then do;
         nCounter=nCounter+1;
      end;
      srcrow = cats ("", _INFILE_, "");
      srcRowCopy = _INFILE_;
      covered = 1;
     
      if (nCounter in (&l_MissingLines.)) then do;
         srcrow = cats ("", _INFILE_, "");
         covered = 0;
         _temp_row = compress (upcase (_INFILE_));
         if (length (_temp_row) > 4) then do;
            if ( (substr (_temp_row,1,5) = '%END;') or (substr (_temp_row,1,5) = '%END ') ) then do;
               srcrow = cats ("", _INFILE_, "");
            if inExecutedBlock gt 0 then do;
                  covered = 1;
            end;
            inExecutedBlock = inExecutedBlock - 1;
            end;
         end;
         if (length (_temp_row) > 4) then do;
            if ( (substr (_temp_row,1,6) = '%MEND;') or (substr (_temp_row,1,5) = '%MEND ') ) then do;
               srcrow = cats ("", _INFILE_, "");
               if inExecutedMBlock gt 0 then do;
                  covered = 1;
            end;
            inExecutedMBlock = inExecutedMBlock - 1;
            end;
         end;
      end;
     else do;
        _temp_row = compress (upcase (_INFILE_));
         if ( (count (_temp_row,'%DO') gt 0) ) then do;
            inExecutedBlock = inExecutedBlock + count (_temp_row,'%DO');
         end;
       if (length (_temp_row) > 4) then do;
            if ( (substr (_temp_row,1,5) = '%END;') or (substr (_temp_row,1,5) = '%END ') ) then do;
               inExecutedBlock = inExecutedBlock - 1;
            end;
         end;
         if (length (_temp_row) > 4) then do;
            if ( (substr (_temp_row,1,6) = '%MEND;') or (substr (_temp_row,1,5) = '%MEND ') ) then do;
               inExecutedMBlock = inExecutedMBlock - 1;
            end;
         end;
     end;
   run;
   
   /*** Scan rows for comment lines ***/
   DATA _commentLines;
     SET Rowsofinputfile(rename=(srcrow=srcline));
     RETAIN inComment oneLineComment endCommentNextLine commentStartsNextLine
            ;

     IF _N_=1 THEN DO;
        inComment  = 0;
        oneLineComment = 0;
        endCommentNextLine = 0;
        commentStartsNextLine = 0;
     END;

     IF oneLineComment = 1 THEN DO;
        inComment  = 0;
        oneLineComment = 0;
     END;
     IF endCommentNextLine = 1 THEN DO;
        inComment  = 0;
        endCommentNextLine =0;
     END;
     IF commentStartsNextLine = 1 THEN DO;
        inComment  = 1;
        commentStartsNextLine =0;
     END;
     

     IF NOT ((index(srcline, '/*') > 0) AND (index(srcline, '*/') > 0))THEN DO;
        IF index(srcline, '*/') > 0 THEN DO;
           endCommentNextLine = 1;
        END;
        ELSE DO;
           IF (index(srcline, '/*') GT 0)  THEN DO;
              IF index(compress(srcline,, 's'),'/*') EQ 1 THEN DO;
                 inComment=1;  
              END;
              commentStartsNextLine=1;
           END;
        END;
     END;
     ELSE DO;
       IF index(compress(srcline,, 's'),'/*') EQ 1 AND index(compress(srcline,, 's'),'*/') EQ length(compress(srcline,, 's'))-1 THEN DO;
         inComment=1;
         oneLineComment=1;
       END;
       ELSE IF count(srcline,'*/') gt count(srcline,'/*') THEN DO;
         endCommentNextLine = 1;
       END;
     END; 
   RUN;

   /*** Update WORK.MCoverage to flag the non contributing rows identified by MCOVERAGE OPTION ***/  
   proc sql noprint;
      update WORK.MCoverage 
         set covered = -2
                where nCounter in (select distinct nonEx from WORK._nonex where nonEx not eq .);
      update WORK.MCoverage 
         set covered = -1
                where nCounter in ((select distinct nCounter from _commentLines where inComment eq 1 or compress(compress(srcline),"0D"x) eq ''));
   quit;

   /*** Get sets of rows of different different types: covered contributing, non-covered contributing and non contributing ***/
   proc sql noprint;
      
      create table rowNumbersCovered as
         select distinct nCounter as row from WORK.MCoverage where covered EQ  1;
      create table rowNumbersNonCovered  as
         select distinct nCounter as row from WORK.MCoverage where covered EQ  0;
      create table rowNumbersNonCbuting as
         select distinct nCounter as row from WORK.MCoverage where covered LE -1;

      select count(*) into:ContributingLocCovered from rowNumbersCovered;
      select count(*) into:ContributingLocNonCovered from rowNumbersNonCovered;
   quit;

   /*** Calculate the percentage of covered contributing rows ***/
   %let Coverage = %sysevalf (&ContributingLocCovered. / (&ContributingLocCovered. + &ContributingLocNonCovered.));
   %let CoveragePCT = %sysfunc (putn (&Coverage., nlpct));

   %if "&o_resVarName." NE "" %then %do;
      %let &o_resVarName. = %sysevalf(%sysfunc (round(&Coverage.,0.01))*100);
   %end;

   data work._tcg_legend;
      length dummy $3 Text $140;
      dummy="   ";Text="^{unicode 25CF} ^{style tcgCoveredData &g_nls_reportAuton_018.}";output;
      dummy="   ";Text="^{unicode 25CF} ^{style tcgNonCoveredData &g_nls_reportAuton_019.}";output;
      dummy="   ";Text="^{unicode 25CF} ^{style tcgCommentData &g_nls_reportAuton_020.}";output;
      dummy="   ";Text="^{unicode 25CF} ^{style tcgNonContribData &g_nls_reportAuton_021.}";output;
   run;

   data work._tcg_report;
      LENGTH outputRow pgmSourceColumn $2048 RowNumberOut $200;
      SET WORK.MCoverage;
      RowNumber = _N_;
      outputRow = trim(srcRowCopy);
      outputRow = tranwrd (outputRow,'^{','°[');
      outputRow = tranwrd (outputRow,'}',']');
      %_render_dataColumn (i_sourceColumn=RowNumber
                          ,i_format=Z5.
                          ,i_columnType=tcgCommentData 
                          ,o_targetColumn=RowNumberOut
                          );
      IF covered   = -1 THEN DO;
         %_render_dataColumn (i_sourceColumn=outputRow
                             ,i_columnType=tcgCommentData 
                             ,o_targetColumn=pgmSourceColumn
                             );
      END;
      ELSE IF covered   = 1 THEN DO;
         %_render_dataColumn (i_sourceColumn=outputRow
                             ,i_columnType=tcgCoveredData 
                             ,o_targetColumn=pgmSourceColumn
                             );
      END;
      ELSE IF covered   = 0 THEN DO;
         %_render_dataColumn (i_sourceColumn=outputRow
                             ,i_columnType=tcgNonCoveredData 
                             ,o_targetColumn=pgmSourceColumn
                             );
      END;
      ELSE DO; 
         %_render_dataColumn (i_sourceColumn=outputRow
                             ,i_columnType=tcgNonContribData 
                             ,o_targetColumn=pgmSourceColumn
                             );
      END;
   RUN;

   options nocenter;
   title;footnote;

   %let l_title=&g_nls_reportAuton_017. &i_macroName. | &g_project - &g_nls_reportAuton_002.;
   title  j=c "&l_title.";
   title2 "&g_nls_reportAuton_016.: &CoveragePCT.";

   %if (&o_html.) %then %do;
      ods html4 file="&o_outputPath./&o_outputFile..html" 
                    (TITLE="&l_title.") 
                    headtext='<link rel="shortcut icon" href="./favicon.ico" type="image/x-icon" />'
                    metatext="http-equiv=""Content-Style-Type"" content=""text/css"" /><meta http-equiv=""Content-Language"" content=""&i_language."" /"
                    style=styles.&i_style. stylesheet=(URL="css/&i_style..css")
                    encoding="&g_rep_encoding.";
   %end;

   proc report data=work._tcg_legend nowd
      style(report)=blindTable [borderwidth=0]
      style(column)=blindData
      style(lines) =blindData
      style(header)=blindHeader;

      columns dummy Text;

      compute before _page_;
         line @1 "Color Legend:";
      endcomp;
   run;

   title;
   %_reportFooter(o_html=&o_html.);

   *** Render separation line between legend and source code ***;
   %if (&o_html.) %then %do;
      ods html4 text="^{RAW <hr size=""1"">}";
   %end;

   proc print data=work._tcg_report noobs
      style(report)=blindTable [borderwidth=0]
      style(column)=blindFixedFontData
      style(header)=blindHeader;

      var RowNumberOut pgmSourceColumn;
   run;

   %if (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
   %end;

   options center;
   title;footnote;
   %_macExit:
%mend _reportTcgHTML;
/** \endcond */

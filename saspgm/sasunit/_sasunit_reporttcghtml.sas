/** \file
   \ingroup SASUNIT_REPORT

   \brief   Processes the otput of the MCOVERAGE and MCOVERAGELOC system options 
            available in SAS 9.3 in order to assess test coverage.
            <BR>
            A html representation of a given macro source code file is generated, 
            showing which lines of code were executed during tests.

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$

   \param      i_macroName     name of the macro for which test coverage is assessed
   \param      i_macroLocation path of the folder containing the source code file of the macro  
   \param      i_mCoverageName name of the coverage analysis text file
   \param      i_mCoverageLocation path of the folder containing the coverage analysis text file generated with the mcoverage option
   \param      o_outputFile name of the resulting html file
   \param      o_outputPath path of the folder in which the result html file is generated
   \param      o_resVarName optional name of macroVariable in wich coverage percentage result is written

*/ /** \cond */ 
%macro _sasunit_reporttcghtml(
                          i_macroName=
                         ,i_macroLocation=
                         ,i_mCoverageName=
                         ,i_mCoverageLocation=
						 ,o_outputFile=
                         ,o_outputPath=
						 ,o_resVarName=
                         );

   %local l_MacroName;
   %local l_MCoverageName;
   %local l_linesize;

   %let l_MacroName=%lowcase(&i_macroName.);
   %let l_MCoverageName=%lowcase(&i_mCoverageName.);

   /*** Check existence of input files */
   %IF (NOT %SYSFUNC(FILEEXIST(&i_mCoverageLocation./&l_MCoverageName.)) OR &l_MCoverageName=) %THEN %DO;
	  %PUT  ERROR: Input file with coverage data does not exist.;
	  %GOTO _macExit;
   %END;
   %IF (NOT %SYSFUNC(FILEEXIST(&i_macroLocation./&l_MacroName.)) OR &l_MacroName=) %THEN %DO;
	  %PUT  ERROR: Input file with macro code does not exist.;
	  %GOTO _macExit;
   %END;

   /*** Read records from flat file and keep only those of given macro ***/
   data WORK._MCoverage1 (where=(upcase (MacName)="%scan(%upcase(&l_MacroName.),1,.)"));
      length MacName $40;
      infile "&i_mCoverageLocation./&l_MCoverageName.";
      input;
      RecordType = input (scan (_INFILE_, 1, ' '), ??8.);
      FirstLine  = input (scan (_INFILE_, 2, ' '), ??8.);
      LastLine   = input (scan (_INFILE_, 3, ' '), ??8.);
      MacName    = scan (_INFILE_, 4, ' ');
   run;

   /*** Keep only one record per combination of record type first_line and last_line ***/
   proc sort data=WORK._MCoverage1 out=WORK._MCoverage3 nodupkey;
      by Firstline RecordType LastLine;
   run;

   /*** Get the covered rows of the macro ***/;
   data WORK._MCoverage4;
      set WORK._MCoverage3;

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
   proc sort data=WORK._MCoverage4 out=WORK._MCoverage5 NODUPKEY;
      by _line_;
   run;
   proc sort data=WORK._MCoverage4 out=WORK._NonEx NODUPKEY;
      by nonEx;
   run;

   /*** Enumerate lines in source code file , flagging all lines before %macro statement with -1 ***/
   data WORK.rowsOfInputFile;
      length srcrow $300 nCounter 8;  
      retain srcrow " " nCounter -1; 
      infile "&i_macroLocation./&l_MacroName.";
      input;
      srcrow = _INFILE_;
      if (index (upcase (srcrow), "%nrstr(%MACRO )%scan(%upcase(&l_MacroName.),1,.)")) then do;
         nCounter=0;
      end;
      if (nCounter >= 0) then do;
         nCounter=nCounter+1;
      end;
   run;
   
   /*** Read all lines not explicitly marked as covered ***/
   proc sql noprint;
      select distinct nCounter into :MissingLines separated by ' ' from WORK.rowsOfInputFile where nCounter not in (select distinct _line_ from WORK._MCoverage5  where _line_ not eq .);
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
	     if not(1 in (&MissingLines.)) then do;
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
	  
      if (nCounter in (&MissingLines.)) then do;
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
      update MCoverage 
         set covered = -2
                where nCounter in (select distinct nonEx from WORK._nonex where nonEx not eq .);
      update MCoverage 
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
   
   /*** Print the result *****************************************************/
   /* Save the value of the LINESIZE system option */
   %LET l_linesize = %sysfunc(getoption(linesize,keyword));
   OPTIONS LINESIZE=MAX;
   TITLE1;

   DATA _null_;
      LENGTH outputRow $2048;
      FILE "&o_outputPath./&o_outputFile." RECFM=P;
      SET MCoverage END=eof;
      outputRow = put(_N_,Z6.)||'  '||srcRowCopy;
      IF _n_=1 THEN DO;
         /*HTML-Header*/
         PUT '<html>';
         PUT '<head>';
         PUT '<meta http-equiv="Content-Language" content="de">';
         PUT '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">';
         PUT '<link href="sasunit.css" rel="stylesheet" type="text/css">';
         PUT "<title>&g_nls_reportAuton_017. &i_macroName.</title>";
         PUT '</head>';
         /*HTML-Body*/
         PUT '<body>';
         PUT '<h1>'"&g_nls_reportAuton_005.: &i_macroName"'</h1>';
         PUT '<h2>'"&g_nls_reportAuton_016.: &CoveragePCT."'</h2>';
         PUT '<h3>Color Legend:</h3>';
         PUT '<ul>';
         PUT '  <li><span style="color:#00BE00">'"&g_nls_reportAuton_018."'</span></li>';
         PUT '  <li><span style="color:#FF8020">'"&g_nls_reportAuton_019."'</span></li>';
         PUT '  <li><span style="color:#828282">'"&g_nls_reportAuton_020."'</span></li>';
         PUT '  <li><span style="color:#8020FF">'"&g_nls_reportAuton_021."'</span></li>';
         PUT '</ul>';
         PUT '<hr /><pre><code>';
      END;

      IF covered   = -1 THEN DO;
         PUT '<span style="color:#828282">' outputRow '</span>';
      END;
      ELSE IF covered   = 1 THEN DO;
         PUT '<span style="color:#00BE00">' outputRow '</span>';
      END;
      ELSE IF covered   = 0 THEN DO;
         PUT '<span style="color:#FF8020">' outputRow '</span>';
      END;
      ELSE DO; 
         PUT '<span style="color:#8020FF">' outputRow '</span>';
      END;
      IF eof=1 THEN DO;
         /*HTML-Close*/
         PUT '</code></pre>';
         PUT '</body>';
         PUT '</html>';
      END;
   RUN;
   /* reset option linesize*/
   OPTIONS &l_linesize.;

   %_macExit:
%mend _sasunit_reporttcghtml;
/** \endcond */

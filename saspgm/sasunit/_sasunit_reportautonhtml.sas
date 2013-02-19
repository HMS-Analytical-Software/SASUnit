/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create a list of units under test for HTML report

   \version \$Revision$
   \author  \$Author$
   \date    \$Date$
   \sa      \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input data set (created in reportSASUnit.sas)
   \param   o_html         output HTML file

*/ /** \cond */ 

/* change history
   14.02.2013 PW/KL  Modified for LINUX
   08.02.2013 PW  implementation of test coverage assessment
   02.01.2013 KL  Added new column "Assertions" and corrected the number in column "Test Cases".
                  program library (none) is now supported under different languages.
   12.08.2008 AM  Mehrsprachigkeit
   29.12.2007 AM  Neuererstellung
*/ 

%MACRO _sasunit_reportAutonHTML (
   i_repdata = 
  ,o_html    =
);

/*-- determine number of scenarios 
     and number of test cases per unit under test ----------------------------*/
%LOCAL d_rep1 d_rep2 l_tcg_res;
%_sasunit_tempFileName(d_rep1)
%_sasunit_tempFileName(d_rep2)


PROC MEANS NOPRINT NWAY DATA=&i_repdata(KEEP=cas_auton pgm_id scn_id cas_res);
   BY cas_auton pgm_id scn_id;
   CLASS cas_res;
   OUTPUT OUT=&d_rep1 (drop=_type_);
RUN;

PROC TRANSPOSE DATA=&d_rep1 OUT=&d_rep1 (DROP=_name_) PREFIX=res;
   BY cas_auton pgm_id scn_id;
   VAR _freq_;
   ID cas_res;
RUN;

PROC MEANS NOPRINT NWAY DATA=&d_rep1(KEEP=cas_auton pgm_id);
   BY cas_auton pgm_id;
   OUTPUT OUT=&d_rep2 (DROP=_type_ RENAME=(_freq_=scn_count));
RUN;

DATA &d_rep1 (COMPRESS=YES);
   MERGE &i_repdata (KEEP=cas_auton pgm_id scn_id cas_pgm tsu_sasautos tsu_sasautos1-tsu_sasautos9) &d_rep1;
   BY cas_auton pgm_id scn_id;
   IF res0=. THEN res0=0;
   IF res1=. THEN res1=0;
   IF res2=. THEN res2=0;
RUN;

DATA &d_rep1 (COMPRESS=YES);
   MERGE &d_rep1 &d_rep2;
   BY cas_auton pgm_id;
RUN;

PROC MEANS NOPRINT NWAY missing DATA=&i_repdata(KEEP=cas_auton pgm_id scn_id cas_id);
   class cas_auton pgm_id scn_id cas_id;
   OUTPUT OUT=&d_rep2;
RUN;

PROC MEANS NOPRINT NWAY missing DATA=&d_rep2(KEEP=cas_auton pgm_id scn_id cas_id);
   class cas_auton pgm_id scn_id;
   OUTPUT OUT=&d_rep2 (drop=_type_ cas_id rename=(_freq_=scn_cas)) N=;
RUN;

DATA &d_rep1 (COMPRESS=YES);
   MERGE &d_rep1 &d_rep2;
   BY cas_auton pgm_id scn_id;
RUN;

%IF &g_testcoverage. EQ 1 %THEN %DO;
    /*-- in the log subdir: append all *.tcg files to one file named 000.tcg
     This is done in order to get one file containing coverage data 
     of all calls to the macros under test -----------------------------------*/

   %let l_rc =%_sasunit_delFile("&g_log/000.tcg");

   FILENAME allfiles "&g_log/*.tcg";
   DATA _null_;
    INFILE allfiles end=done dlm=',';
    FILE "&g_log/000.tcg";
    INPUT row :$256.;
    PUT row;
   RUN;

   /*-- for every unit under test (see ‘target’ database ): 
    call new macro _sasunit_reporttcghtml.sas once in order to get a html 
    file showing test coverage for the given unit under test. For every call, 
    use the 000.tcg file as coverage analysis text file ---------------------*/
   
   PROC SQL NOPRINT;
      SELECT DISTINCT cas_pgm 
      INTO:l_unitUnderTestList SEPARATED BY '*'
      FROM &d_rep1;
   QUIT;
   /* Add col tcg_pct to data set &d_rep1 to store coverage percentage for report generation*/
   DATA &d_rep1 (COMPRESS=YES);
      LENGTH tcg_pct 8;
      SET &d_rep1;
      tcg_pct = .;
   RUN;

   %LET l_listCount=%sysfunc(countw(&l_unitUnderTestList.,'*'));
   %do i = 1 %to &l_listCount;
      %LET l_currentUnit=%lowcase(%scan(&l_unitUnderTestList,&i,*));
      %IF "%sysfunc(compress(&l_currentUnit.))" EQ "" %THEN %DO;
         %LET l_tcg_res = .;
      %END;
      %ELSE %DO;
         /*determine where macro source file is located*/ 
         %let l_currentUnitLocation=;
         %let l_currentUnitFileName=;
         %IF (%SYSFUNC(FILEEXIST(&l_currentUnit.))) %THEN %DO; /*full absolute path given*/
            %_sasunit_getAbsPathComponents(
                    i_absPath         = &l_currentUnit
                  , o_fileName        = l_currentUnitFileName
                  , o_pathWithoutName = l_currentUnitLocation
                  )
         %END; 
         %ELSE %DO; /*relative path given*/
            %IF (%SYSFUNC(FILEEXIST(&g_root./&l_currentUnit.))) %THEN %DO; /*relative path in root dir */
               %_sasunit_getAbsPathComponents(
                    i_absPath         = &g_root./&l_currentUnit.
                  , o_fileName        = l_currentUnitFileName
                  , o_pathWithoutName = l_currentUnitLocation
                  )
            %END;
            %ELSE %DO; /*relative path in one of the sasautos dirs*/
               %IF (%SYSFUNC(FILEEXIST(&g_sasautos./&l_currentUnit.))) %THEN %DO;
                   %_sasunit_getAbsPathComponents(
                    i_absPath         = &g_sasautos./&l_currentUnit.
                  , o_fileName        = l_currentUnitFileName
                  , o_pathWithoutName = l_currentUnitLocation
                  )
               %END;
               %ELSE %DO;
                  %LET j = 1;
                  %DO %UNTIL ("&l_currentUnitLocation." NE "" OR &j. EQ 10);
                     %IF (%SYSFUNC(FILEEXIST(&&g_sasautos&j/&l_currentUnit.))) %THEN %DO;
                        %_sasunit_getAbsPathComponents(
                             i_absPath         = &&g_sasautos&j/&l_currentUnit.
                           , o_fileName        = l_currentUnitFileName
                           , o_pathWithoutName = l_currentUnitLocation
                          )
                     %END;
                     %LET j = %EVAL(&j + 1);
                  %END;
               %END;
            %END;
         %END;
         %let l_tcg_res=.;

         %IF ("&l_currentUnitFileName." NE "" AND "&l_currentUnitLocation." NE "" 
              AND %SYSFUNC(FILEEXIST(&l_currentUnitLocation./&l_currentUnitFileName.)) 
              AND %SYSFUNC(FILEEXIST(&g_log./000.tcg)) ) %THEN %DO;
              %_sasunit_reporttcghtml(
                    i_macroName                = &l_currentUnitFileName.
                   ,i_macroLocation            = &l_currentUnitLocation.
                   ,i_mCoverageName            = 000.tcg
                   ,i_mCoverageLocation        = &g_log
                   ,o_outputFile               = tcg_%SCAN(&l_currentUnitFileName.,1,.).html
                   ,o_outputPath               = &g_target/rep
                   ,o_resVarName               = l_tcg_res
                   );
         %END;
      %END; /*%ELSE %DO;*/
      /*store coverage percentage for report generation*/
      PROC SQL NOPRINT;
        UPDATE &d_rep1
          SET tcg_pct=&l_tcg_res.
         WHERE upcase(cas_pgm) EQ "%upcase(&l_currentUnit.)";
      QUIT;
   %end; /*do i = 1 to &l_listCount*/
   
%END;

DATA _null_;
   SET &d_rep1 END=eof;
   BY cas_auton pgm_id scn_id;

   FILE "&o_html";

   IF _n_=1 THEN DO;
      %_sasunit_reportPageTopHTML(
         i_title   = %str(&g_nls_reportAuton_001 | &g_project - SASUnit &g_nls_reportAuton_002)
        ,i_current = 4
      )
   END;

   LENGTH hlp1 hlp2 hlp3 hlpp $256;
   RETAIN hlp3;

   IF first.cas_auton THEN DO;
      IF _n_>1 THEN DO;
         PUT '<hr size="1">';
      END;
      IF cas_auton NE . THEN hlp3 = 'auton' !! put (cas_auton, z3.);
      ELSE hlp3 = 'auton';
      PUT '<table id="' hlp3 +(-1) '"><tr>';
      PUT "   <td>&g_nls_reportAuton_003</td>";
      IF cas_auton>=0 THEN DO;
         ARRAY sa(0:9) tsu_sasautos tsu_sasautos1-tsu_sasautos9;
         hlp1 = sa(cas_auton);
         IF cas_auton=0 THEN hlp2 = symget('g_sasautos');
         ELSE hlp2 = symget ('g_sasautos' !! compress(put(cas_auton,8.)));
         PUT '   <td><a class="lightlink" title="' "&g_nls_reportAuton_004 " '&#x0D;' hlp2 +(-1) '" href="file://' hlp2 +(-1) '">' hlp1 +(-1) '</a></td>';
      END;
      ELSE DO;
         PUT "   <td>&g_nls_reportAuton_015</td>";
      END;
      PUT '</tr></table>';

      PUT '<table>';
      PUT '<tr>';
      PUT '   <td class="tabheader">' "&g_nls_reportAuton_005" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportAuton_006" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportAuton_007" '</td>';
      PUT '   <td class="tabheader">' "&g_nls_reportAuton_014" '</td>';
      %IF &g_testcoverage. EQ 1 %THEN %DO;
         PUT '   <td class="tabheader">' "&g_nls_reportAuton_016" ' [%]' '</td>';
      %END;
      PUT '   <td class="tabheader">' "&g_nls_reportAuton_008" '</td>';
      PUT '</tr>';
   END;

   IF first.scn_id THEN DO;
      PUT '<tr>';
   END;

   IF first.pgm_id THEN DO;
      IF cas_auton = . THEN DO;
         hlp2 = resolve ('%_sasunit_abspath(&g_root,' !! trim(cas_pgm) !! ')');   
      END;
      ELSE DO;
         IF cas_auton = 0 THEN hlp1 = '&g_sasautos';
         ELSE hlp1 = '&g_sasautos' !! compress (put (cas_auton,8.));
         hlp2 = resolve ('%_sasunit_abspath(' !! trim(hlp1) !! ',' !! trim(cas_pgm) !! ')');
      END;
      PUT '   <td id="' hlp3 +(-1) '_' pgm_id z3. '" rowspan="' scn_count +(-1) '" class="datacolumn"><a class="lightlink" title="' "&g_nls_reportAuton_009 " '&#x0D;' hlp2 +(-1) '" href="' hlp2 +(-1) '">' cas_pgm +(-1) '</a></td>';
   END;

   IF first.scn_id THEN DO;
      PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportAuton_010 " scn_id z3. '" href="cas_overview.html#scn' scn_id z3. '">' scn_id z3. '</a></td>';
      hlp1 = left (put (scn_cas, 8.));
      PUT '   <td class="datacolumn">' hlp1 +(-1) '</td>';
      hlp1 = left (put (sum (res0, res1, res2), 8.));
      PUT '   <td class="datacolumn">' hlp1 +(-1) '</td>';
      %IF &g_testcoverage. EQ 1 %THEN %DO;
         if compress(cas_pgm) ne '' then do;
            if index(cas_pgm,'/') GT 0 then do;
               hlpp =  'tcg_'||compress(trim(left(scan(substr(cas_pgm, findw(cas_pgm, scan(cas_pgm, countw(cas_pgm,'/'),'/'))),1,.) !! ".html")));
            end;
            else do;
               hlpp =  'tcg_'||compress(trim(left(scan(cas_pgm,1,.) !! ".html")));
            end;
         end;
         if tcg_pct eq . then do;
            PUT '   <td class="datacolumn">&nbsp;</td>';
         end;
         else do;
            PUT '   <td class="datacolumn"><a class="lightlink" title="' "&g_nls_reportAuton_017. " cas_pgm +(-1) '" href="' hlpp '">' tcg_pct +(-1) '</a></td>';
         end;
      %END;
      PUT '   <td class="iconcolumn"><img src=' @;
      IF      res1>0 THEN PUT '"error.png"  alt="' "&g_nls_reportAuton_011" '"'        @;
      ELSE IF res2>0 THEN PUT '"manual.png" alt="' "&g_nls_reportAuton_012" '"'        @;
      ELSE IF res0>0 THEN PUT '"ok.png"     alt="OK"'                                      @;
      ELSE                PUT '"?????"      alt="' "&g_nls_reportAuton_013" '"'        @;
      PUT '></img></td>';
      PUT '</tr>';
   END;

   IF last.cas_auton THEN DO;
      PUT '</table>';
   END;

   IF eof THEN DO;
      %_sasunit_reportFooterHTML()
   END;

RUN; 
   
PROC DATASETS NOWARN NOLIST LIB=work;
   DELETE %scan(&d_rep1,2,.) %scan(&d_rep2,2,.);
QUIT;

%MEND _sasunit_reportAutonHTML;
/** \endcond */

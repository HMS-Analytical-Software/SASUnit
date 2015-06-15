/** \file
   \ingroup    SASUNIT_REPORT 

   \brief      create the table of contents on the left side of the HTML report as a tree 

               structure:
               <project>
                Scenarios
                 <each test scenario>
                  <each test case>
                   <each test>
                Units under Test
                 <each autocall path>
                  <each units under test>
                   <each test case>
                    <each test> 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_repdata      input dataset (created in reportSASUnit.sas)
   \param   o_html         test report in HTML format
   \return results will be written to folder &g_target/rep 
*/ /** \cond */ 

%MACRO _reportTreeHTML (i_repdata        = 
                       ,o_html           =0
                       ,o_pgmdoc         =0
                       ,o_pgmdoc_sasunit =0
                       );

%LOCAL l_title;
%LOCAL d_tree d_tree1 d_tree2 d_tree3 d_la i; 

%LET l_title = &g_project | SASUnit;

%_tempFilename(d_tree)
%_tempFilename(d_tree1)
%_tempFilename(d_tree2)
%_tempFilename(d_tree3)
%_tempFilename(d_la)

/*-- generate tree structure 1 for test scenarios ----------------------------*/
DATA &d_tree1 (KEEP=label popup target lvl leaf rc);
   LENGTH label popup target $255 lvl leaf 8;
   SET &i_repdata;
   BY scn_id cas_id tst_id;
    
   tst_type=tranwrd(tst_type,"^_","");
   tst_desc=tranwrd(tst_desc,"^_","");

   IF _n_=1 THEN DO;
      label  = "&g_nls_reportTree_001";
      popup  = "&g_nls_reportTree_002";
      target = "scn_overview.html";
      lvl    = 1;
      leaf   = 0;
      OUTPUT;
   END;

   IF first.scn_id THEN DO;
      label  = scn_path;
      popup  = "&g_nls_reportTree_003 " !! put(scn_id,z3.) !! ': &#x0D;' !! scn_desc;
      target = "cas_overview.html#SCN" !! put(scn_id,z3.) !! "_";
      lvl    = 2;
      leaf   = 0;
      rc     = scn_res;
      OUTPUT;
   END;

   IF first.cas_id THEN DO;
      label  = put(cas_id,z3.);
      popup  = "&g_nls_reportTree_004 " !! put (cas_id,z3.) !! ': &#x0D;' !! cas_desc;
      target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html";
      lvl    = 3;
      leaf   = 0;
      rc     = cas_res;
      OUTPUT;
   END;

   label  = put (tst_id, z3.) !! ' (' !! trim(tst_type) !! ')';
   popup  = "&g_nls_reportTree_005 " !! put (tst_id,z3.) !! ': &#x0D;' !! tst_desc;
   target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html#TST" !! put (tst_id,z3.);
   lvl    = 4;
   leaf   = 1;
   rc     = tst_res;
   OUTPUT;
RUN;

/*-- generate tree structure 2 for units under test --------------------------*/
DATA &d_tree2 (KEEP=label popup target lvl leaf rc);
   LENGTH label popup target $255 lvl leaf  8;
   SET &i_repdata.;
   BY exa_auton exa_id scn_id cas_id tst_id;

   tst_type=tranwrd(tst_type,"^_","");
   tst_desc=tranwrd(tst_desc,"^_","");
   cas_obj =tranwrd(cas_obj,"^_","");

   leaf = 0;
   IF _n_=1 THEN DO;
      label  = "&g_nls_reportTree_006";
      popup  = "&g_nls_reportTree_007";
      target = "auton_overview.html";
      lvl    = 1;
      leaf   = 0;
      OUTPUT;
   END;

   IF first.exa_auton THEN DO;
      SELECT (exa_auton);
         WHEN (0) label = tsu_sasunit;
         WHEN (1) label = tsu_sasunit_os;
%DO i=0 %TO 9;
         WHEN (&i+2) label = tsu_sasautos&i;
%END;
         OTHERWISE label="&g_nls_reportAuton_015";
      END;
      IF exa_auton=0 THEN 
         popup  = "&g_nls_reportTree_009 sasunit:" !! '&#x0D;' !! label;
      ELSE IF exa_auton=1 THEN 
         popup  = "&g_nls_reportTree_009 os_specific sasunit:" !! '&#x0D;' !! label;
      ELSE IF exa_auton=2 THEN 
         popup  = "&g_nls_reportTree_009 sasautos:" !! '&#x0D;' !! label;
      ELSE IF exa_auton>2 THEN 
         popup  = "&g_nls_reportTree_009 sasautos" !! left(put(exa_auton-2,1.)) !! ':&#x0D;' !! label;
      ELSE 
         popup = "&g_nls_reportTree_010";
      target = "auton_overview.html#AUTON";
      IF exa_auton NE . THEN target = trim(target) !! put(exa_auton,z3.);
      target = trim(target) !! '_';
      lvl    = 2;
      leaf   = 0;
      OUTPUT;
   END;

   IF first.exa_id THEN DO;
      label = cas_obj;
      SELECT (exa_auton);
         WHEN (0) popup = trim(tsu_sasunit) !! '/' !! cas_obj;
         WHEN (1) popup = trim(tsu_sasunit_os) !! '/' !! cas_obj;
%DO i=0 %TO 9;
         WHEN (&i+2) popup = trim(tsu_sasautos&i) !! '/' !! cas_obj;
%END;
         OTHERWISE popup=cas_obj;
      END;
      popup = "&g_nls_reportTree_011: " !! '&#x0D;' !! popup;
      target = "auton_overview.html#AUTON";
      IF exa_auton NE . THEN target = trim(target) !! put(exa_auton,z3.);
      target = trim(target) !! '_' !! put(exa_id,z3.) !! "_";
      lvl    = 3;
      leaf   = 0;
      rc     = exa_res;
      OUTPUT;
   END;

   IF first.cas_id THEN DO;
      label  = put(scn_id,z3.) !! "_" !! put(cas_id,z3.);
      popup  = "&g_nls_reportTree_012 " !! put(scn_id,z3.) !! ", &g_nls_reportTree_013 " !! put (cas_id,z3.) !! ': &#x0D;' !! cas_desc;
      target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html";
      lvl    = 4;
      leaf   = 0;
      rc     = cas_res;
      OUTPUT;
   END;

   label  = put (tst_id, z3.) !! ' (' !! trim(tst_type) !! ')';
   popup  = "&g_nls_reportTree_014 " !! put (tst_id,z3.) !! '&#x0D;' !! tst_desc;
   target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html#TST" !! put (tst_id,z3.);
   lvl    = 5;
   leaf   = 1;
   rc     = tst_res;
   OUTPUT;

RUN;

/*-- generate tree structure 3 Part I for profram documentation --------------------------*/
%if (&o_pgmdoc.) %then %do;
   proc sql noprint;
      create table work._repdata2 as 
         select distinct exa.*
                ,tsu.*
                ,tsu_sasautos as tsu_sasautos0
                ,cas.cas_obj
         from target.exa left join target.cas
              on exa.exa_id=cas.cas_exaid
              ,target.tsu;
   quit;

   DATA &d_tree3 (KEEP=label popup target lvl leaf rc);
      LENGTH label popup target $255 lvl leaf  8;
      SET work._repdata2
      %if (&o_pgmdoc_sasunit. ne 1) %then %do;
         (where=(exa_auton >= 2))
      %end;
      ;
      BY exa_auton exa_id;

      leaf = 0;
      IF _n_=1 THEN DO;
         label  = "&g_nls_reportTree_016";
         popup  = "";
         target = "";
         lvl    = 1;
         leaf   = 0;
         OUTPUT;
         label  = "&g_nls_reportTree_017";
         popup  = "";
         target = "";
         lvl    = 2;
         leaf   = 0;
         OUTPUT;
      END;

      IF first.exa_auton THEN DO;
         SELECT (exa_auton);
            WHEN (0) label = tsu_sasunit;
            WHEN (1) label = tsu_sasunit_os;
   %DO i=0 %TO 9;
            WHEN (&i+2) label = tsu_sasautos&i;
   %END;
            OTHERWISE label="&g_nls_reportAuton_015";
         END;
         IF exa_auton=0 THEN 
            popup  = "&g_nls_reportTree_009 sasunit:" !! '&#x0D;' !! label;
         ELSE IF exa_auton=1 THEN 
            popup  = "&g_nls_reportTree_009 os_specific sasunit:" !! '&#x0D;' !! label;
         ELSE IF exa_auton=2 THEN 
            popup  = "&g_nls_reportTree_009 sasautos:" !! '&#x0D;' !! label;
         ELSE IF exa_auton>2 THEN 
            popup  = "&g_nls_reportTree_009 sasautos" !! left(put(exa_auton-2,1.)) !! ':&#x0D;' !! label;
         ELSE 
            popup = "";
         target = "";
         lvl    = 3;
         leaf   = 0;
         OUTPUT;
      END;

      IF first.exa_id THEN DO;   
         if (missing (cas_obj)) then do;
            label = exa_pgm;
         end;
         else do;
            label = cas_obj;
         end;
         SELECT (exa_auton);
            WHEN (0) popup = trim(tsu_sasunit) !! '/' !! cas_obj;
            WHEN (1) popup = trim(tsu_sasunit_os) !! '/' !! cas_obj;
   %DO i=0 %TO 9;
            WHEN (&i+2) popup = trim(tsu_sasautos&i) !! '/' !! cas_obj;
   %END;
            OTHERWISE popup=cas_obj;
         END;
         popup = "&g_nls_reportTree_018: " !! '&#x0D;' !! popup;
         target = catt ("pgm_", tranwrd (trim (exa_pgm), ".sas", ".html"));
         lvl    = 4;
         leaf   = 1;
         rc     = .;
         OUTPUT;
      END;
   RUN;
%end;

/*-- Lookahead für Level -----------------------------------------------------*/
DATA &d_tree. &d_la. (KEEP=lvl RENAME=(lvl=nextlvl));
   SET &d_tree1. &d_tree2. 
   %if (&o_pgmdoc.) %then %do;
      &d_tree3.
   %end;
       END=eof;
   OUTPUT &d_tree;
   IF _n_>1 THEN OUTPUT &d_la;
   IF eof THEN DO; 
      lvl=1;
      OUTPUT &d_la;
   END;
RUN;

DATA &d_tree;
   MERGE &d_tree &d_la;
RUN;

/*-- generate HTML code ---------------------------------------*/
DATA _null_;
   SET &d_tree END=eof;
   FILE "&o_html" LRECL=1024 encoding="&g_rep_encoding.";
   length class_suffix $20;

   IF _n_=1 THEN DO;
      %_reportHeaderHTML(&l_title)
      PUT "<a href=""overview.html"" title=""&g_nls_reportTree_015 &g_project"" target=""basefrm"" class=""hms-treeview"">&g_project.</a>";
      PUT "<ol class=""hms-treeview"">";
   END;

   if (not missing (rc)) then do;
      class_suffix = scan (put (rc, PictNameHTML.), 1, '.');
   end;
   if (leaf) then do;
      PUT "<li>" @;
      PUT "<label class=""file" class_suffix +(-1) """><a href=""" target +(-1) """ title=""" popup +(-1) """ target=""basefrm"">" label +(-1) "</a></label>" @;
      PUT "</li>";
   end;
   else do;
      PUT "<li>";
      PUT "<input type=""checkbox"" id=""folder" _N_ z8. """/><label class=""node" class_suffix +(-1) """ for=""folder" _N_ z8. """><a href=""" target +(-1) """ title=""" popup +(-1) """ target=""basefrm"">" label +(-1) "</a></label>";
   end;
   if (lvl < nextlvl) then do;
      PUT "<ol>";
   end; 
   DO i=nextlvl+1 TO lvl;
      PUT "</ol>"; 
      PUT "</li>";
   END;

   IF eof THEN DO;
      PUT '</ol></body></html>';
   END;
RUN;

PROC DATASETS NOLIST NOWARN LIB=work;
   DELETE 
      %scan(&d_tree,1,.) 
      %scan(&d_tree1,1,.) 
      %scan(&d_tree2,1,.) 
      %if (&o_pgmdoc.) %then %do;
         %scan(&d_tree3,1,.) 
      %end;
      %scan(&d_la,1,.);
QUIT;

%MEND _reportTreeHTML;
/** \endcond */

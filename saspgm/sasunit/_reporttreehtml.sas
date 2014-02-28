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

%MACRO _reportTreeHTML (i_repdata = 
                       ,o_html    =
                       );

%LOCAL l_title;
%LOCAL d_tree d_tree1 d_tree2 d_la i; 

%LET l_title = &g_project | SASUnit;

%_tempFilename(d_tree)
%_tempFilename(d_tree1)
%_tempFilename(d_tree2)
%_tempFilename(d_la)

/*-- generate tree structure 1 for test scenarios ----------------------------*/
DATA &d_tree1 (KEEP=label popup target lvl term lst1-lst5);
   LENGTH label popup target $255 lvl term lst1-lst5 8;
   RETAIN lst1-lst5 0;
   SET &i_repdata;
   BY scn_id cas_id tst_id;
    
    tst_type=tranwrd(tst_type,"^_","");
    tst_desc=tranwrd(tst_desc,"^_","");

   IF _n_=1 THEN DO;
      label  = "&g_nls_reportTree_001";
      popup  = "&g_nls_reportTree_002";
      target = "scn_overview.html";
      lvl    = 1;
      term   = 0;
      lst1   = 0;
      lst2   = 0;
      lst3   = 0;
      lst4   = 0;
      OUTPUT;
   END;

   IF first.scn_id THEN DO;
      label  = scn_path;
      popup  = "&g_nls_reportTree_003 " !! put(scn_id,z3.) !! ': &#x0D;' !! scn_desc;
      target = "cas_overview.html#SCN" !! put(scn_id,z3.) !! "_";
      lvl    = 2;
      term   = 0;
      lst2   = scn_last;
      lst3   = 0;
      lst4   = 0;
      OUTPUT;
   END;

   IF first.cas_id THEN DO;
      label  = put(cas_id,z3.);
      popup  = "&g_nls_reportTree_004 " !! put (cas_id,z3.) !! ': &#x0D;' !! cas_desc;
      target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html";
      lvl    = 3;
      term   = 0;
      lst3   = cas_last;
      lst4   = 0;
      OUTPUT;
   END;

   label  = put (tst_id, z3.) !! ' (' !! trim(tst_type) !! ')';
   popup  = "&g_nls_reportTree_005 " !! put (tst_id,z3.) !! ': &#x0D;' !! tst_desc;
   target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html#TST" !! put (tst_id,z3.);
   lvl    = 4;
   term   = 1;
   lst4   = last.cas_id;
   OUTPUT;

RUN;

/*-- generate tree structure 2 for units under test --------------------------*/
DATA &d_tree2 (KEEP=label popup target lvl term lst1-lst5);
   LENGTH label popup target $255 lvl term lst1-lst5 8;
   RETAIN lst1-lst5 0;
   SET &i_repdata;
   BY cas_auton pgm_id scn_id cas_id tst_id;

    tst_type=tranwrd(tst_type,"^_","");
    tst_desc=tranwrd(tst_desc,"^_","");
    cas_pgm =tranwrd(cas_pgm,"^_","");

   IF _n_=1 THEN DO;
      label  = "&g_nls_reportTree_006";
      popup  = "&g_nls_reportTree_007";
      target = "auton_overview.html";
      lvl    = 1;
      term   = 0;
      lst1   = 1;
      lst2   = 0;
      lst3   = 0;
      lst4   = 0;
      lst5   = 0;
      OUTPUT;
   END;

   IF first.cas_auton THEN DO;
      SELECT (cas_auton);
         WHEN (0) label = tsu_sasunit;
         WHEN (1) label = tsu_sasunit_os;
         WHEN (2) label = tsu_sasautos;
%DO i=1 %TO 9;
         WHEN (&i+2) label = tsu_sasautos&i;
%END;
         OTHERWISE label="&g_nls_reportAuton_015";
      END;
      IF cas_auton=0 THEN 
         popup  = "&g_nls_reportTree_009 sasunit:" !! '&#x0D;' !! label;
      ELSE IF cas_auton=1 THEN 
         popup  = "&g_nls_reportTree_009 os_specific sasunit:" !! '&#x0D;' !! label;
      ELSE IF cas_auton=2 THEN 
         popup  = "&g_nls_reportTree_009 sasautos:" !! '&#x0D;' !! label;
      ELSE IF cas_auton>2 THEN 
         popup  = "&g_nls_reportTree_009 sasautos" !! left(put(cas_auton-2,1.)) !! ':&#x0D;' !! label;
      ELSE 
         popup = "&g_nls_reportTree_010";
      target = "auton_overview.html#AUTON";
      IF cas_auton NE . THEN target = trim(target) !! put(cas_auton,z3.);
      target = trim(target) !! '_';
      lvl    = 2;
      term   = 0;
      lst2   = auton_last;
      lst3   = 0;
      lst4   = 0;
      lst5   = 0;
      OUTPUT;
   END;

   IF first.pgm_id THEN DO;
      label = cas_pgm;
      SELECT (cas_auton);
         WHEN (0) popup = trim(tsu_sasunit) !! '/' !! cas_pgm;
         WHEN (1) popup = trim(tsu_sasunit_os) !! '/' !! cas_pgm;
         WHEN (2) popup = trim(tsu_sasautos) !! '/' !! cas_pgm;
%DO i=1 %TO 9;
         WHEN (&i+2) popup = trim(tsu_sasautos&i) !! '/' !! cas_pgm;
%END;
         OTHERWISE popup=cas_pgm;
      END;
      popup = "&g_nls_reportTree_011: " !! '&#x0D;' !! popup;
      target = "auton_overview.html#AUTON";
      IF cas_auton NE . THEN target = trim(target) !! put(cas_auton,z3.);
      target = trim(target) !! '_' !! put(pgm_id,z3.) !! "_";
      lvl    = 3;
      term   = 0;
      lst3   = pgm_last;
      lst4   = 0;
      lst5   = 0;
      OUTPUT;
   END;

   IF first.cas_id THEN DO;
      label  = put(scn_id,z3.) !! "_" !! put(cas_id,z3.);
      popup  = "&g_nls_reportTree_012 " !! put(scn_id,z3.) !! ", &g_nls_reportTree_013 " !! put (cas_id,z3.) !! ': &#x0D;' !! cas_desc;
      target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html";
      lvl    = 4;
      term   = 0;
      lst4   = pcs_last;
      lst5   = 0;
      OUTPUT;
   END;

   label  = put (tst_id, z3.) !! ' (' !! trim(tst_type) !! ')';
   popup  = "&g_nls_reportTree_014 " !! put (tst_id,z3.) !! '&#x0D;' !! tst_desc;
   target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html#TST" !! put (tst_id,z3.);
   lvl    = 5;
   term   = 1;
   lst5   = last.cas_id;
   OUTPUT;

RUN;

/*-- Lookahead für Level -----------------------------------------------------*/
DATA &d_tree &d_la(KEEP=lvl RENAME=(lvl=nextlvl));
   SET &d_tree1 &d_tree2 END=eof;
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


/*-- generate HTML and javascript code ---------------------------------------*/
DATA _null_;
   SET &d_tree END=eof;
   FILE "&o_html" LRECL=1024;

   IF _n_=1 THEN DO;
      %_reportHeaderHTML(&l_title)
      PUT "    <script type=""text/javascript"">";
      PUT "    <!-- // Hide script from old browsers";
      PUT "    ";
      PUT "    function toggleFolder(id, imageNode) ";
      PUT "    {";
      PUT "      var folder = document.getElementById(id);";
      PUT "      var l = imageNode.src.length;";
      PUT "      if (imageNode.src.substring(l-20,l)==""ftv2folderclosed.png"" || ";
      PUT "          imageNode.src.substring(l-18,l)==""ftv2folderopen.png"")";
      PUT "      {";
      PUT "        imageNode = imageNode.previousSibling;";
      PUT "        l = imageNode.src.length;";
      PUT "      }";
      PUT "      if (folder == null) ";
      PUT "      {";
      PUT "      } ";
      PUT "      else if (folder.style.display == ""block"") ";
      PUT "      {";
      PUT "        if (imageNode != null) ";
      PUT "        {";
      PUT "          imageNode.nextSibling.src = ""ftv2folderclosed.png"";";
      PUT "          if (imageNode.src.substring(l-13,l) == ""ftv2mnode.png"")";
      PUT "          {";
      PUT "            imageNode.src = ""ftv2pnode.png"";";
      PUT "          }";
      PUT "          else if (imageNode.src.substring(l-17,l) == ""ftv2mlastnode.png"")";
      PUT "          {";
      PUT "            imageNode.src = ""ftv2plastnode.png"";";
      PUT "          }";
      PUT "        }";
      PUT "        folder.style.display = ""none"";";
      PUT "      } ";
      PUT "      else ";
      PUT "      {";
      PUT "        if (imageNode != null) ";
      PUT "        {";
      PUT "          imageNode.nextSibling.src = ""ftv2folderopen.png"";";
      PUT "          if (imageNode.src.substring(l-13,l) == ""ftv2pnode.png"")";
      PUT "          {";
      PUT "            imageNode.src = ""ftv2mnode.png"";";
      PUT "          }";
      PUT "          else if (imageNode.src.substring(l-17,l) == ""ftv2plastnode.png"")";
      PUT "          {";
      PUT "            imageNode.src = ""ftv2mlastnode.png"";";
      PUT "          }";
      PUT "        }";
      PUT "        folder.style.display = ""block"";";
      PUT "      }";
      PUT "    }";
      PUT "    ";
      PUT "    // End script hiding -->";
      PUT "    </script>";
      PUT "  </head>";
      PUT "  ";
      PUT "  <body class=""ftvtree"">";
      PUT "    <div class=""directory"">";
      PUT '      <h3><a class="el" href="overview.html" title="' "&g_nls_reportTree_015 &g_project" '" target="basefrm">' "&g_project" '</a></h3>';
      PUT "      <div style=""display: block;"">";
   END;

   ARRAY lst{5} lst1-lst5;
   RETAIN folder 0;
   PUT "<p>" @;
   DO i=1 TO lvl-1;
      IF lst{i} THEN PUT '<img src="ftv2blank.png"        width=16 height=22 />' @;
      ELSE           PUT '<img src="ftv2vertline.png"     width=16 height=22 />' @;
   END;
   IF term THEN DO;
      IF lst{i} THEN PUT '<img src="ftv2lastnode.png"     width=16 height=22 />' @;
      ELSE           PUT '<img src="ftv2node.png"         width=16 height=22 />' @;
                     PUT '<img src="ftv2doc.png"          width=24 height=22 />' @;
   END;
   ELSE DO;
      folder+1;
      IF lst{i} THEN PUT '<img src="ftv2plastnode.png"    width=16 height=22 '
                         'onclick="toggleFolder(''folder' folder +(-1) ''', this)"/>' @;
      ELSE           PUT '<img src="ftv2pnode.png"        width=16 height=22 '
                         'onclick="toggleFolder(''folder' folder +(-1) ''', this)"/>' @;
                     PUT '<img src="ftv2folderclosed.png" width=24 height=22 '
                         'onclick="toggleFolder(''folder' folder +(-1) ''', this)"/>' @;
   END;
   PUT '<a class="el" href="' target +(-1) '" title="' popup +(-1) '" target="basefrm">' label +(-1) '</a></p>';
   IF NOT term AND lvl<nextlvl THEN PUT '<div id="folder' folder +(-1) '">';
   DO i=nextlvl+1 TO lvl;
      PUT "</DIV>"; 
   END;

   IF eof THEN DO;
      PUT '</div></div></body></html>';
   END;

RUN;

PROC DATASETS NOLIST NOWARN LIB=work;
   DELETE %scan(&d_tree,1,.) %scan(&d_tree1,1,.) %scan(&d_tree2,1,.) %scan(&d_la,1,.);
QUIT;

%MEND _reportTreeHTML;
/** \endcond */

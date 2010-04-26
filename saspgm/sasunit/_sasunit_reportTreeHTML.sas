/** \file
   \ingroup    SASUNIT_REPORT 

   \brief      das Inhaltsverzeichnis des HTML-Testberichts erstellen

               Aufbau:
               <project>
                Testszenarien
                 <Szenarien>
                  <Testf�lle>
                   <Tests>
                Pr�flinge
                 <Autocall-Pfade>
                  <Pr�flinge>
                   <Testf�lle>
                    <Tests> 

   \version    \$Revision: 38 $
   \author     \$Author: mangold $
   \date       \$Date: 2008-08-19 16:57:17 +0200 (Di, 19 Aug 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/sasunit/_sasunit_reportTreeHTML.sas $

   \param   i_repdata      Eingabedatei (wird in reportSASUnit.sas erstellt)
   \param   o_html         Testbericht im HTML-Format
   \return Ergebnisse werden im Unterverzeichnis &g_target/rep erstellt
*/ /** \cond */ 

/* �nderungshistorie
   12.08.2008 AM  Reporttexte mehrsprachig
   29.12.2007 AM  Texte verbessert, Teilbaum Pr�flinge fertiggestellt, 
                  tempor�re Dateien aufger�umt 
*/ 

%MACRO _sasunit_reportTreeHTML (
    i_repdata = 
   ,o_html    =
);

%LOCAL l_title;
%LET l_title = &g_project | SASUnit;

%LOCAL d_tree d_tree1 d_tree2 d_la i; 
%_sasunit_tempFilename(d_tree)
%_sasunit_tempFilename(d_tree1)
%_sasunit_tempFilename(d_tree2)
%_sasunit_tempFilename(d_la)

/*-- Aufbereiten nach Szenarien ----------------------------------------------*/
DATA &d_tree1 (KEEP=label popup target lvl term lst1-lst5);
   LENGTH label popup target $255 lvl term lst1-lst5 8;
   RETAIN lst1-lst5 0;
   SET &i_repdata;
   BY scn_id cas_id tst_id;

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
      target = "cas_overview.html#scn" !! put(scn_id,z3.);
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
   target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html#tst" !! put (tst_id,z3.);
   lvl    = 4;
   term   = 1;
   lst4   = last.cas_id;
   OUTPUT;

RUN;

/*-- Aufbereiten nach Programmen ---------------------------------------------*/
DATA &d_tree2 (KEEP=label popup target lvl term lst1-lst5);
   LENGTH label popup target $255 lvl term lst1-lst5 8;
   RETAIN lst1-lst5 0;
   SET &i_repdata;
   BY cas_auton pgm_id scn_id cas_id tst_id;

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
         WHEN (0) label = tsu_sasautos;
%DO i=1 %TO 9;
         WHEN (&i) label = tsu_sasautos&i;
%END;
         OTHERWISE label="(&g_nls_reportTree_008)";
      END;
      IF cas_auton=0 THEN 
         popup  = "&g_nls_reportTree_009 sasautos:" !! '&#x0D;' !! label;
      ELSE IF cas_auton>0 THEN 
         popup  = "&g_nls_reportTree_009 sasautos" !! left(put(cas_auton,1.)) !! ':&#x0D;' !! label;
      ELSE 
         popup = "&g_nls_reportTree_010";
      target = "auton_overview.html#auton";
      IF cas_auton NE . THEN target = trim(target) !! put(cas_auton,z3.);
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
         WHEN (0) popup = trim(tsu_sasautos) !! '/' !! cas_pgm;
%DO i=1 %TO 9;
         WHEN (&i) popup = trim(tsu_sasautos&i) !! '/' !! cas_pgm;
%END;
         OTHERWISE popup=cas_pgm;
      END;
      popup = "&g_nls_reportTree_011: " !! '&#x0D;' !! popup;
      target = "auton_overview.html#auton";
      IF cas_auton NE . THEN target = trim(target) !! put(cas_auton,z3.);
      target = trim(target) !! '_' !! put(pgm_id,z3.);
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
   target = 'cas_' !! put(scn_id,z3.) !! "_" !! put (cas_id,z3.) !! ".html#tst" !! put (tst_id,z3.);
   lvl    = 5;
   term   = 1;
   lst5   = last.cas_id;
   OUTPUT;

RUN;

/*-- Lookahead f�r Level -----------------------------------------------------*/
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


/*-- HTML erzeugen -----------------------------------------------------------*/
DATA _null_;
   SET &d_tree END=eof;
   FILE "&o_html" LRECL=1024;

   IF _n_=1 THEN DO;
      %_sasunit_reportHeaderHTML(&l_title)
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

%MEND _sasunit_reportTreeHTML;
/** \endcond */

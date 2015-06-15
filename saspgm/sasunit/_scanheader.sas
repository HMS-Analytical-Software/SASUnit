/**
   \file
   \brief      
   \ingroup    SASUNIT_REPORT
   \version    
   \version    \$Revision: 163 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-03-19 07:31:32 +0100 (Di, 19 Mrz 2013) $
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_sasunit_reportscnhtml.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
   \todo brief and details


   <B>Ablauf:
   </B>
*/
/** \cond */
%MACRO _scanHeader (MacroName   = 
                   ,FilePath    = 
                   ,LibOutDoc   = WORK
                   ,DataOutDoc  = _ProgramHeader 
                   ,LibOutPgm   = WORK
                   ,DataOutPgm  = _ProgramCode
                   ,LibOutToDo  = WORK
                   ,DataOutToDo = _ToDoDoc
                   ,LibOutTest  = WORK
                   ,DataOutTest = _TestDoc
                   ,LibOutBug   = WORK
                   ,DataOutBug  = _BugDoc
                   ,LibOutDep   = WORK
                   ,DataOutDep  = _DepDoc
                   ,i_language  = EN
                   );

   %LOCAL l_sHeaderStartTag l_sHeaderEndTag;
   %LET l_sHeaderStartTag       = %str(/)%str(** );
   %LET l_sHeaderEndTag         = %str(*)%str(/);

   Data WORK.__programHeader (keep=macroname tag name description);
      Length macroname $80
             tag $20
             name $100
             description $1000
             headerStmtOpen tagStmtOpen emptyLines 8;
      Retain headerStmtOpen tagStmtOpen emptyLines 0 
             tag name;

      *** Compile Perl RegEx with PRXPARSE;
      patternAuthor     = PRXPARSE("/^\\author/");
      patternBrief      = PRXPARSE("/^\\brief/");
      patternCopyright  = PRXPARSE("/^\\copyright/");
      patternDate       = PRXPARSE("/^\\date/");
      patternDetails    = PRXPARSE("/^\\details/");
      patternFile       = PRXPARSE("/^\\file/");
      patternInGroup    = PRXPARSE("/^\\ingroup/");
      patternLink       = PRXPARSE("/^\\link/");
      patternParam      = PRXPARSE("/^\\param/");
      patternReturn     = PRXPARSE("/^\\return/");
      patternRet_Val    = PRXPARSE("/^\\retval/");
      patternSa         = PRXPARSE("/^\\sa/");
      patternTodo       = PRXPARSE("/^\\todo/");
      patternTest       = PRXPARSE("/^\\test/");
      patternBug        = PRXPARSE("/^\\bug/");
      patternRemark     = PRXPARSE("/^\\remark/");
      patternVersion    = PRXPARSE("/^\\version/");
      patternDeprecated = PRXPARSE("/^\\deprecated/");

      pattern           = "/^\\author|\\brief|\\copyright|\\date|\\details|\\file|\\ingroup|\\link|\\param|\\return|\\retval|\\sa|\\todo|\\test|\\bug|\\version|\\remark|\\deprecated/";
      patternTag        = PRXPARSE(pattern);
      patternComment    = PRXPARSE("/\*\//");
              
      ***Input File;
      Infile "&FilePath.";
      Input;

      *** MacroName for lists (todo, test, bug) ***;
      macroname = "&MacroName.";

      l_zeile     = compbl (left (_INFILE_));

      ***Leerzeile;
      if (compress(l_zeile) = "") then do;
         emptyLines = emptyLines+1;
         if (emptyLines = 2 and tag ne "\brief") then do;
            ***reset variables;
            tag         = "";
            name        = "";
            description = "";
            tagStmtOpen = 0;
         end;
      end;

      ***Stop scanning if sHeaderStartEnd is found;
      If (index(_INFILE_,  "&l_sHeaderEndTag")>0) Then DO;
         HeaderStmtOpen = 0;
      End; 

      ***Check for tag with more than one line;
      If((tagStmtOpen = 1 AND PRXMATCH(patternTag, l_zeile) = 1) OR PRXMATCH(patternComment, l_zeile) = 1) Then Do;
         tagStmtOpen = 0;
         if (PRXMATCH(patternComment, l_zeile) = 1) then do;
            ***reset variables;
            tag         = "";
            name        = "";
            description = "";
            emptyLines  = 0;
         end;
      End;

      ***Start Scanning if sHeaderStartTag is found;
      If (index(l_zeile, "&l_sHeaderStartTag")>0) Then Do;
         headerStmtOpen = 1;
         tagPos = Index(l_zeile, "&l_sHeaderStartTag");
         l_zeile = Strip(substr(l_zeile, tagPos + length("&l_sHeaderStartTag")));
      End;

      If (headerStmtOpen = 1) Then Do;
         ***Only Tag on single line: \file;
         If (PRXMATCH(patternFile, l_zeile) = 1) Then Do;
            ***reset variables;
            tag         = "";
            name        = "";
            description = "";
            blankPos    = Index(l_zeile, ' ');   
            tag         = Substr(l_zeile, 1, blankPos);
            name        = "";
            description = "";
         End;
         ***Complex tags with more than one line, 2 columns;
         Else If (PRXMATCH(patternBrief, l_zeile)      = 1 OR
                  PRXMATCH(patternCopyright, l_zeile)  = 1 OR
                  PRXMATCH(patternDetails, l_zeile)    = 1 OR
                  PRXMATCH(patternSa, l_zeile)         = 1 OR
                  PRXMATCH(patternTodo, l_zeile)       = 1 OR
                  PRXMATCH(patternTest, l_zeile)       = 1 OR
                  PRXMATCH(patternBug, l_zeile)        = 1 OR
                  PRXMATCH(patternReturn, l_zeile)     = 1 OR
                  PRXMATCH(patternRemark, l_zeile)     = 1 OR
                  PRXMATCH(patternVersion, l_zeile)    = 1 OR
                  PRXMATCH(patternInGroup, l_zeile)    = 1 OR 
                  PRXMATCH(patternAuthor, l_zeile)     = 1 OR
                  PRXMATCH(patternDate, l_zeile)       = 1 OR
                  PRXMATCH(patternDeprecated, l_zeile) = 1) Then Do;
            ***reset variables;
            tag         = "";
            name        = "";
            description = "";
            tagStmtOpen = 1;
            blankPos = Index(l_zeile, ' ');   
            tag = Substr(l_zeile, 1, blankPos);
            l_zeile = Substr(l_zeile, blankPos+1);
            description = Strip(l_zeile);
         End;
         ***Complex tags with name and more than one line, 3 columns;
         Else If (PRXMATCH(patternParam,   l_zeile)   = 1 OR
                  PRXMATCH(patternRet_val, l_zeile)   = 1
                 )  Then Do;
            ***reset variables;
            tag         = "";
            name        = "";
            description = "";
            tagStmtOpen = 1;
            blankPos = Index(l_zeile, ' ');   
            tag = Substr(l_zeile, 1, blankPos);
            l_zeile = Substr(l_zeile, blankPos+1);
            blankPos = Index(l_zeile, ' ');              
            name = Substr(l_zeile, 1, blankPos);
            l_zeile = Substr(l_zeile, blankPos+1);
            description = Strip(l_zeile);
         End;
         Else If (tagStmtOpen) then do;
            description = Strip(l_zeile);
         End;
      End;
   Run;

   data  WORK.__programHeader;
      length new_description $3200;
      set WORK.__programHeader (where=(not missing(tag)));
      obs_sort = _N_;
      tag_sort = put (tag, $TagSort.);
      tag_text = put (tag, $HeaderText.);
      dummy = "   ";
      new_description = tranwrd (description, "<b>", "^{style [font_weight=bold]");
      new_description = tranwrd (new_description, "</b>", "}");
      new_description = tranwrd (new_description, "<em>", "^{style [font_style=italic]");
      new_description = tranwrd (new_description, "</em>", "}");
      new_description = tranwrd (new_description, "\n", "^n");
      new_description = tranwrd (new_description, "~ ", "- ");
      new_description = tranwrd (new_description, "~", "^_^_^_");
      new_description = tranwrd (new_description, "^{", "°[");
      new_description = tranwrd (new_description, "}", "]");
   run;

   proc sort data=WORK.__programHeader;
      by tag_sort obs_sort;
   run;

   proc append base=&LibOutTodo..&DataOutTodo. data=WORK.__programHeader (where=(tag="\todo"));
   run;

   proc append base=&LibOutTest..&DataOutTest. data=WORK.__programHeader (where=(tag="\test"));
   run;

   proc append base=&LibOutBug..&DataOutBug.   data=WORK.__programHeader (where=(tag="\bug"));
   run;

   proc append base=&LibOutDep..&DataOutDep.   data=WORK.__programHeader (where=(tag="\deprecated"));
   run;

   data &LibOutDoc..&DataOutDoc.;
      set WORK.__programHeader;
      if (tag="\todo") then do;
         new_description ="^{style pgmDocTodoData " !! trim (new_description) !! "}";
      end;
      if (tag="\test") then do;
         new_description ="^{style pgmDocTestData " !! trim (new_description) !! "}";
      end;
      if (tag="\bug") then do;
         new_description ="^{style pgmDocBugData " !! trim (new_description) !! "}";
      end;
      if (tag="\remark") then do;
         new_description ="^{style pgmDocRemarkData " !! trim (new_description) !! "}";
      end;
      if (tag="\deprecated") then do;
         new_description ="^{style pgmDocDepData " !! trim (new_description) !! "}";
      end;
   run;
%MEND _scanHeader;
/** \endcond */

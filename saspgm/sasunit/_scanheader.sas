/**
   \file
   \brief      Scan a flatfile for DoxyGen tags.

   \details    Tags that are reported under "additional information" are kept in seperate datasets

   \ingroup    SASUNIT_REPORT
   \version    
   \version    \$Revision: 163 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-03-19 07:31:32 +0100 (Di, 19 Mrz 2013) $
   \sa         For further information please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>
   \SA         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_sasunit_reportscnhtml.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   MacroName   Name of the macro that resides inside flatfile under FilePath
   \param   FilePath    Path and name of a SASautocall macro
   \param   LibOutDoc   Library of data set holding the header portion of the program documentation (optional: Default=WORK)
   \param   DataOutDoc  Name of data set holding the header portion of the program documentation (optional: Default=_ProgramHeader)
   \param   LibOutPgm   Library of data set holding the source code portion of the program documentation (optional: Default=WORK)
   \param   DataOutPgm  Name of data set holding the source code portion of the program documentation (optional: Default=_ProgramCode)
   \param   LibOutToDo  Library of data set holding the todo portion of the program documentation (optional: Default=WORK)
   \param   DataOutToDo Name of data set holding the todo portion of the program documentation (optional: Default=_ToDODoc)
   \param   LibOutTest  Library of data set holding the test portion of the program documentation (optional: Default=WORK)
   \param   DataOutTest Name of data set holding the test portion of the program documentation (optional: Default=_TestDoc)
   \param   LibOutBug   Library of data set holding the bug portion of the program documentation (optional: Default=WORK)
   \param   DataOutBug  Name of data set holding the bug portion of the program documentation (optional: Default=_BugDoc)
   \param   LibOutDep   Library of data set holding the dep portion of the program documentation (optional: Default=WORK)
   \param   DataOutDep  Name of data set holding the dep portion of the program documentation (optional: Default=_DepDoc)
   \param   LibOutGrp   Library of data set holding the grp portion of the program documentation (optional: Default=WORK)
   \param   DataOutGrp  Name of data set holding the grp portion of the program documentation (optional: Default=_GrpDoc)
   \param   i_language  Lanuage in which the documentation should be created. (optional: Default=EN)
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
                   ,LibOutGrp   = WORK
                   ,DataOutGrp  = _GrpDoc
                   ,i_language  = EN
                   );

   %LOCAL l_sHeaderStartTag l_sHeaderEndTag;
   %LET l_sHeaderStartTag       = %str(/)%str(** );
   %LET l_sHeaderEndTag         = %str(*)%str(/);

   Data WORK.__programHeader (keep=macroname tag name description groupname grouptext);
      Length macroname $80
             tag $20
             name $100
             description $1000
             headerStmtOpen tagStmtOpen emptyLines defGroupOpen 8;
      Retain headerStmtOpen tagStmtOpen emptyLines defGroupOpen 0 
             tag name;

      *** Compile Perl RegEx with PRXPARSE;
      patternAuthor     = PRXPARSE("/^\\author/");
      patternBrief      = PRXPARSE("/^\\brief/");
      patternCopyright  = PRXPARSE("/^\\copyright/");
      patternDate       = PRXPARSE("/^\\date/");
      patternDefGroup   = PRXPARSE("/^\\defgroup/");
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

      pattern           = "/^\\author|\\brief|\\copyright|\\date|\\defgroup|\\details|\\file|\\ingroup|\\link|\\param|\\return|\\retval|\\sa|\\todo|\\test|\\bug|\\version|\\remark|\\deprecated/";
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
         ***Complex sequence of tags around doxygen groups ;
         Else If (PRXMATCH(patternDefGroup,   l_zeile) = 1) Then Do;
            ***reset variables;
            tag          = "";
            name         = "";
            description  = "";
            tagStmtOpen  = 1;
            defGroupOpen = 1;
            blankPos = Index(l_zeile, ' ');   
            tag = Substr(l_zeile, 1, blankPos);
            l_zeile = Substr(l_zeile, blankPos+1);
            description = Strip(l_zeile);
            groupname = scan (description, 1);
            blankPos = Index(description, ' ');   
            grouptext = Substr(description, blankPos+1);
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
            if (defGroupOpen 
                AND not (PRXMATCH(patternBrief, l_zeile) = 1 
                         OR PRXMATCH(patternInGroup, l_zeile) = 1
                         OR PRXMATCH(patternDefGroup, l_zeile) = 1
                        )
               ) then do;
               defGroupOpen = 0;
            end;
            if (defGroupOpen = 1 AND PRXMATCH(patternBrief, l_zeile) = 1) then do;
               tag = "\groupdesc";
            end;
            else do;
               tag = Substr(l_zeile, 1, blankPos);
            end;
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
      dummy    = "   ";
      new_description = tranwrd (description, "^{", "°[");
      new_description = tranwrd (new_description, "}", "]");
      new_description = tranwrd (new_description, "<b>", "^{style [font_weight=bold]");
      new_description = tranwrd (new_description, "</b>", "}");
      new_description = tranwrd (new_description, "<em>", "^{style [font_style=italic]");
      new_description = tranwrd (new_description, "</em>", "}");
      new_description = tranwrd (new_description, "\n", "^n");
      new_description = tranwrd (new_description, "\^n", "\n");
      new_description = tranwrd (new_description, "~ ", "- ");
      new_description = tranwrd (new_description, "~", "^_^_^_");
   run;

   data work._GroupInfo;
      length parent child childtext childdesc $256 Type $8 NewGroup 8;
      set WORK.__programHeader (where=(tag in ("\defgroup", "\ingroup", "\groupdesc") AND not missing (new_description)));
      retain parent child "&macroname" childtext childdesc "" Type "Macro" NewGroup 1;
      if (tag = "\defgroup") then do;
         if (newGroup=1) then do;
            output;
         end;
         child     = groupname;
         childtext = grouptext;
         newGroup  = 1;
         parent    = child;
         Type="Group";
      end;
      if (tag = "\groupdesc") then do;
         childdesc = new_description;
      end;
      if (tag = "\ingroup") then do;
         parent = new_description;
         newGroup = 0;
         output;
         Type = "Macro";
      end;
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

   proc append base=&LibOutGrp..&DataOutGrp.   data=WORK._GroupInfo;
   run;

   data &LibOutDoc..&DataOutDoc.;
      set WORK.__programHeader (where=(tag_sort ne "___")  keep=macroname tag tag_sort name description new_description);
   run;

   proc datasets lib=work nolist;
      delete __programHeader _GrpInfo;
   run;quit;
%MEND _scanHeader;
/** \endcond */

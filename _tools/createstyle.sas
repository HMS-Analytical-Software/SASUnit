/**
   \file
   \ingroup    SASUNIT_UTIL

   \brief     contains style information and writes style sheet

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

*/ /** \cond */
%let g_root=C:\projects\sasunit;
%include "C:\projects\sasunit\saspgm\sasunit\_sasunit_reportcreatestyle.sas";
%_sasunit_reportCreateStyle;
libname target "C:\projects\sasunit\doc\sasunit\en" access=readonly;

ods escapechar="^";

*** Formate für die Namen der Icons ***;
proc format lib=work;
   value PictName 0 = "ok.png"
                  1 = "manual.png"
                  2 = "error.png";
run;

*** Überarbeiten der Scenarios ***;
data scenarios;
   length PictureName_html PictureName_pdf PictureName_rtf c_scnId $200;
   set target.scn;
   ScenarioResult   = scn_res;
   PictureName_html = "^{style [postimage=""" !! trim (put (ScenarioResult, PictName.)) !! """ fontsize=8pt]%nrstr(&nbsp;&nbsp;)}";
   PictureName_pdf  = "^{style [postimage=""C:\Temp\SASUnit_Test\SASUnit_ODS\rep\" !! trim (put (ScenarioResult, PictName.)) !! """]  }";
   PictureName_rtf  = "^S={postimage=""C:\Temp\SASUnit_Test\SASUnit_ODS\rep\" !! trim (put (ScenarioResult, PictName.)) !! """}   ";
   PictureName      = "^{dest [html] " !! PictureName_html !!"}^{dest [pdf rtf] " !! PictureName_pdf !! "}";
   duration         = trim (put (round (scn_end-scn_start, .1), 14.1)) !! " s";
   label scn_id     = "No." scn_desc="Test Scenario" scn_path="Program" scn_start="Last Run" duration="Duration" PictureName="Result" PictureName_html="Result" PictureName_pdf="Result" PictureName_rtf="Result";
   href = "cas_overview.html#scn" !! put (scn_id, z3.);
run;
data work.class;
   set sashelp.class;
run;
title "Test Scenarios | SASUnit - SASUnit Test Documentation";
options orientation=landscape center;

ods listing close;
* reading Stylesheet *;
*ods html(1)    file="C:\TEMP\SASUNIT_HTML.html" /*style=styles.sasunit*/stylesheet=(url="SAS_SASUnit.css");
*ods htmlcss(2) file="C:\TEMP\SASUNIT_HTMLCSS.html" /*style=styles.sasunit*/stylesheet=(url="SAS_SASUnit.css");
*ods html(3)    file="C:\TEMP\SASUNIT_HTML_mit_Styleangabe.html" style=styles.sasunit stylesheet=(url="SAS_SASUnit.css");
*ods htmlcss(4) file="C:\TEMP\SASUNIT_HTMLCSS_mit_Styleangabe.html" style=styles.sasunit stylesheet=(url="SAS_SASUnit.css");
* writing Stylesheet *;
ods html(5)     file="C:\TEMP\SASUNIT.html" style=styles.sasunit stylesheet="C:\projects\sasunit\resources\html\SAS_SASUnit.css"(url="SAS_SASUnit.css");
proc compare base=sashelp.class compare=work.class;
run;quit;
proc report data=scenarios nowd;
   column scn_id scn_desc scn_path scn_start duration PictureName_html;

   define PictureName_html / style(column)={background=white};
   define scn_id / id style(column)=rowheader;

   compute scn_desc;
      call define (_col_, "STYLE", "style=[url=""cas_overview.html#scn" !! put (scn_id.sum, z3.) !! """ flyover=""Details for test scenario " !! put (scn_id.sum, z3.) !! """]");
   endcomp;

run;
proc print data=sashelp.class (obs=3);
run;
proc report data=sashelp.class (obs=3)nowd missing;
   columns name sex age height weight;
   define name /id style(column)=rowheader;
run;
ods _all_ close;
ods listing;
ods path reset;
libname _style clear;

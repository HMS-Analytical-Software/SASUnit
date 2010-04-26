/** \file
   \ingroup    SASUNIT_REPORT

   \brief      HTML-Seiten für assertColumns erstellen

   \version    \$Revision: 41 $
   \author     \$Author: mangold $
   \date       \$Date: 2008-09-08 10:48:23 +0200 (Mo, 08 Sep 2008) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/tags/v00.904/saspgm/sasunit/_sasunit_reportCmpHTML.sas $

   \param   i_scnid        Szenario-Id der Prüfung
   \param   i_casid        Case-Id der Prüfung
   \param   i_tstid        Id der Prüfung
   \param   o_html         Ausgabe in diesen Ordner

*/ /** \cond */ 

%MACRO _sasunit_reportCmpHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
  ,o_html    =
);

/* change history
   13.08.2008 AM  control for output folder, support for multiple languages
   07.07.2008 AM  Berichtsformat und Titel verbessert
   15.12.2007 AM  Wenn Datei _exp oder _act nicht vorhanden, Leerseite erstellen 
*/ 

LIBNAME testout "&g_target/tst";

ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._cmp_act.html" stylesheet=(url="SAS_SASUnit.css");
TITLE "&g_nls_reportCmp_001";
%IF %sysfunc(exist(testout._&i_scnid._&i_casid._&i_tstid._columns_act)) %THEN %DO;
PROC PRINT DATA=testout._&i_scnid._&i_casid._&i_tstid._columns_act;
RUN;
%END;
%ELSE %DO;
DATA _null_;
   FILE PRINT;
   PUT "&g_nls_reportCmp_002";
RUN;
%END;
ODS HTML CLOSE;

ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._cmp_exp.html" stylesheet=(url="SAS_SASUnit.css");
TITLE "&g_nls_reportCmp_003";
%IF %sysfunc(exist(testout._&i_scnid._&i_casid._&i_tstid._columns_exp)) %THEN %DO;
PROC PRINT DATA=testout._&i_scnid._&i_casid._&i_tstid._columns_exp;
RUN;
%END;
%ELSE %DO;
DATA _null_;
   FILE PRINT;
   PUT "&g_nls_reportCmp_004";
RUN;
%END;
ODS HTML CLOSE;

ODS HTML FILE="&o_html/&i_scnid._&i_casid._&i_tstid._cmp_rep.html";
PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._columns_rep;
   REPLAY;
RUN;
ODS HTML CLOSE;
   
LIBNAME testout;

%MEND _sasunit_reportCmpHTML;
/** \endcond */

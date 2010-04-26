/** \file
   \ingroup    SASUNIT_REPORT

   \brief      HTML-Seiten für assertColumns erstellen

   \version    \$Revision: 52 $
   \author     \$Author: mangold $
   \date       \$Date: 2009-07-16 14:42:16 +0200 (Do, 16 Jul 2009) $
   \sa         \$HeadURL: file:///P:/hms/00507_sasunit/svn/branches/v00.903L/saspgm/sasunit/_sasunit_reportcmphtml.sas $

   \param   i_scnid        Szenario-Id der Prüfung
   \param   i_casid        Case-Id der Prüfung
   \param   i_tstid        Id der Prüfung

*/ /** \cond */ 

%MACRO _sasunit_reportCmpHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
);

/* Änderungshistorie
   07.07.2008 AM  Berichtsformat und Titel verbessert
   15.12.2007 AM  Wenn Datei _exp oder _act nicht vorhanden, Leerseite erstellen 
*/ 

LIBNAME testout "&g_target/tst";

ODS HTML FILE="&g_target/rep/&i_scnid._&i_casid._&i_tstid._cmp_act.html" stylesheet=(url="SAS_SASUnit.css");
TITLE "Tatsächlich erstellte SAS-Tabelle";
%IF %sysfunc(exist(testout._&i_scnid._&i_casid._&i_tstid._columns_act)) %THEN %DO;
PROC PRINT DATA=testout._&i_scnid._&i_casid._&i_tstid._columns_act;
RUN;
%END;
%ELSE %DO;
DATA _null_;
   FILE PRINT;
   PUT 'Tatsächlich erzeugte SAS-Tabelle nicht gefunden';
RUN;
%END;
ODS HTML CLOSE;

ODS HTML FILE="&g_target/rep/&i_scnid._&i_casid._&i_tstid._cmp_exp.html" stylesheet=(url="SAS_SASUnit.css");
TITLE "Erwartete SAS-Tabelle";
%IF %sysfunc(exist(testout._&i_scnid._&i_casid._&i_tstid._columns_exp)) %THEN %DO;
PROC PRINT DATA=testout._&i_scnid._&i_casid._&i_tstid._columns_exp;
RUN;
%END;
%ELSE %DO;
DATA _null_;
   FILE PRINT;
   PUT 'Erwartete SAS-Tabelle nicht gefunden';
RUN;
%END;
ODS HTML CLOSE;

ODS HTML FILE="&g_target/rep/&i_scnid._&i_casid._&i_tstid._cmp_rep.html";
TITLE;
PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._columns_rep;
   REPLAY;
RUN;
ODS HTML CLOSE;
   
LIBNAME testout;

%MEND _sasunit_reportCmpHTML;
/** \endcond */

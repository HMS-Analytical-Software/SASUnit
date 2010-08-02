/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML report for assertColumns 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$

   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   o_html         output folder

*/ /** \cond */ 

%MACRO _sasunit_reportCmpHTML (
   i_scnid   =
  ,i_casid   = 
  ,i_tstid   = 
  ,o_html    =
);

/* change history
   22.07.2009 AM  necessary modifications for LINUX
   13.08.2008 AM  control for output folder, support for multiple languages
   07.07.2008 AM  Berichtsformat und Titel verbessert
   15.12.2007 AM  Wenn Datei _exp oder _act nicht vorhanden, Leerseite erstellen 
*/ 

LIBNAME testout "&g_target/tst";

FILENAME cmpods "&o_html/&i_scnid._&i_casid._&i_tstid._cmp_act.html";
ODS HTML FILE=cmpods stylesheet=(url="SAS_SASUnit.css");
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
FILENAME cmpods;

FILENAME cmpods "&o_html/&i_scnid._&i_casid._&i_tstid._cmp_exp.html";
ODS HTML FILE=cmpods stylesheet=(url="SAS_SASUnit.css");
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
FILENAME cmpods;

FILENAME cmpods "&o_html/&i_scnid._&i_casid._&i_tstid._cmp_rep.html";
ODS HTML FILE=cmpods;
PROC DOCUMENT NAME=testout._&i_scnid._&i_casid._&i_tstid._columns_rep;
   REPLAY;
RUN;
ODS HTML CLOSE;
FILENAME cmpods;
   
LIBNAME testout;

%MEND _sasunit_reportCmpHTML;
/** \endcond */

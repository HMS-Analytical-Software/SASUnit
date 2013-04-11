/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML report for assertColumns 

   \todo render results using ODS

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

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

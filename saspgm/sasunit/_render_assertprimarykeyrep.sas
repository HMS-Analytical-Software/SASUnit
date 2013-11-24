/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML pages for assertPrimaryKey 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param   i_assertype    type of assert beeing done. It is know be the program itself, but nevertheless specified as parameter.
   \param   i_repdata      name of reporting dataset containing information on the assert.
   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder

*/ /** \cond */ 

%macro _render_assertPrimaryKeyRep (i_assertype =
                                   ,i_repdata   =
                                   ,i_scnid     =
                                   ,i_casid     =
                                   ,i_tstid     =
                                   ,o_html      =
                                   ,o_path      =
                                   );

  %local l_path dsid cnt rc;

  TITLE;FOOTNOTE;

  %_getTestSubfolder (i_assertType=assertPrimaryKey
                     ,i_root      =&g_target./tst
                     ,i_scnid     =&i_scnid.
                     ,i_casid     =&i_casid.
                     ,i_tstid     =&i_tstid.
                     ,r_path      =l_path
                     );

   LIBNAME _apk "&l_path";

   %IF (&o_html.) %then %do;
      ODS HTML FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._primarykey_rep.html" stylesheet=(url="SAS_SASUnit.css");
   %END;

      TITLE "&g_nls_reportPrimaryKey_001";
      TITLE2 "&g_nls_reportPrimaryKey_002.";
      %IF %sysfunc(exist(_apk._notUnique)) %THEN %DO;
         %LET dsid=%sysfunc(open(_apk._notUnique));
         %LET cnt =%sysfunc(attrn(&dsid,nlobs));
         %LET rc  =%sysfunc(close(&dsid));
         %IF &cnt ne 0 %THEN %DO;
            PROC PRINT DATA=_apk._notUnique;
            RUN;
         %END;
         %ELSE %DO;
            DATA _null_;
               FILE PRINT;
               PUT "&g_nls_reportPrimaryKey_003.";
            RUN;
         %END;
      %END;
      %ELSE %DO;
         DATA _null_;
            FILE PRINT;
            PUT "&g_nls_reportPrimaryKey_023.";
         RUN;
      %END;
      TITLE;
      TITLE2 "&g_nls_reportPrimaryKey_021.";
      %_reportFooter(o_html=&o_html.);
      %IF %sysfunc(exist(_apk._sorted)) %THEN %DO;
         %LET dsid=%sysfunc(open(_apk._sorted));
         %LET cnt =%sysfunc(attrn(&dsid,nlobs));
         %LET rc  =%sysfunc(close(&dsid));

         %IF &cnt ne 0 %THEN %DO;
            PROC PRINT DATA=_apk._sorted;
            RUN;
         %END;
         %ELSE %DO;
            DATA _null_;
               FILE PRINT;
               PUT "&g_nls_reportPrimaryKey_022.";
            RUN;
         %END;       
      %END;    
      %ELSE %DO;
         DATA _null_;
            FILE PRINT;
            PUT "&g_nls_reportPrimaryKey_023.";
         RUN;
      %END;       
   
   %IF (&o_html.) %then %do;
      %_closeHtmlPage;
   %END;

  TITLE; FOOTNOTE;
%MEND _render_assertPrimaryKeyRep;
/** \endcond */

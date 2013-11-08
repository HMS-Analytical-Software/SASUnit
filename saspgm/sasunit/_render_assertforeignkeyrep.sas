/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML pages for assertForeignKey 

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertForeignKeyRep.sas $
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

%macro _render_assertForeignKeyRep (i_assertype =
                                   ,i_repdata   =
                                   ,i_scnid     =
                                   ,i_casid     =
                                   ,i_tstid     =
                                   ,o_html      =
                                   ,o_path      =
                                   );

  %local l_path dsid cnt rc;

  TITLE;FOOTNOTE;

  %_getTestSubfolder (i_assertType=assertForeignKey
                     ,i_root      =&g_target./tst
                     ,i_scnid     =&i_scnid.
                     ,i_casid     =&i_casid.
                     ,i_tstid     =&i_tstid.
                     ,r_path      =l_path
                     );

   LIBNAME _afkLib "&l_path";

   %IF (&o_html.) %then %do;
      ODS HTML FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._foreignkey_rep.html" stylesheet=(url="SAS_SASUnit.css");
   %END;

      TITLE "&g_nls_reportForeignKey_011";
      TITLE2 "&g_nls_reportForeignKey_013.";
      %IF %sysfunc(exist(_afkLib.keyNotFndLookUp)) %THEN %DO;
         %LET dsid=%sysfunc(open(_afkLib.keyNotFndLookUp));
         %LET cnt =%sysfunc(attrn(&dsid,nlobs));
         %LET rc  =%sysfunc(close(&dsid));
         %IF &cnt ne 0 %THEN %DO;
            PROC PRINT DATA=_afkLib.keyNotFndLookUp;
            RUN;
         %END;
         %ELSE %DO;
            DATA _null_;
               FILE PRINT;
               PUT "&g_nls_reportForeignKey_012.";
            RUN;
         %END;
      %END;
      %ELSE %DO;
         DATA _null_;
            FILE PRINT;
            PUT "&g_nls_reportForeignKey_015.";
         RUN;
      %END; 
      TITLE;
      TITLE2 "&g_nls_reportForeignKey_014.";
      %_reportFooter(o_html=&o_html.);
      %IF %sysfunc(exist(_afkLib.keyNotFndMstr)) %THEN %DO;
         %LET dsid=%sysfunc(open(_afkLib.keyNotFndMstr));
         %LET cnt =%sysfunc(attrn(&dsid,nlobs));
         %LET rc  =%sysfunc(close(&dsid));

         %IF &cnt ne 0 %THEN %DO;
            PROC PRINT DATA=_afkLib.keyNotFndMstr;
            RUN;
         %END;
         %ELSE %DO;
            DATA _null_;
               FILE PRINT;
               PUT "&g_nls_reportForeignKey_015.";
            RUN;
         %END;       
      %END;    
      %ELSE %DO;
         DATA _null_;
            FILE PRINT;
            PUT "&g_nls_reportForeignKey_012.";
         RUN;
      %END; 
   
   %IF (&o_html.) %then %do;
      %_closeHtmlPage;
   %END;

  TITLE; FOOTNOTE;
%MEND _render_assertForeignKeyRep;
/** \endcond */

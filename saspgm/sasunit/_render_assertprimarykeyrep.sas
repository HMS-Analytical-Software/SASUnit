/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create HTML pages for assertPrimaryKey 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
            
   \param   i_assertype    type of assert beeing done. It is know be the program itself, but nevertheless specified as parameter.
   \param   i_repdata      name of reporting dataset containing information on the assert.
   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   i_style        Name of the SAS style and css file to be used. 
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder

*/ /** \cond */ 

%macro _render_assertPrimaryKeyRep (i_assertype =
                                   ,i_repdata   =
                                   ,i_scnid     =
                                   ,i_casid     =
                                   ,i_tstid     =
                                   ,i_style     =
                                   ,o_html      =0
                                   ,o_path      =
                                   );

  %local l_path dsid cnt rc;

  TITLE;FOOTNOTE;

  %_getTestSubfolder (i_assertType=assertPrimaryKey
                     ,i_root      =&g_target./doc/tempDoc
                     ,i_scnid     =&i_scnid.
                     ,i_casid     =&i_casid.
                     ,i_tstid     =&i_tstid.
                     ,r_path      =l_path
                     );

   LIBNAME _apk "&l_path";

   %IF (&o_html.) %then %do;
      ODS HTML4 FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._primarykey_rep.html" style=styles.&i_style. stylesheet=(URL="./../css/&i_style..css")
                encoding="&g_rep_encoding.";
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
      %_closeHtmlPage(&i_style.);
   %END;

  TITLE; FOOTNOTE;
%MEND _render_assertPrimaryKeyRep;
/** \endcond */

/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      renders the layout of the actual column for assertRecordCount

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param      i_sourceColumn   name of the column holding the value
   \param      o_html           Test report in HTML-format?
   \param      o_targetColumn   name of the target column holding the ODS formatted value

*/ /** \cond */ 
%macro _render_assertrecordcountrep (i_assertype =
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

  %_getTestSubfolder (i_assertType=&i_assertype.
                     ,i_root      =&g_reportFolder./tempDoc
                     ,i_scnid     =&i_scnid.
                     ,i_casid     =&i_casid.
                     ,i_tstid     =&i_tstid.
                     ,r_path      =l_path
                     );

   LIBNAME _arcLib "&l_path";

   %IF (&o_html.) %then %do;
      ODS HTML4 FILE="&o_path/_&i_scnid._&i_casid._&i_tstid._assertrecordcount_rep.html" style=styles.&i_style. stylesheet=(URL="./../css/&i_style..css")
                encoding="&g_rep_encoding.";
   %END;

   TITLE "&g_nls_reportRecordCount_008";
   TITLE2 "&g_nls_reportRecordCount_006.";
   %IF %sysfunc(exist(_arcLib._arcTable)) %THEN %DO;
      PROC PRINT DATA=_arcLib._arcTable;
      RUN;
   %END;
   
   %IF (&o_html.) %then %do;
      %_closeHtmlPage(&i_style.);
   %END;

   LIBNAME _arcLib clear;
   
   TITLE; FOOTNOTE;
%mend _render_assertrecordcountrep;
/** \endcond */
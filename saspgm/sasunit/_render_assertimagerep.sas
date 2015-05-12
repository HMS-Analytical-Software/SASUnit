/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create reports for assertImage 

   \version    \$Revision: 281 $
   \author     \$Author: klandwich $
   \date       \$Date: 2013-11-08 14:06:01 +0100 (Fr, 08 Nov 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/_render_assertcolumnsrep.sas $
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

%MACRO _render_assertImageRep (i_assertype=
                             ,i_repdata  =
                             ,i_scnid    =
                             ,i_casid    = 
                             ,i_tstid    = 
                             ,o_html     =
                             ,o_path     =
                             );

   %local l_ifile l_ofile l_path ;

   title;footnote;

   %_getTestSubfolder (i_assertType=assertimage
                      ,i_root      =&g_target./tst
                      ,i_scnid     =&i_scnid.
                      ,i_casid     =&i_casid.
                      ,i_tstid     =&i_tstid.
                      ,r_path      =l_path
                      );
   
   %_dir(i_path=&l_path.);
   
   %let l_ifile=&l_path./_image_;
   %let l_ofile=&o_path./_&i_scnid._&i_casid._&i_tstid.;
   
DATA _NULL_;
   SET dir;
   IF SUBSTR(membername,1,11) = "_image_act." THEN DO;
      CALL EXECUTE('%_copyfile('||filename||','||"&l_ofile."||membername||')');
   END;
   ELSE IF SUBSTR(membername,1,11) = "_image_exp." THEN DO;
      CALL EXECUTE('%_copyfile('||filename||','||"&l_ofile."||membername||')');
   END;
   ELSE IF SUBSTR(membername,1,12) = "_image_diff." THEN DO;
      CALL EXECUTE('%_copyfile('||filename||','||"&l_ofile."||membername||')');
   END;
RUN;
   
/*
   %if %sysfunc(fileexist(%nrbquote(&l_ifile.exp.*))) %then %do;
      %_copyFile (%nrbquote(&l_ifile.exp.*), &l_ofile.exp%nrbquote(.txt));
   %end;   
   %if %sysfunc(fileexist(%nrbquote(&l_ifile.act.*))) %then %do;
      %_copyFile (%nrbquote(&l_ifile.act.*), &l_ofile.act%nrbquote(.txt));
   %end;
  %if %sysfunc(fileexist(%nrbquote(&l_ifile.diff.*))) %then %do;
      %_copyFile (%nrbquote(&l_ifile.diff.*), &l_ofile.diff%nrbquote(.txt));
   %end;
  */ 
%MEND _render_assertImageRep;
/** \endcond */

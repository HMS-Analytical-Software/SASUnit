/**
   \file
   \ingroup    SASUNIT_REPORT

   \brief      create reports for assertText 

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

%MACRO _render_assertTextRep (i_assertype=
                             ,i_repdata  =
                             ,i_scnid    =
                             ,i_casid    = 
                             ,i_tstid    = 
                             ,i_style    =
                             ,o_html     =
                             ,o_path     =
                             );

   %local l_ifile l_ofile l_path ;

   title;footnote;

   %_getTestSubfolder (i_assertType=asserttext
                      ,i_root      =&g_target./tst
                      ,i_scnid     =&i_scnid.
                      ,i_casid     =&i_casid.
                      ,i_tstid     =&i_tstid.
                      ,r_path      =l_path
                      );

   %let l_ifile=&l_path./_text_;
   %let l_ofile=&o_path./_&i_scnid._&i_casid._&i_tstid._text_;

   %if %sysfunc(fileexist(%nrbquote(&l_ifile.exp.txt))) %then %do;
      %_copyFile (%nrbquote(&l_ifile.exp.txt), &l_ofile.exp%nrbquote(.txt));
   %end;   
   %if %sysfunc(fileexist(%nrbquote(&l_ifile.act.txt))) %then %do;
      %_copyFile (%nrbquote(&l_ifile.act.txt), &l_ofile.act%nrbquote(.txt));
   %end;
  %if %sysfunc(fileexist(%nrbquote(&l_ifile.diff.txt))) %then %do;
      %_copyFile (%nrbquote(&l_ifile.diff.txt), &l_ofile.diff%nrbquote(.txt));
   %end;
   
%MEND _render_assertTextRep;
/** \endcond */

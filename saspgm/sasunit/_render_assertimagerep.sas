/** \file
   \ingroup    SASUNIT_REPORT

   \brief      create reports for assertImage 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.

   \remark     still uses _dir. This macro is called by reportSASUnit. reportSASUnit will not be called interactively. 
               So there is no need to change anything with this macro concerning NOXCMD

   \param   i_assertype    type of assert beeing done. It is know be the program itself, but nevertheless specified as parameter.
   \param   i_repdata      name of reporting dataset containing information on the assert.
   \param   i_scnid        scenario id of the current test
   \param   i_casid        test case id of the current test
   \param   i_tstid        id of the current test
   \param   i_style        Name of the SAS style and css file to be used. 
   \param   o_html         Test report in HTML-format?
   \param   o_path         output folder

*/ /** \cond */ 

%MACRO _render_assertImageRep (i_assertype=
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

%MEND _render_assertImageRep;
/** \endcond */

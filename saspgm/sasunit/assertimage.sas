/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      This assert does an image compare. 

   \details    As compare tool imageMagick is used. Make shure to use version 6.9 or above since before the
               compare method always returned 0.
               Beginning with ImageMagick 6.9 the following return codes are used:
                  0: images match
                  1: images different

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   
   \sa         For further information please refer to https://sourceforge.net/p/sasunit/wiki/User%27s%20Guide/
               Here you can find the SASUnit documentation, release notes and license information.
   \sa         \$HeadURL$
   \copyright  This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For copyright information and terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme/.
			   
   \param      i_script               Path of shell script
   \param      i_expected             Path of first image file (expected)
   \param      i_actual               Path of second image file (actual)
   \param      i_expected_shell_rc    Expected return value of called script i_script 
                                       0 : image match 
                                       >0: images do not match
   \param      i_modifier             Optional parameter: modifiers for the compare
   \param      i_threshold            Optional parameter: further parameter to be passed to the script. Default is 0. To be uses especially with
                                      modifier -metric ae to specify a number of pixels that may be different
   \param      i_desc                 Optional parameter: description of the assertion to be checked

*/ /** \cond */ 

%MACRO assertImage (i_script             =
                   ,i_expected           =
                   ,i_actual             =
                   ,i_expected_shell_rc  =0
                   ,i_modifier           =-metric RMSE
                   ,i_threshold          =0
                   ,i_desc               =Comparison of images
                   );

   %*** verify correct sequence of calls ***;
   %GLOBAL g_inTestcase;
   %IF &g_inTestcase EQ 1 %THEN %DO;
      %endTestcall;
   %END;
   %ELSE %IF &g_inTestcase NE 2 %THEN %DO;
      %PUT &g_error.(SASUNIT): assert must be called after initTestcase;
      %RETURN;
   %END;

   %LOCAL  l_actual
           l_casid 
           l_cmdFile
           l_errmsg
           l_expected
           l_path
           retVal
           l_result
           l_rc
           l_tstid
           xmin
           xsync
           xwait
           l_image1_extension
           l_image2_extension
   ;

   %LET l_errmsg =;
   %LET l_result = 2;

   %*************************************************************;
   %*** Check preconditions                                   ***;
   %*************************************************************;

   %*** Check if i_script file exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_script.)) %THEN %DO;
      %LET l_rc = -2;
      %LET l_errMsg=Script &i_script. does not exist!;
      %GOTO Update;
   %END;

   %*** Check if i_expected is a path and if so, whether it exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_expected.)) %THEN %DO;
      %LET l_rc = -3;
      %LET l_errMsg=Image &i_expected. does not exist!;
      %GOTO Update;
   %END;
   
   %*** Check if i_actual is a path and if so, whether it exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_actual.)) %THEN %DO;
      %LET l_rc = -4;
      %LET l_errMsg=Image &i_actual. does not exist!;
      %GOTO Update;
   %END;
   
   %*** get current ids for test case and test ***;
   %_getScenarioTestId (i_scnid=&g_scnid, r_casid=l_casid, r_tstid=l_tstid);

   %*** create subfolder ***;
   %_createTestSubfolder (i_assertType   =assertimage
                         ,i_scnid        =&g_scnid.
                         ,i_casid        =&l_casid.
                         ,i_tstid        =&l_tstid.
                         ,r_path         =l_path
                         );

   %*** get image file extension + copy files ***;
   %let l_image1_extension = %sysfunc(substr(&i_expected.,%sysfunc(length(&i_expected.))-%sysfunc(length(%sysfunc(scan(&i_expected.,-1,"."))))));
   %let l_image2_extension = %sysfunc(substr(&i_actual.,%sysfunc(length(&i_actual.))-%sysfunc(length(%sysfunc(scan(&i_actual.,-1,"."))))));

   %_copyFile(&i_expected.                                       /* input file */
             ,&l_path./_image_exp&l_image1_extension.            /* output file */
             )
   %_copyFile(&i_actual.                                         /* input file */
             ,&l_path./_image_act&l_image2_extension.            /* output file */
             );

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;

   %_xcmdWithPath(i_cmd_path ="&i_script." "&i_expected." "&i_actual." "&l_path./_image_diff.png"
                 ,i_cmd      ="&i_modifier." "&i_threshold."
                 ,r_rc       =l_rc
                 );

   %IF &l_rc. = &i_expected_shell_rc. %THEN %DO;
      %LET l_result = 0;
   %END;

%UPDATE:
   %*** update result in test database ***;
   %_ASSERTS(i_type     = assertImage
            ,i_expected = &i_expected_shell_rc.#&l_image1_extension. #&i_expected.
            ,i_actual   = &l_rc.#&l_image2_extension. #&i_actual.
            ,i_desc     = &i_desc.
            ,i_result   = &l_result.
            ,i_errmsg   = &l_errmsg.
            );

%MEND assertImage;
/** \endcond */

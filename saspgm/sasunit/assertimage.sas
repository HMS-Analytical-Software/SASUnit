/**
   \file
   \ingroup    SASUNIT_ASSERT

   \brief      This assert does an image compare. 
               As compare tool imageMagick is used. Make shure to use version 6.9 or above since before the
               compare method always returned 0.
               Beginning with ImageMagick 6.9 the following return codes are used:
                  0: images match
                  1: images different

               Please refer to <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>

   \version    \$Revision: 191 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-06-05 15:23:22 +0200 (Mi, 05 Jun 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/sasunit/assertRecordCount.sas $
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.

   \param     i_script               Path of shell script
   \param     i_image1               Path of first image file (expected)
   \param     i_image2               Path of second image file (actual)
   \param     i_expected             Expected return value of called script i_script 
                                       0: image match 
                                       >0: images do not match
   \param     i_modifier             Optional parameter: modifiers for the compare
   \param     i_threshold            Optional parameter: further parameter to be passed to the script
   \param     i_desc                 Optional parameter: description of the assertion to be checked

*/ /** \cond */ 

   %MACRO assertImage (i_script            =
                      ,i_image1            =
                      ,i_image2            =
                      ,i_expected          =0
                      ,i_modifier          =-metric RMSE
                      ,i_threshold         =1
                      ,i_desc              =Comparison of texts
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
      %LET l_errMsg=Image &i_script. does not exist!;
      %GOTO Update;
   %END;

   %*** Check if i_image1 is a path and if so, whether it exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_image1.)) %THEN %DO;
      %LET l_rc = -3;
      %LET l_errMsg=Image &i_image1. does not exist!;
      %GOTO Update;
   %END;
   
   %*** Check if i_image2 is a path and if so, whether it exists ***;
   %IF NOT %SYSFUNC(FILEEXIST(&i_image2.)) %THEN %DO;
      %LET l_rc = -4;
      %LET l_errMsg=Image &i_image2. does not exist!;
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
   %let l_image1_extension = %sysfunc(substr(&i_image1.,%sysfunc(length(&i_image1.))-%sysfunc(length(%sysfunc(scan(&i_image1.,-1,"."))))));
   %let l_image2_extension = %sysfunc(substr(&i_image2.,%sysfunc(length(&i_image2.))-%sysfunc(length(%sysfunc(scan(&i_image2.,-1,"."))))));

   %_copyFile(&i_image1.                                         /* input file */
             ,&l_path./_image_exp&l_image1_extension.            /* output file */
             )
   %_copyFile(&i_image2.                                         /* input file */
             ,&l_path./_image_act&l_image2_extension.            /* output file */
             );

   %*************************************************************;
   %*** Start tests                                           ***;
   %*************************************************************;
   
   %*** Delete diff if exists ***;
   %IF %SYSFUNC(FILEEXIST(&l_path./_image_diff.png)) %THEN %DO;
      %_delFile(&l_path./_image_diff.png);
   %END;
   
   %IF %lowcase(%sysget(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      %LET xwait=%sysfunc(getoption(xwait));
      %LET xsync=%sysfunc(getoption(xsync));
      %LET xmin =%sysfunc(getoption(xmin));
      OPTIONS noxwait xsync xmin;
   %END;

   %SYSEXEC("&i_script." "&i_image1." "&i_image2." "&i_modifier." "&l_path./_image_diff.png" "&i_threshold.");
   %LET l_rc = &sysrc.;
   %IF %lowcase(%sysget(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      OPTIONS &xwait &xsync &xmin;
   %END;

   %IF &l_rc. = &i_expected. %THEN %DO;
      %LET l_result = 0;
   %END;

%UPDATE:
   %*** update result in test database ***;
   %_ASSERTS(i_type     = assertImage
            ,i_expected = &i_expected.#&l_image1_extension.
            ,i_actual   = &l_rc.#&l_image2_extension.
            ,i_desc     = &i_desc. ^nCompared files:^n&i_image1.^nand^n&i_image2.
            ,i_result   = &l_result.
            ,i_errmsg   = &l_errmsg.
            );

%MEND assertImage;
/** \endcond */

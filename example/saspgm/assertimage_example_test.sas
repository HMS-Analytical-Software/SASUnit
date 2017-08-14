/**
   \file
   \ingroup    SASUNIT_EXAMPLES_TEST 

   \brief      Test examples for assertImage.sas 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _createtestfiles();
   %_copyfile(&g_root/dat/rose.jpg, &g_work./rose.jpg);
   %_copyfile(&g_root/dat/rose.jpg, &g_work./rose_copy.jpg);
   %_copyfile(&g_root/dat/reconstruct.jpg, &g_work./reconstruct.jpg);
   
   options printerpath=png nodate;
   ods printer file="%sysfunc(pathname(work))/class.png";
      proc print data=sashelp.class;
      run;
   ods printer close;

   data class;
      set sashelp.class;
      if name="Barbara" then age=20;
   run;

   options printerpath=png nodate;
   ods printer file="%sysfunc(pathname(work))/class1.png";
      proc print data=class;
      run;
   footnote .j=r "01/07/2015";
   ods printer file="%sysfunc(pathname(work))/class2.png";
      proc print data=sashelp.class;
      run;
   footnote .j=r "02/07/2015";
   ods printer file="%sysfunc(pathname(work))/class3.png";
      proc print data=sashelp.class;
      run;
   footnote;
   ods printer close;

%MEND _createtestfiles;

%MACRO _adaptToOS();
   %GLOBAL 
      assertImage_script
      assertImage_image1
      assertImage_image2
      assertImage_image3
      assertImage_image4
      assertImage_image5
      assertImage_image6
      assertImage_image7
   ;
   /* Prepare macro variables to adapt to OS specific test */
   %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      %LET assertImage_script        =%sysfunc(translate(&g_sasunit_os.\assertImage.cmd,\,/));
      %LET assertImage_image1        =%sysfunc(translate(&g_work.\rose.jpg        ,\ ,/));
      %LET assertImage_image2        =%sysfunc(translate(&g_work.\rose_copy.jpg   ,\ ,/));
      %LET assertImage_image3        =%sysfunc(translate(&g_work.\reconstruct.jpg ,\ ,/));
      %LET assertImage_image4        =%sysfunc(translate(&g_work.\class.png       ,\ ,/));
      %LET assertImage_image5        =%sysfunc(translate(&g_work.\class1.png      ,\ ,/));
      %LET assertImage_image6        =%sysfunc(translate(&g_work.\class2.png       ,\ ,/));
      %LET assertImage_image7        =%sysfunc(translate(&g_work.\class3.png      ,\ ,/));
      
   %END;
   %ELSE %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ linux %THEN %DO;
      %LET assertImage_script        =%_abspath(&g_sasunit_os.,assertImage.sh);
      %LET assertImage_image1        =%_abspath(&g_work.,rose.jpg);
      %LET assertImage_image2        =%_abspath(&g_work.,rose_copy.jpg);
      %LET assertImage_image3        =%_abspath(&g_work.,reconstruct.jpg);
      %LET assertImage_image4        =%_abspath(&g_work.,class.png);
      %LET assertImage_image5        =%_abspath(&g_work.,class1.png);
      %LET assertImage_image6        =%_abspath(&g_work.,class2.png);
      %LET assertImage_image7        =%_abspath(&g_work.,class3.png);
   %END;
%MEND _adaptToOS;

/* create test files */
%_createtestfiles;
%_adaptToOS;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%*** test case 1 ------------------------------------ ***;
%initTestcase(i_object   = assertImage.sas
             ,i_desc     = Tests with matching and non matching images
             )
%endTestcall()

%assertImage(i_script             =&assertImage_script.
            ,i_expected           =&assertImage_image1.  
            ,i_actual             =&assertImage_image2.    
            ,i_expected_shell_rc  =0                   
            ,i_modifier           =-metric ae                  
            ,i_desc               =Images match
            );
            
%assertImage(i_script             =&assertImage_script.
            ,i_expected           =&assertImage_image1.  
            ,i_actual             =&assertImage_image3.    
            ,i_expected_shell_rc  =1                   
            ,i_modifier           =-metric ae                  
            ,i_desc               =Images do not match
            );

%assertImage(i_script             =&assertImage_script.
            ,i_expected           =&assertImage_image1.  
            ,i_actual             =&assertImage_image3.    
            ,i_expected_shell_rc  =0                   
            ,i_modifier           =-metric ae %nrbquote(-fuzz 25%)
            ,i_desc               =%str(Images do not match, but threshold param used with fuzz)
            );
     
%assertImage(i_script             =&assertImage_script.
            ,i_expected           =&assertImage_image4.  
            ,i_actual             =&assertImage_image5.
            ,i_expected_shell_rc  =1                   
            ,i_modifier           =-metric ae                  
            ,i_desc               =%str(Comparence of pngs, images do not match)
            );

%assertImage(i_script             =&assertImage_script.
            ,i_expected           =&assertImage_image6. 
            ,i_actual             =&assertImage_image7.
            ,i_expected_shell_rc  =0
            ,i_threshold          =60
            ,i_modifier           =-metric ae /* -metric ae counts the absolute amount of different pixels */
            ,i_desc               =Graphs do not match%str(,) i_modifier set to "-metric ae" and i_threshold allowing 60 pixels to be different
            );

/** \endcond */

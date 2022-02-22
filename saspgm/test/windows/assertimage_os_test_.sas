/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertImage.sas 

   \version    \$Revision$
   \author     \$Author$
   \date       \$Date$
   \sa         \$HeadURL$
   \copyright  Copyright 2010, 2012 HMS Analytical Software GmbH.
               This file is part of SASUnit, the Unit testing framework for SAS(R) programs.
               For terms of usage under the GPL license see included file readme.txt
               or https://sourceforge.net/p/sasunit/wiki/readme.v1.2/.
*/ /** \cond */ 

%MACRO _createTestfiles();
   %_copyfile(&g_root/dat/rose.jpg, &g_work./rose.jpg);
   %_copyfile(&g_root/dat/rose.jpg, &g_work./rose_copy.jpg);
   %_copyfile(&g_root/dat/reconstruct.jpg, &g_work./reconstruct.jpg);
   
   options printerpath=png nodate;
   ods printer file="%sysfunc(pathname(work))/class.png";
      proc print data=sashelp.class;
      run;
   ods printer close;

   data work.class;
      set sashelp.class;
      if name="Barbara" then age=20;
   run;

   options printerpath=png nodate;
   ods printer file="%sysfunc(pathname(work))/class1.png";
      proc print data=work.class;
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

   proc delete data=work.class;
   run;

%MEND _createTestfiles;

%MACRO _adaptToOS();
   %GLOBAL 
      assertImage_script
      assertImage_NotExistend
      assertImage_CompTool
      assertImage_OS
      assertImage_mod1
      assertImage_mod2
      assertImage_image1
      assertImage_image2
      assertImage_image3
      assertImage_image4
      assertImage_image5
      assertImage_image6
      assertImage_image7
      assertImage_shell_ext
   ;
/* Prepare macro variables to adapt to OS specific test */
%LET assertImage_script        =%sysfunc(translate(&g_sasunit_os.\assertImage.cmd,\,/));
%LET assertImage_NotExistend   =NotExistendFile.cmd;
%LET assertImage_CompTool      =fc;
%LET assertImage_OS            =Windows;
%LET assertImage_mod1          =/C;
%LET assertImage_mod2          =/W;
%LET assertImage_image1        =%sysfunc(translate(&g_work.\rose.jpg        ,\ ,/));
%LET assertImage_image2        =%sysfunc(translate(&g_work.\rose_copy.jpg   ,\ ,/));
%LET assertImage_image3        =%sysfunc(translate(&g_work.\reconstruct.jpg ,\ ,/));
%LET assertImage_image4        =%sysfunc(translate(&g_work.\class.png       ,\ ,/));
%LET assertImage_image5        =%sysfunc(translate(&g_work.\class1.png      ,\ ,/));
%LET assertImage_image6        =%sysfunc(translate(&g_work.\class2.png       ,\ ,/));
%LET assertImage_image7        =%sysfunc(translate(&g_work.\class3.png      ,\ ,/));
%LET assertImage_shell_ext     =.cmd;

%initScenario(i_desc =Test of assertImage.sas);

/* create test files */
%_createTestfiles;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

%*** test case 1 ------------------------------------ ***;
%initTestcase(i_object   = assertImage.sas
             ,i_desc     = Check test setup
             )
%endTestcall()

   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&g_work./rose.jpg))       , i_expected=1, i_desc=File successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&g_work./rose_copy.jpg))  , i_expected=1, i_desc=File successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&g_work./reconstruct.jpg)), i_expected=1, i_desc=File successful modified);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image1.))    , i_expected=1, i_desc=Image rose.jpg  successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image2.))    , i_expected=1, i_desc=Image rose_copy.jpg  successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image3.))    , i_expected=1, i_desc=Image reconstruct.jpg  successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image4.))    , i_expected=1, i_desc=Image class.jpg  successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image5.))    , i_expected=1, i_desc=Image class1.jpg  successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image6.))    , i_expected=1, i_desc=Image class2.jpg  successful copied);
   %assertEquals(i_actual=%SYSFUNC(FILEEXIST(&assertImage_image7.))    , i_expected=1, i_desc=Image class3.jpg  successful copied);

%endTestcase();

%*** test case 2 ------------------------------------ ***;
%initTestcase(i_object   = assertImage.sas
             ,i_desc     = Tests with invalid input parameters
             )
%endTestcall()

%*** No 1-4 ***;
   %assertImage(i_script             =
               ,i_expected           =
               ,i_actual             =
               ,i_expected_shell_rc  =
               ,i_modifier           =
               ,i_threshold          =
               ,i_desc               =Script Parameter is empty
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,## )
      %assertDBValue(tst,act,-2## )
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%*** No 5-8 ***;
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =
               ,i_actual             = 
               ,i_expected_shell_rc  =
               ,i_modifier           =
               ,i_threshold          =
               ,i_desc               =Expected Image Parameter is empty
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,## )
      %assertDBValue(tst,act,-4## )
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%*** No 9-12 ***;
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =&assertImage_image1.
               ,i_actual             =
               ,i_expected_shell_rc  =
               ,i_modifier           =
               ,i_threshold          =
               ,i_desc               =Actual Image Parameter is empty
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,##&assertImage_image1.)
      %assertDBValue(tst,act,-6## )
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%*** No 13-16 ***;
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =&assertImage_image1.
               ,i_actual             =&assertImage_image2.
               ,i_expected_shell_rc  =
               ,i_modifier           =
               ,i_threshold          =
               ,i_desc               =Expected Shell RC Parameter is empty
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,#.jpg#&assertImage_image1.)
      %assertDBValue(tst,act,-8#.jpg#&assertImage_image2.)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%*** No 17-20 ***;
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =&assertImage_image1.
               ,i_actual             =&assertImage_image2.
               ,i_expected_shell_rc  =0
               ,i_modifier           =
               ,i_threshold          =
               ,i_desc               =Modifier Parameter is empty
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,0#.jpg#&assertImage_image1.)
      %assertDBValue(tst,act,0#.jpg#&assertImage_image2.)
      %assertDBValue(tst,res,0)
      %*assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%*** No 21-24 ***;
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =&assertImage_image1.
               ,i_actual             =&assertImage_image2.
               ,i_expected_shell_rc  =0
               ,i_modifier           =-metric RMSE
               ,i_threshold          =
               ,i_desc               =Threshold Parameter is empty
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,0#.jpg#&assertImage_image1.)
      %assertDBValue(tst,act,0#.jpg#&assertImage_image2.)
      %assertDBValue(tst,res,0)


%*** No 25-28 ***;
   %assertImage(i_script             =&assertImage_NotExistend.
               ,i_expected           =&assertImage_image1.
               ,i_actual             =&assertImage_image2.
               ,i_expected_shell_rc  =1
               ,i_modifier           =-metric RMSE
               ,i_threshold          =
               ,i_desc               =Script does not exist
               );                        
           
   %markTest()
      %assertDBValue(tst,exp,1##&assertImage_image1.)
      %assertDBValue(tst,act,-3##&assertImage_image2.)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =&assertImage_NotExistend.  
               ,i_actual             =&assertImage_image2.    
               ,i_expected_shell_rc  =1                   
               ,i_modifier           =-metric RMSE
               ,i_threshold          =
               ,i_desc               =Image1 does not exist
               );
   %markTest()
      %assertDBValue(tst,exp,1#&assertImage_shell_ext.#&assertImage_NotExistend.)
      %assertDBValue(tst,act,-5#.jpg#&assertImage_image2.)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
           
   %assertImage(i_script             =&assertImage_script.
               ,i_expected           =&assertImage_image1.  
               ,i_actual             =&assertImage_NotExistend.    
               ,i_expected_shell_rc  =1                   
               ,i_modifier           =-metric RMSE
               ,i_threshold          =
               ,i_desc               =Image2 does not exist
               );
   %markTest()
      %assertDBValue(tst,exp,1#.jpg#&assertImage_image1.)
      %assertDBValue(tst,act,-7#&assertImage_shell_ext.#&assertImage_NotExistend.)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
           
%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

%*** test case 3 ------------------------------------ ***;
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

%assertLog (i_errors=0, i_warnings=0);
%endTestcase();

%endScenario();
/** \endcond */
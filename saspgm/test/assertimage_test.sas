/**
   \file
   \ingroup    SASUNIT_TEST 

   \brief      Test of assertImage.sas 

   \version    \$Revision: 190 $
   \author     \$Author: b-braun $
   \date       \$Date: 2013-05-29 18:04:27 +0200 (Mi, 29 Mai 2013) $
   \sa         \$HeadURL: https://svn.code.sf.net/p/sasunit/code/trunk/saspgm/test/asserttableexists_test.sas $
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
   ods html close;
   ods printer file="%sysfunc(pathname(work))/class.png";
      proc print data=sashelp.class;
      run;
   ods printer close;
   ods html;

   data class;
      set sashelp.class;
      if name="Barbara" then age=20;
   run;

   options printerpath=png nodate;
   ods html close;
   ods printer file="%sysfunc(pathname(work))/class1.png";
      proc print data=class;
      run;
   ods printer close;
   ods html;
%MEND _createtestfiles;

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
   ;
   /* Prepare macro variables to adapt to OS specific test */
   %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ windows %THEN %DO;
      %LET assertImage_script        =%sysfunc(translate(&g_sasunit_os.\assertImage.cmd,\,/));
      %LET assertImage_NotExistend   = NotExistendFile.cmd;
      %LET assertImage_CompTool      = fc;
      %LET assertImage_OS            =Windows;
      %LET assertImage_mod1          =/C;
      %LET assertImage_mod2          =/W;
      %LET assertImage_image1         =%sysfunc(translate(&g_work.\rose.jpg        ,\ ,/));
      %LET assertImage_image2         =%sysfunc(translate(&g_work.\rose_copy.jpg   ,\ ,/));
      %LET assertImage_image3         =%sysfunc(translate(&g_work.\reconstruct.jpg ,\ ,/));
      %LET assertImage_image4         =%sysfunc(translate(&g_work.\class.png       ,\ ,/));
      %LET assertImage_image5         =%sysfunc(translate(&g_work.\class1.png      ,\ ,/));
   %END;
   %ELSE %IF %LOWCASE(%SYSGET(SASUNIT_HOST_OS)) EQ linux %THEN %DO;
      %LET assertImage_script        = %_abspath(&g_sasunit_os.,assertImage.sh);
      %LET assertImage_NotExistend   = NotExistendFile.sh;
      %LET assertImage_CompTool      = diff;
      %LET assertImage_OS            =Linux;
      %LET assertImage_mod1          =-i;
      %LET assertImage_mod2          =-b;
      %LET assertImage_image1        =%_abspath(&g_work.,rose.jpg);
      %LET assertImage_image2        =%_abspath(&g_work.,rose_copy.jpg);
      %LET assertImage_image3        =%_abspath(&g_work.,reconstruct.jpg);
      %LET assertImage_image4        =%_abspath(&g_work.,class.png);
      %LET assertImage_image5        =%_abspath(&g_work.,class1.png);
   %END;
%MEND _adaptToOS;

/* create test files */
%_createtestfiles;
%_adaptToOS;

%let scnid = %substr(00&g_scnid,%length(&g_scnid));

/* test case 1 ------------------------------------ */
%initTestcase(
             i_object   = assertImage.sas
            ,i_desc     = Check test setup
   )
%endTestcall()

%assertEquals(i_actual=%SYSFUNC(FILEEXIST(&g_work./rose.jpg))       , i_expected=1, i_desc=File successful copied);
%assertEquals(i_actual=%SYSFUNC(FILEEXIST(&g_work./rose_copy.jpg))  , i_expected=1, i_desc=File successful copied);
%assertEquals(i_actual=%SYSFUNC(FILEEXIST(&g_work./reconstruct.jpg)), i_expected=1, i_desc=File successful modified);

/* test case 2 ------------------------------------ */
%initTestcase(
             i_object   = assertImage.sas
            ,i_desc     = Texts with invalid input parameters
   )
%endTestcall()

%assertImage(i_script          =&assertImage_NotExistend.
            ,i_image1          =&assertImage_image1.  
            ,i_image2          =&assertImage_image2.    
            ,i_expected        =1
            ,i_modifier        =-metric RMSE
            ,i_threshold       =
            ,i_desc            =Scipt does not exist
            );                        
           
   %markTest()
      %assertDBValue(tst,exp,1#)
      %assertDBValue(tst,act,-2#)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);

%assertImage(i_script          =&assertImage_script.
            ,i_image1          =&assertImage_NotExistend.  
            ,i_image2          =&assertImage_image2.    
            ,i_expected        =1                   
            ,i_modifier        =-metric RMSE
            ,i_threshold       =
            ,i_desc            =Image1 does not exist
            );
   %markTest()
      %assertDBValue(tst,exp,1#)
      %assertDBValue(tst,act,-3#)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
           
%assertImage(i_script          =&assertImage_script.
            ,i_image1          =&assertImage_image1.  
            ,i_image2          =&assertImage_NotExistend.    
            ,i_expected        =1                   
            ,i_modifier        =-metric RMSE
            ,i_threshold       =
            ,i_desc            =Image2 does not exist
            );
   %markTest()
      %assertDBValue(tst,exp,1#)
      %assertDBValue(tst,act,-4#)
      %assertDBValue(tst,res,2)
      %assertMustFail(i_casid=&casid.,i_tstid=&tstid.);
           
   %assertLog (i_errors=0, i_warnings=0);

   /* test case 3 ------------------------------------ */
%initTestcase(
             i_object   = assertImage.sas
            ,i_desc     = Texts with invalid input parameters
   )
%endTestcall()

%assertImage(i_script          =&assertImage_script.
            ,i_image1          =&assertImage_image1.  
            ,i_image2          =&assertImage_image2.    
            ,i_expected        =0                   
            ,i_modifier        =-metric RMSE                  
            ,i_threshold       =
            ,i_desc            =Images match
            );
            
%assertImage(i_script          =&assertImage_script.
            ,i_image1          =&assertImage_image1.  
            ,i_image2          =&assertImage_image3.    
            ,i_expected        =1                   
            ,i_modifier        =-metric RMSE                  
            ,i_threshold       =
            ,i_desc            =Images do not match
            );

%assertImage(i_script          =&assertImage_script.
            ,i_image1          =&assertImage_image1.  
            ,i_image2          =&assertImage_image3.    
            ,i_expected        =0                   
            ,i_modifier        =-metric ae                  
            ,i_threshold       =%nrbquote(-fuzz 25%)
            ,i_desc            =%str(Images do not match, but threshold param used with fuzz)
            );
            
%assertImage(i_script          =&assertImage_script.
            ,i_image1          =&assertImage_image4.  
            ,i_image2          =&assertImage_image5.
            ,i_expected        =1                   
            ,i_modifier        =-metric RMSE                  
            ,i_threshold       =
            ,i_desc            =%str(Comparence of pngs, images do not match)
            );

/** \endcond */